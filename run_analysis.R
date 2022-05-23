## file name and url
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" # nolint
zip_file <- "Dataset.zip"
data_root <- "UCI HAR Dataset"
test_files <- c("X_test.txt", "y_test.txt", "subject_test.txt")
train_files <- c("X_train.txt", "y_train.txt", "subject_train.txt")
test_files <- paste(data_root, "test", test_files, sep = "/")
train_files <- paste(data_root, "train", train_files, sep = "/")

## access data, return a single data frame
get_data <- function() {
  read_data <- function(files, labels) {
    data1 <- read.table(files[1])
    df <- data.frame(
      apply(data1, 1, mean),
      apply(data1, 1, sd),
      scan(files[2]),
      scan(files[3])
    )
    names(df) <- labels
    df
  }
  map_activity <- function(act) {
    if (act == 1) return("WALKING")
    if (act == 2) return("WALKING_UPSTAIRS")
    if (act == 3) return("WALKING_DOWNSTAIRS")
    if (act == 4) return("SITTING")
    if (act == 5) return("STANDING")
    if (act == 6) return("LAYING")
  }
  labels <- c("acc.mean", "acc.std", "activity", "subject")
  test_data <- read_data(test_files, labels)
  train_data <- read_data(train_files, labels)
  join_data <- merge(test_data, train_data, all = TRUE)
  join_data$activity <- sapply(join_data$activity, map_activity)
  join_data
}

## sort the data and calculate the mean of each acc.mean and acc.std
## returns a data frame sorted by subject
get_mean_data <- function(data_set) {
  ## split by subject and activity
  sorted_list <- split(data_set, paste(data_set$subject, data_set$activity))
  mean_list <- list(); i <- 0
  for (i in seq(length(sorted_list))) {
    ## loop over split list
    df <- sorted_list[[i]]
    acc_mean <- mean(as.numeric(df$acc.mean))
    acc_std <- mean(as.numeric(df$acc.std))
    mean_list[[i]] <- data.frame(
      subject = df$subject[1],
      activity = df$activity[[1]],
      acc.mean = acc_mean,
      acc.std = acc_std
    )
  }
  ## a lot of transformations because I don't understand R
  mean_list <- t(sapply(mean_list, as.data.frame))
  mean_list <- apply(mean_list, 2, unlist, use.names = FALSE)
  mean_df <- data.frame(mean_list)
  mean_df$subject <- as.numeric(mean_df$subject)
  mean_df$acc.mean <- as.numeric(mean_df$acc.mean)
  mean_df$acc.std  <- as.numeric(mean_df$acc.std)
  mean_df[order(mean_df$subject), ]
}

## --- MAIN

## load data into working directory if not present
if (!file.exists(zip_file))
  download.file(url, zip_file)
if (!dir.exists(data_root))
  unzip(zip_file)

## load data set if not in already in global environment
if (!("data_set" %in% ls()))
  ## this covers step 1-4
  data_set <- get_data()
## and this step 5
mean_data <- get_mean_data(data_set)
