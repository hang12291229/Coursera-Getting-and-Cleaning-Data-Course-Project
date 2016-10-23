#download the zip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="Dataset.zip", mode="wb")
unzip(zipfile="Dataset.zip", exdir="Dataset")

#Reading trainings tables:
x_train <- read.table("./Dataset/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./Dataset/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./Dataset/UCI HAR Dataset/train/subject_train.txt")

#Reading testing tables:
x_test <- read.table("./Dataset/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./Dataset/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./Dataset/UCI HAR Dataset/test/subject_test.txt")

#Reading feature vector:
features <- read.table('./Dataset/UCI HAR Dataset/features.txt')

#Reading activity labels:
activityLabels = read.table('./Dataset/UCI HAR Dataset/activity_labels.txt')

#Assigning Column Names:
colnames(x_train) <- features[ , 2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
colnames(x_test) <- features[ , 2]
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activityLabels) <- c('activityId','activityType')

#Merging all data in one set:
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
Merged <- rbind(mrg_train, mrg_test)

#Extracting measurements on the mean and standard deviation for each measurement
#Reading Column names:
colNames <- colnames(Merged)

#Create vector for defining ID, mean and standard deviation:
mean_and_std <- (grepl("activity..",colNames) | 
grepl("subject..",colNames) | 
grepl("mean..",colNames) & !grepl("meanFreq..",colNames) & !grepl("mean..-",colNames) | 
grepl("std..",colNames) & !grepl("std()..-",colNames))

#Subset from Merged
subsetMerged <- Merged[ , mean_and_std == TRUE]

#Name the activities in the data set:
ActivityNames <- merge(subsetMerged, activityLabels,
by='activityId' ,
all.x=TRUE)

#Create a second, independent tidy data set
#Making second tidy data set
TidySet <- aggregate(.~subjectId + activityType, ActivityNames, mean)
TidySet <- TidySet[ order(TidySet$subjectId, TidySet$activityType) ,]

#Writing second tidy data set
write.table(TidySet, "TidySet.txt", row.name=FALSE)