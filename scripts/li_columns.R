# Set current working directory
setwd("~/Documents/kaggle/mercedes-benz-greener-manufacturing")
# setwd("~/mercedes-benz-greener-manufacturing")

# Import libraries
library(pracma)

# Load train set
train <- read.csv("./data/train.csv", stringsAsFactors = FALSE)
test <- read.csv("./data/test.csv", stringsAsFactors = FALSE)

not_factors <- c("ID", "y")

# Convert features to factors
train[!(names(train) %in% not_factors)] <- lapply(train[!(names(train) %in% not_factors)], as.factor)
test[!(names(test) %in% not_factors)] <- lapply(test[!(names(test) %in% not_factors)], as.factor)

# Remove columns with only one level
filter <- sapply(train[-which(names(train) %in% not_factors)], nlevels) > 1
train <- train[, c(TRUE, TRUE, filter)]
test <- test[, c(TRUE, filter)]

# Remove features X0 through X8
train <- train[, -which(names(train) %in% c("X0","X1", "X2", "X3", "X4", "X5", "X6", "X8"))]
test <- test[, -which(names(test) %in% c("X0","X1", "X2", "X3", "X4", "X5", "X6", "X8"))]

# Remove outlier
train <- train[train$y<250,]

# Obtain maximum set of linearly independent columns
# using reduced row echelon form
M <- apply(as.matrix(sapply(train[, -which(names(train) %in% not_factors)], as.character)), 2, as.numeric)
Mrreef <- rref(M)
li_columns <- apply(Mrreef, 2, function(x) head(x[x!=0],1))==1
rm(M, Mrreef) # Remove matrices to save RAM

train <- train[, c(TRUE, TRUE, li_columns)]
test <- test[, c(TRUE, li_columns)]

# Remove columns with the same content
duplicate_columns <- c()
for (name1 in names(train)) {
  for (name2 in names(train)) {
    if (name1<name2 && identical(train[[name1]], train[[name2]])) {
      duplicate_columns <- c(duplicate_columns, name2)
    }
  }
}
duplicate_columns <- unique(duplicate_columns)

# Try linear model
fit <- lm(y ~ .-ID, data = train)
summary(fit)
prediction <- data.frame(ID=test$ID, y=predict(fit, test))

write.csv(prediction, file = "./data/submission.csv", row.names = FALSE, quote = FALSE)
