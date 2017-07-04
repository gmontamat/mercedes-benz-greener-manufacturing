# Set current working directory
setwd("~/Documents/kaggle/mercedes-benz-greener-manufacturing")

# Load train and test sets
train <- read.csv("./data/train.csv", stringsAsFactors = FALSE)
test <- read.csv("./data/test.csv", stringsAsFactors = FALSE)

not_factors <- c("ID", "y")

# Convert features to factors
train[!(names(train) %in% not_factors)] <- lapply(train[!(names(train) %in% not_factors)], as.factor)
test[!(names(test) %in% not_factors)] <- lapply(test[!(names(test) %in% not_factors)], as.factor)

# Filter features with only one level
filter_single_level <- sapply(train[-which(names(train) %in% not_factors)], nlevels) > 1
# Filter features with insufficient levels in train data
filter_insufficient_levels <- 
  sapply(train[-which(names(train) %in% not_factors)], nlevels) >=
  sapply(test[-which(names(test) %in% not_factors)], nlevels)

filter <- filter_single_level & filter_insufficient_levels
filter_train <- c(TRUE, TRUE, filter)
filter_test <- c(TRUE, filter)

# Naive model: multiple regression with valid features only
fit <- lm(y ~ . - ID, data = train[filter_train])
summary(fit)
prediction <- data.frame(ID=test$ID, y=predict(fit, test[filter_test]))

write.csv(prediction, file = "./data/submission.csv", row.names = FALSE, quote = FALSE)
