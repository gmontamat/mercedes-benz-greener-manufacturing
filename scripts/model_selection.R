# Set current working directory
setwd("~/Documents/kaggle/mercedes-benz-greener-manufacturing")
# setwd("~/mercedes-benz-greener-manufacturing")

# Source required scripts
source("./scripts/feature_fix.R")

# Import libraries
library(leaps)

# Filter features with only one level
filter_single_level <- sapply(train[-which(names(train) %in% not_factors)], nlevels) > 1
# Filter features with insufficient levels in train data
filter_insufficient_levels <- 
  sapply(train[-which(names(train) %in% not_factors)], nlevels) >=
  sapply(test[-which(names(test) %in% not_factors)], nlevels)

filter <- filter_single_level & filter_insufficient_levels
filter_train <- c(TRUE, TRUE, filter)
filter_test <- c(TRUE, filter)

# Model selection
fit.f <- regsubsets(y ~ . - ID, data = train[filter_train],
                    nvmax = 100, method = "forward", really.big = TRUE)
summary(fit.f)
prediction <- data.frame(ID=test$ID, y=predict(fit.f, test[filter_test]))
