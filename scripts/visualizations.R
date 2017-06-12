# Set current working directory
setwd("~/Documents/kaggle/mercedes-benz-greener-manufacturing")

# Import libraries
library(ggplot2)

# Load train set
train <- read.csv("./data/train.csv", stringsAsFactors = FALSE)
test <- read.csv("./data/test.csv", stringsAsFactors = FALSE)

not_features <- c("ID", "y")

# Convert features to factors
train[!(names(train) %in% not_features)] <- lapply(train[!(names(train) %in% not_features)], as.factor)
test[!(names(test) %in% not_features)] <- lapply(test[!(names(test) %in% not_features)], as.factor)

# X0 levels
train$X0 <- factor(train$X0, levels = sort(unique(c(levels(train$X0), levels(test$X0)))))
test$X0 <- factor(test$X0, levels = sort(unique(c(levels(train$X0), levels(test$X0)))))

train$X0 <- factor(train$X0, levels = names(sort(table(train$X0), decreasing = TRUE)))
test$X0 <- factor(test$X0, levels = names(sort(table(train$X0), decreasing = TRUE)))

train$X0 %>% fct_collapse(long_tail = c("aa", "q", "ab", "ac", "g", "ae", "ag", "an", "av", "bb", "p"))

multiplot(
  ggplot(train, aes(X0)) + geom_bar() + scale_x_discrete(drop=FALSE) + ggtitle("X0 - Train"),
  ggplot(test, aes(X0)) + geom_bar() + scale_x_discrete(drop=FALSE) + ggtitle("X0 - Test"),
  cols = 1
)
