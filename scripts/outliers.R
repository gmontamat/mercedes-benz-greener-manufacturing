# Set current working directory
setwd("~/Documents/kaggle/mercedes-benz-greener-manufacturing")

# Source required scripts
source("./scripts/multiplot.R")

# Import libraries
library(ggplot2)

# Load train set
train <- read.csv("./data/train.csv", stringsAsFactors = FALSE)
test <- read.csv("./data/test.csv", stringsAsFactors = FALSE)

not_features <- c("ID", "y")

# Convert features to factors
train[!(names(train) %in% not_features)] <- lapply(train[!(names(train) %in% not_features)], as.factor)
test[!(names(test) %in% not_features)] <- lapply(test[!(names(test) %in% not_features)], as.factor)

# Boxplot
boxplot_original <- ggplot(train, aes("seconds", y)) + geom_boxplot() + xlab("") + ggtitle("Original")

# Remove outlier
train <- train[train$y<250,]
boxplot_no_outliers <- ggplot(train, aes("seconds", y)) + geom_boxplot() + xlab("") + ggtitle("No outliers")

multiplot(boxplot_original, boxplot_no_outliers, cols = 2)
