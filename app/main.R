# Set current working directory
setwd("~/mercedes-benz-greener-manufacturing")

# Load train set
train <- read.csv("./data/train.csv", stringsAsFactors = FALSE)
test <- read.csv("./data/test.csv", stringsAsFactors = FALSE)

not_features <- c("ID", "y")

# Convert features to factors
train[!(names(train) %in% not_features)] <- lapply(train[!(names(train) %in% not_features)], as.factor)
test[!(names(test) %in% not_features)] <- lapply(test[!(names(test) %in% not_features)], as.factor)

# Remove columns with only one level
filter <- sapply(train[-which(names(train) %in% not_features)], nlevels) > 1
train <- train[, c(TRUE, TRUE, filter)]
test <- test[, c(TRUE, filter)]

# Remove features X0 through X8
train <- train[, -which(names(train) %in% c("X0","X1", "X2", "X3", "X4", "X5", "X6", "X8"))]
test <- test[, -which(names(test) %in% c("X0","X1", "X2", "X3", "X4", "X5", "X6", "X8"))]

# Remove outlier
train <- train[train$y<250,]

# Remove columns with the same content
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

# Find complementary columns
rows <- nrow(train)
for (name1 in names(train)) {
  for (name2 in names(train)) {
    if (name1<name2 &&
        sum(as.numeric(as.character(train[[name1]]))) +
        sum(as.numeric(as.character(train[[name2]]))) == rows) {
      if (all(xor(as.numeric(as.character(train[[name1]])),
                  as.numeric(as.character(train[[name2]]))))) {
        print(c(name1, name2)) 
      }
    }
  }
}


for (name1 in names(train)) {
  for (name2 in names(train)) {
    for (name3 in names(train)) {
      if (name1<name2 && name2<name3 &&
          sum(as.numeric(as.character(train[[name1]]))) +
          sum(as.numeric(as.character(train[[name2]]))) +
          sum(as.numeric(as.character(train[[name3]]))) == rows) {
        print(c(name1, name2, name3))
      }
    }
  }
}
