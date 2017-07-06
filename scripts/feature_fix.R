# Set current working directory
setwd("~/Documents/kaggle/mercedes-benz-greener-manufacturing")
# setwd("~/mercedes-benz-greener-manufacturing")

# Source required scripts
source("./scripts/multiplot.R")

# Import libraries
library(ggplot2)
library(forcats)

# Load train set
train <- read.csv("./data/train.csv", stringsAsFactors = FALSE)
test <- read.csv("./data/test.csv", stringsAsFactors = FALSE)

not_factors <- c("ID", "y")

# Convert features to factors
train[!(names(train) %in% not_factors)] <- lapply(train[!(names(train) %in% not_factors)], as.factor)
test[!(names(test) %in% not_factors)] <- lapply(test[!(names(test) %in% not_factors)], as.factor)

# X0 levels
train$X0 <- factor(train$X0, levels = sort(unique(c(levels(train$X0), levels(test$X0)))))
test$X0 <- factor(test$X0, levels = sort(unique(c(levels(train$X0), levels(test$X0)))))

train$X0 <- factor(train$X0, levels = names(sort(table(train$X0), decreasing = TRUE)))
test$X0 <- factor(test$X0, levels = names(sort(table(train$X0), decreasing = TRUE)))

train$X0 <- train$X0 %>% fct_collapse(lt = c("aa", "q", "ab", "ac", "ae", "ag", "an", "av", "bb", "p"))
test$X0 <- test$X0 %>% fct_collapse(lt = c("aa", "q", "ab", "ac", "ae", "ag", "an", "av", "bb", "p"))

multiplot(
  ggplot(train, aes(X0)) + geom_bar() + scale_x_discrete(drop=FALSE) + ggtitle("X0 - Train"),
  ggplot(test, aes(X0)) + geom_bar() + scale_x_discrete(drop=FALSE) + ggtitle("X0 - Test"),
  cols = 1
)

# X2 levels
train$X2 <- factor(train$X2, levels = sort(unique(c(levels(train$X2), levels(test$X2)))))
test$X2 <- factor(test$X2, levels = sort(unique(c(levels(train$X2), levels(test$X2)))))

train$X2 <- factor(train$X2, levels = names(sort(table(train$X2), decreasing = TRUE)))
test$X2 <- factor(test$X2, levels = names(sort(table(train$X2), decreasing = TRUE)))

train$X2 <- train$X2 %>%
  fct_collapse(lt = c("y", "an", "av", "au", "aa", "af", "am", "ar", "c", "j", "l", "o", "ab", "ad",
                      "aj", "ax", "u", "w"))
test$X2 <- test$X2 %>%
  fct_collapse(lt = c("y", "an", "av", "au", "aa", "af", "am", "ar", "c", "j", "l", "o", "ab", "ad",
                      "aj", "ax", "u", "w"))

multiplot(
  ggplot(train, aes(X2)) + geom_bar() + scale_x_discrete(drop=FALSE) + ggtitle("X2 - Train"),
  ggplot(test, aes(X2)) + geom_bar() + scale_x_discrete(drop=FALSE) + ggtitle("X2 - Test"),
  cols = 1
)

# X5 levels
train$X5 <- factor(train$X5, levels = sort(unique(c(levels(train$X5), levels(test$X5)))))
test$X5 <- factor(test$X5, levels = sort(unique(c(levels(train$X5), levels(test$X5)))))

train$X5 <- factor(train$X5, levels = names(sort(table(train$X5), decreasing = TRUE)))
test$X5 <- factor(test$X5, levels = names(sort(table(train$X5), decreasing = TRUE)))

train$X5 <- train$X5 %>% fct_collapse(lt = c("u", "a", "b", "t", "z"))
test$X5 <- test$X5 %>% fct_collapse(lt = c("u", "a", "b", "t", "z"))

multiplot(
  ggplot(train, aes(X5)) + geom_bar() + scale_x_discrete(drop=FALSE) + ggtitle("X5 - Train"),
  ggplot(test, aes(X5)) + geom_bar() + scale_x_discrete(drop=FALSE) + ggtitle("X5 - Test"),
  cols = 1
)
