# Getting and Cleaning Data - Course Project

### Data Acquisition

The dataset is downloaded from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 23.05.2022, 13:30 UTC+2 and unziped in R.

### Data Used

From `UCI HAR Dataset/` the files `[test/train]/X_[test/train].txt` are used for the calculations, and the `[test/train]/y_[test/train].txt` and `[test/train]/subject_[test/train].txt` are used to assign the data to an activity and subject respectively.
The 561-feature vector in the `X_[test/train].txt` files contain normalized time and frequency domain variables in preparation for a machine learning model, which is why they don't have a dimension.
The activities are stored as integers $\in [1, 6]$, which are translated in `activity_labels.txt` by
```
  1 WALKING
  2 WALKING_UPSTAIRS
  3 WALKING_DOWNSTAIRS
  4 SITTING
  5 STANDING
  6 LAYING
```
The Subjects are also stored as integers $\in [1, 30]$. The internal signal data is neglected.

### Data Processing

The 561-feature vector from the `X_[test/train].txt` are used to calculate a mean and standard deviation value for each measurement (row) respectively. In the processes data set, those values are called `acc.mean` and `acc.std`.
This and the merging of the test and train data sets happens in the function `get_data()` and is stored in a data frame called `data_set`.

In the next step, the data is sorted by subject and activity, to merge the data further.
This happens by calculating the mean of `acc.mean` and `acc.std` for each subject and activity respectively, which is then stored in a data frame called `mean_data`.

If you want to change the `get_data()` function, please note that if you execute the script, this is only called if the workspace does not contain the `data_set` data frame.
