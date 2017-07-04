# Set current working directory
setwd("~/Documents/kaggle/mercedes-benz-greener-manufacturing")
# setwd("~/mercedes-benz-greener-manufacturing")

# Import libraries
library(reshape2)

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
train <- train[, -which(names(train) %in% duplicate_columns)]
test <- test[, -which(names(test) %in% duplicate_columns)]

# Find and drop pairs of columns that complement each other
rows <- nrow(train)
complementary_cols <- c()
for (name1 in names(train)) {
  for (name2 in names(train)) {
    if (name1<name2 &&
        sum(as.numeric(as.character(train[[name1]]))) +
        sum(as.numeric(as.character(train[[name2]]))) == rows) {
      if (all(xor(as.numeric(as.character(train[[name1]])),
                  as.numeric(as.character(train[[name2]]))))) {
        print(paste0(name1, " is a complement of ", name2))
        complementary_cols <- c(complementary_cols, name2)  # One of those is irrelevant
      }
    }
  }
}
train <- train[, -which(names(train) %in% complementary_cols)]
test <- test[, -which(names(test) %in% complementary_cols)]

# Find groups of three columns which are complementary and group into a factor
# Done manually since triple loop takes a while
melted <- melt(train[, c("ID", "X111", "X112", "X113")], id="ID")
melted <- melted[melted$value==1,]
train[["X111::X112::X113"]] <- melted$variable
train <- train[, -which(names(train) %in% c("X111", "X112", "X113"))]
melted <- melt(test[, c("ID", "X111", "X112", "X113")], id="ID")
melted <- melted[melted$value==1,]
test[["X111::X112::X113"]] <- melted$variable
test <- test[, -which(names(test) %in% c("X111", "X112", "X113"))]

# Try linear model
fit <- lm(y ~ ., data = train)
summary(fit)
prediction <- data.frame(ID=test$ID, y=predict(fit, test))

write.csv(prediction, file = "./data/submission.csv", row.names = FALSE, quote = FALSE)
