## Variables

One variable called ActivityName was added that uses a descriptive activity name to name the activities in the data set

## Original Data

A full description of the original data is available at the site:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

## Transformations

1. after train and test data is merged only the measurements on the mean and standard deviation are extracted for each measurement
2. the acitivity names are added by linking the ActivityIDs in the data with the ones in the file `activity_labels.txt`
3. columns names are tranformed by replacing the words (mean and std) with (Mean and Std), and removing parentheses and dashes
4. a new data set is created with the average of each variable for each activity and each subject and variables names are kept
