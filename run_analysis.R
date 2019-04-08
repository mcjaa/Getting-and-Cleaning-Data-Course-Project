## STEP 0: ----
## Prepare Datasets

rm(list=ls())
library(reshape2)
getwd()
setwd("D:\\Coursera\\data\\UCI HAR Dataset")

# read data
subject_train <- read.table("./train/subject_train.txt")
subject_test <- read.table("./test/subject_test.txt")
X_train <- read.table("./train/X_train.txt")
X_test <- read.table("./test/X_test.txt")
y_train <- read.table("./train/y_train.txt")
y_test <- read.table("./test/y_test.txt")

# subject Info
colnames(subject_train)
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"


# features Info
featureNames <- read.table("features.txt")
head(featureNames,3)
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2

names(y_train) <- "actNm"
names(y_test) <- "actNm"

# combine files (cbind)
cb_train <- cbind(subject_train, y_train, X_train)
cb_test <- cbind(subject_test, y_test, X_test)



## STEP 1: ----
## Merges the training and the test sets to create one data set. 
cb_all <- rbind(cb_train, cb_test)




## STEP 2: ----
## Extracts only the measurements on the mean and standard deviation for each measurement. 

# grep "mean()" or "std()"
idx <- grepl("mean\\(\\)", names(cb_all)) |grepl("std\\(\\)", names(cb_all))

# keep the subjectID and activity columns
cb_all_MS <- cbind(cb_all[1:2], cb_all[, idx])




## STEP 3, 4: ----
## Uses descriptive activity names to name the activities n the data set
## Appropriately labels the data set with descriptive variable names. 

cb_all_MS$actNm <- factor(cb_all_MS$actNm, 
                          labels=c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))


## STEP 5: ----
## From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.


# create the tidy data set
melted <- melt(cb_all_MS, id=c("subjectID","actNm"))
tidy <- dcast(melted, subjectID+actNm ~ variable, mean)

# write the tidy data set to a file
write.csv(tidy, "tidy.csv", row.names=FALSE)
