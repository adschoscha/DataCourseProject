zip_file <- "Dataset.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" # nolint
if (!file.exists(zip_file))
  download.file(url, zip_file)
unzip(zip_file)