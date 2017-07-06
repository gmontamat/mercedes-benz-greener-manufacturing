# Set current working directory
setwd("~/Documents/kaggle/mercedes-benz-greener-manufacturing")
# setwd("~/mercedes-benz-greener-manufacturing")

# Source required scripts
source("./scripts/multiplot.R")

# Import libraries
library(ggplot2)

# Load train set
train <- read.csv("./data/train.csv", stringsAsFactors = FALSE)
test <- read.csv("./data/test.csv", stringsAsFactors = FALSE)

not_factors <- c("ID", "y")

# Convert features to factors
train[!(names(train) %in% not_factors)] <- lapply(train[!(names(train) %in% not_factors)], as.factor)
test[!(names(test) %in% not_factors)] <- lapply(test[!(names(test) %in% not_factors)], as.factor)

# Boxplot
boxplot_original <- ggplot(train, aes("seconds", y)) + geom_boxplot() + xlab("") + ggtitle("Original")

# Remove outlier
train <- train[train$y<250,]
boxplot_no_outliers <- ggplot(train, aes("seconds", y)) + geom_boxplot() + xlab("") + ggtitle("No outliers")

multiplot(boxplot_original, boxplot_no_outliers, cols = 2)
