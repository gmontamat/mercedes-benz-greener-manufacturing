# Set current working directory
# setwd("~/Documents/kaggle/mercedes-benz-greener-manufacturing")
setwd("~/mercedes-benz-greener-manufacturing")

# Load train and test sets
train <- read.csv("./data/train.csv", stringsAsFactors = FALSE)
test <- read.csv("./data/test.csv", stringsAsFactors = FALSE)

not_factors <- c("ID", "y")

# Convert features to factors
train[!(names(train) %in% not_factors)] <- lapply(train[!(names(train) %in% not_factors)], as.factor)
test[!(names(test) %in% not_factors)] <- lapply(test[!(names(test) %in% not_factors)], as.factor)
