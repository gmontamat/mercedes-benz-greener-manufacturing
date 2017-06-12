# Set current working directory
setwd("~/Documents/kaggle/mercedes-benz-greener-manufacturing")


# Load train set
train <- read.csv("./data/train.csv", stringsAsFactors = FALSE)
test <- read.csv("./data/test.csv", stringsAsFactors = FALSE)

not_features <- c("ID", "y")

# Convert features to factors
train[!(names(train) %in% not_features)] <- lapply(train[!(names(train) %in% not_features)], as.factor)
test[!(names(test) %in% not_features)] <- lapply(test[!(names(test) %in% not_features)], as.factor)


# Filter features with only one level
filter_single_level <- sapply(train[-which(names(train) %in% not_features)], nlevels) > 1
# Filter features with insufficient levels in train data
filter_insufficient_levels <- 
  sapply(train[-which(names(train) %in% not_features)], nlevels) >=
  sapply(test[-which(names(test) %in% not_features)], nlevels)

filter <- filter_single_level & filter_insufficient_levels
filter_train <- c(TRUE, TRUE, filter)
filter_test <- c(TRUE, filter)


# Naive model: multiple regression with valid features only
fit <- lm(y ~ . - ID, data = train[filter_train])
summary(fit)
prediction <- data.frame(ID=test$ID, y=predict(fit, test[filter_test]))

write.csv(prediction, file = "./data/submission.csv", row.names = FALSE, quote = FALSE)
