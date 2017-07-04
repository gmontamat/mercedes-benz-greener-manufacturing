# Set current working directory
setwd("~/Documents/kaggle/mercedes-benz-greener-manufacturing")

# Load train and test sets
train <- read.csv("./data/train.csv", stringsAsFactors = FALSE)
test <- read.csv("./data/test.csv", stringsAsFactors = FALSE)

not_features <- c("ID", "y")

# Convert features to factors
train[!(names(train) %in% not_features)] <- lapply(train[!(names(train) %in% not_features)], as.factor)
test[!(names(test) %in% not_features)] <- lapply(test[!(names(test) %in% not_features)], as.factor)
