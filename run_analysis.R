##  dim(read.table("UCI HAR Dataset/features.txt"))
##  dim(read.table("UCI HAR Dataset/test/X_test.txt"))
##  dim(read.table("UCI HAR Dataset/train/X_train.txt"))
library(dplyr)
library(plyr)
## read column names and put it into vector
pav <- read.table("UCI HAR Dataset/features.txt", col.names = c("a","b"))
pav2 <- pav[,"b"]
## read observations with column names from pav2 vector
dTest <- cbind(read.table("UCI HAR Dataset/test/X_test.txt", col.names = pav2), Origin = "test")
dTrain <- cbind(read.table("UCI HAR Dataset/train/X_train.txt", col.names = pav2), Origin = "train")

## 1. Merges the training and the test sets to create one data set.
dMerged <- rbind.fill(dTest, dTrain)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
dMergedMean <- select(dMerged, contains(".mean."))
dMergedStd <- select(dMerged, contains(".std."))
dMergedMS <- cbind(dMergedMean, dMergedStd)

## 3. Uses descriptive activity names to name the activities in the data set
pav3 <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("act_id", "activity"))
nTest <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "act_id")
## summary(nTest) to check
nTrain <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "act_id")
## summary(nTrain) to check
nMergedAct <- rbind.fill(nTest, nTrain)
nMergedAct1 = merge(nMergedAct, pav3, by.x = "act_id", by.y = "act_id", all = T)
dMergedA <- cbind(dMergedMS, select(nMergedAct1, activity))

## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set
##    with the average of each variable for each activity and each subject.
sTest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
sTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
sMergedSub <- rbind.fill(sTest, sTrain)
dMergedAll <- cbind(dMergedA, sMergedSub)
dMean <- dMergedAll %>% group_by(activity, Subject) %>% summarise_each(funs(mean))
write.table(dMean, "tidy_data.txt", row.name=FALSE)
