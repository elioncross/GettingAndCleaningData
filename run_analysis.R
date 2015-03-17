## Coursera Course Title: Getting and Cleaning Data
## Coursera Course ID: getdata-012
## Project: Getting and Cleaning Data Course Project
## Student: Ruben Leon

## 1. Merges the training and the test sets to create one data set.

subjects <- rbind(read.table('./UCI HAR Dataset/train/subject_train.txt'), read.table('./UCI HAR Dataset/test/subject_test.txt'))

activity_labels = read.table('./UCI HAR Dataset/activity_labels.txt', col.names=c("ActivityID", "ActivityName"))
activities <- rbind(read.table('./UCI HAR Dataset/train/Y_train.txt'), read.table('./UCI HAR Dataset/test/Y_test.txt'))

feature_names = read.table('./UCI HAR Dataset/features.txt')

X_train = read.table('./UCI HAR Dataset/train/X_train.txt')
X_test = read.table('./UCI HAR Dataset/test/X_test.txt')

colnames(X_train)  <- feature_names$V2
colnames(X_test)  <- feature_names$V2

all_set = rbind(X_train, X_test)

## 2. Extracts only the measurements on the mean and standard deviation for each 
## measurement. 

meanSTDColIndexes  <- grep(".*mean\\(\\)|.*std\\(\\)", colnames(all_set))
meanSTD_set  <-  all_set[,meanSTDColIndexes] 
meanSTD_set$SubjectID <- subjects$V1
meanSTD_set$ActivityID <- activities$V1

## 3. Uses descriptive activity names to name the activities in the data set

meanSTD_set  <-  merge(meanSTD_set,activity_labels)

## 4. Appropriately labels the data set with descriptive variable names.

labels <- colnames(meanSTD_set)
labels <- gsub('\\(|\\)',"", labels)
labels <- gsub('\\-',"", labels)  
labels <- gsub('\\,',"",  labels)
labels <- gsub('mean', labels, replacement="Mean")
labels <- gsub('std',  labels, replacement="Std")
colnames(meanSTD_set) <- labels

## 5. From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.

library(doBy)
tidydata <- summaryBy(.~ SubjectID + ActivityID + ActivityName, keep.names=TRUE, data=meanSTD_set, FUN=c(mean))

write.table(tidydata,file="tidydata.txt",row.name=FALSE )