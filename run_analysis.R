url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" # nolint
zip_file <- "Dataset.zip"
data_root <- "UCI HAR Dataset"
test_files <- c("X_test.txt", "y_test.txt", "subject_test.txt")
train_files <- c("X_train.txt", "y_train.txt", "subject_train.txt")
test_files <- paste(data_root, "test", test_files, sep = "/")
train_files <- paste(data_root, "train", train_files, sep = "/")

## load data into working directory if not present
if (!file.exists(zip_file))
  download.file(url, zip_file)
if (!dir.exists(data_root))
  unzip(zip_file)

## access data
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
  if (act==1) return("WALKING")
  if (act==2) return("WALKING_UPSTAIRS")
  if (act==3) return("WALKING_DOWNSTAIRS")
  if (act==4) return("SITTING")
  if (act==5) return("STANDING")
  if (act==6) return("LAYING")
}
labels <- c("acc.mean", "acc.std", "activity", "subject")
test_data <- read_data(test_files, labels)
train_data <- read_data(train_files, labels)
join_data <- merge(test_data, train_data, all = TRUE)
join_data$activity <- lapply(join_data$activity, map_activity)