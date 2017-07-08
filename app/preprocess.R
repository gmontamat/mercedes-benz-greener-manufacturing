# Set current working directory
setwd("~/Documents/kaggle/mercedes-benz-greener-manufacturing")
# setwd("~/mercedes-benz-greener-manufacturing")

# Import libraries
library(forcats)

# Load train set
train <- read.csv("./data/train.csv", stringsAsFactors = FALSE)
test <- read.csv("./data/test.csv", stringsAsFactors = FALSE)

not_factors <- c("ID", "y")

# Convert features to factors
train[!(names(train) %in% not_factors)] <- lapply(train[!(names(train) %in% not_factors)], as.factor)
test[!(names(test) %in% not_factors)] <- lapply(test[!(names(test) %in% not_factors)], as.factor)

# Remove columns with only one level
filter <- sapply(train[-which(names(train) %in% not_factors)], nlevels) > 1
train <- train[, c(TRUE, TRUE, filter)]
test <- test[, c(TRUE, filter)]

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

# Fix factor levels
# X0 levels
train$X0 <- factor(train$X0, levels = sort(unique(c(levels(train$X0), levels(test$X0)))))
test$X0 <- factor(test$X0, levels = sort(unique(c(levels(train$X0), levels(test$X0)))))

train$X0 <- factor(train$X0, levels = names(sort(table(train$X0), decreasing = TRUE)))
test$X0 <- factor(test$X0, levels = names(sort(table(train$X0), decreasing = TRUE)))

train$X0 <- train$X0 %>% fct_collapse(lt = c("aa", "q", "ab", "ac", "ae", "ag", "an", "av", "bb", "p"))
test$X0 <- test$X0 %>% fct_collapse(lt = c("aa", "q", "ab", "ac", "ae", "ag", "an", "av", "bb", "p"))

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

# X5 levels
train$X5 <- factor(train$X5, levels = sort(unique(c(levels(train$X5), levels(test$X5)))))
test$X5 <- factor(test$X5, levels = sort(unique(c(levels(train$X5), levels(test$X5)))))

train$X5 <- factor(train$X5, levels = names(sort(table(train$X5), decreasing = TRUE)))
test$X5 <- factor(test$X5, levels = names(sort(table(train$X5), decreasing = TRUE)))

train$X5 <- train$X5 %>% fct_collapse(lt = c("u", "a", "b", "t", "z"))
test$X5 <- test$X5 %>% fct_collapse(lt = c("u", "a", "b", "t", "z"))

# Find pairs of columns that complement each other and generate a new feature for each pair
rows <- nrow(train)
binary_features <- names(train)[11:length(names(train))]
for (name1 in binary_features) {
  for (name2 in binary_features) {
    if (name1<name2 &&
        sum(as.numeric(as.character(train[[name1]]))) +
        sum(as.numeric(as.character(train[[name2]]))) == rows) {
      if (all(xor(as.numeric(as.character(train[[name1]])),
                  as.numeric(as.character(train[[name2]]))))) {
        train[[paste(name1, name2, sep = "::")]] <- as.factor(ifelse(
          train[[name1]]=="1", name1, name2))
        test[[paste(name1, name2, sep = "::")]] <- as.factor(ifelse(
          test[[name1]]=="1", name1, name2))
      }
    }
  }
}

# Find groups of three columns which are complementary and group into a factor
# Groups written manually since triple loop takes a while
groups <- matrix(c("X111", "X112", "X113",
                   "X130", "X189", "X232",
                   "X136", "X162", "X310",
                   "X136", "X232", "X236",
                   "X186", "X187", "X54"), nrow = 5, ncol = 3, byrow = TRUE)
for (i in 1:5) {
  train[[paste(groups[i, 1], groups[i, 2], groups[i, 3], sep = "::")]] <- as.factor(
    ifelse(train[[groups[i, 1]]]=="1", groups[i, 1],
           ifelse(train[[groups[i, 2]]]=="1", groups[i, 2], groups[i, 3])))
  test[[paste(groups[i, 1], groups[i, 2], groups[i, 3], sep = "::")]] <- as.factor(
    ifelse(test[[groups[i, 1]]]=="1", groups[i, 1],
           ifelse(test[[groups[i, 2]]]=="1", groups[i, 2], groups[i, 3])))
}

# Save preprocessed datasets
write.csv(train, file = "./data/train_preprocessed.csv", row.names = FALSE, quote = FALSE)
write.csv(test, file = "./data/test_preprocessed.csv", row.names = FALSE, quote = FALSE)
