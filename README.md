## Introduction

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

 You should create one R script called run_analysis.R that does the following. 
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### 1. Merges the training and the test sets to create one data set.

subjects <- rbind(read.table('./UCI HAR Dataset/train/subject_train.txt'), read.table('./UCI HAR Dataset/test/subject_test.txt'))

activity_labels = read.table('./UCI HAR Dataset/activity_labels.txt', col.names=c("ActivityID", "ActivityName"))
activities <- rbind(read.table('./UCI HAR Dataset/train/Y_train.txt'), read.table('./UCI HAR Dataset/test/Y_test.txt'))

feature_names = read.table('./UCI HAR Dataset/features.txt')

X_train = read.table('./UCI HAR Dataset/train/X_train.txt')
X_test = read.table('./UCI HAR Dataset/test/X_test.txt')

colnames(X_train)  <- feature_names$V2
colnames(X_test)  <- feature_names$V2

all_set = rbind(X_train, X_test)

### 2. Extracts only the measurements on the mean and standard deviation for each 
### measurement. 

meanSTDColIndexes  <- grep(".*mean\\(\\)|.*std\\(\\)", colnames(all_set))
meanSTD_set  <-  all_set[,meanSTDColIndexes] 
meanSTD_set$SubjectID <- subjects$V1
meanSTD_set$ActivityID <- activities$V1

### 3. Uses descriptive activity names to name the activities in the data set

meanSTD_set  <-  merge(meanSTD_set,activity_labels)

### 4. Appropriately labels the data set with descriptive variable names.

labels <- colnames(meanSTD_set)
labels <- gsub('\\(|\\)',"", labels)
labels <- gsub('\\-',"", labels)  
labels <- gsub('\\,',"",  labels)
labels <- gsub('mean', labels, replacement="Mean")
labels <- gsub('std',  labels, replacement="Std")
colnames(meanSTD_set) <- labels

### 5. From the data set in step 4, creates a second, independent tidy data set 
### with the average of each variable for each activity and each subject.

library(doBy)
tidydata <- summaryBy(.~ SubjectID + ActivityID + ActivityName, keep.names=TRUE, data=meanSTD_set, FUN=c(mean))

write.table(tidydata,file="tidydata.txt",row.name=FALSE )