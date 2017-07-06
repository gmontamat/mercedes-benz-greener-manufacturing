# Set current working directory
# setwd("~/Documents/kaggle/mercedes-benz-greener-manufacturing")
setwd("~/mercedes-benz-greener-manufacturing")

# Source required scripts
source("./scripts/data_load.R")

# Remove columns with only one level
filter <- sapply(train[-which(names(train) %in% not_factors)], nlevels) > 1
train <- train[, c(TRUE, TRUE, filter)]
test <- test[, c(TRUE, filter)]

# Remove features X0 through X8
train <- train[, -which(names(train) %in% c("X0","X1", "X2", "X3", "X4", "X5", "X6", "X8"))]
test <- test[, -which(names(test) %in% c("X0","X1", "X2", "X3", "X4", "X5", "X6", "X8"))]

# Remove outlier
train <- train[train$y<250,]

# Find and delete columns with the same content
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

# Find groups of four columns which are complementary and group into a factor
rows <- nrow(train)
for (name1 in names(train)) {
  for (name2 in names(train)) {
    for (name3 in names(train)) {
      for (name4 in names(train)) {
        if (name1<name2 && name2<name3 && name3<name4 &&
            sum(as.numeric(as.character(train[[name1]]))) +
            sum(as.numeric(as.character(train[[name2]]))) +
            sum(as.numeric(as.character(train[[name3]]))) +
            sum(as.numeric(as.character(train[[name4]]))) == rows) {
          if (all(xor(xor(xor(as.numeric(as.character(train[[name1]])),
                              as.numeric(as.character(train[[name2]]))),
                          as.numeric(as.character(train[[name3]]))),
                      as.numeric(as.character(train[[name4]]))))) {
            print(c(name1, name2, name3, name4))
          }
        }
      }
    }
  }
}

# Find groups of three columns which are complementary and group into a factor
rows <- nrow(train)
for (name1 in names(train)) {
  for (name2 in names(train)) {
    for (name3 in names(train)) {
      if (name1<name2 && name2<name3 &&
          sum(as.numeric(as.character(train[[name1]]))) +
          sum(as.numeric(as.character(train[[name2]]))) +
          sum(as.numeric(as.character(train[[name3]]))) == rows) {
        if (all(xor(xor(as.numeric(as.character(train[[name1]])),
                        as.numeric(as.character(train[[name2]]))),
                    as.numeric(as.character(train[[name3]]))))) {
          print(c(name1, name2, name3))
        }
      }
    }
  }
}

# Find and drop pairs of columns that complement each other
complementary_cols <- c()
for (name1 in names(train)) {
  for (name2 in names(train)) {
    if (name1<name2 &&
        sum(as.numeric(as.character(train[[name1]]))) +
        sum(as.numeric(as.character(train[[name2]]))) == rows) {
      if (all(xor(as.numeric(as.character(train[[name1]])),
                  as.numeric(as.character(train[[name2]]))))) {
        print(paste0(name1, " is a complement of ", name2))
        complementary_cols <- c(complementary_cols, name2)
      }
    }
  }
}
# train <- train[, -which(names(train) %in% complementary_cols)]
# test <- test[, -which(names(test) %in% complementary_cols)]
