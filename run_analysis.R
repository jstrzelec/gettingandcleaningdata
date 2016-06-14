
# 
# script to create tidy data set from study 
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# 
# space-delimited text files contain 
#  - 'feature labels' of data collected (mean, std, max, ...)
#  - 'activity labels' (walking, running, ...) that correspond with activity codes 
#  - separate text files for data for 'test' and 'trial' study subjects (30 total subjects)
#  - separate text files listing 'activity' and 'subject' for each data record
#
# this script reads the data records files, and for each,
# cbind()'s the 'activity' (code) and 'subject' for each data record
# 
# those two data frames are then put into a single data frame,
# human-readable activity labels are added as a new column,
# and then a subset of columns is taken (just mean and std features)
#
# finally a mean summary is produced, grouped by subject and activity
#


# read in human-readable labels for 'features' 
# of data records (column names)
# and activity labels
features <- read.table('UCI HAR Dataset/features.txt',header=F)
activity_labels <- read.table('UCI HAR Dataset/activity_labels.txt',header=F)

# create data frame for 'test' subjects
# next section of code does same for 'train' subjects
har_test <- read.table('UCI HAR Dataset/test/X_test.txt', header = F, stringsAsFactors= F)
# add column to represent 'subject'
har_test_subject <- read.table('UCI HAR Dataset/test/subject_test.txt', header = F, stringsAsFactors= F)
har_test <- cbind(har_test,har_test_subject)
# add column to represent 'activitycode'
har_test_labels <- read.table('UCI HAR Dataset/test/y_test.txt', header = F, stringsAsFactors= F)
har_test <- cbind(har_test,har_test_labels)

har_train <- read.table('UCI HAR Dataset/train/X_train.txt', header = F, stringsAsFactors= F)
har_train_subject <- read.table('UCI HAR Dataset/train/subject_train.txt', header = F, stringsAsFactors= F)
har_train <- cbind(har_train,har_train_subject)
har_train_labels <- read.table('UCI HAR Dataset/train/y_train.txt', header = F, stringsAsFactors= F)
har_train <- cbind(har_train,har_train_labels)

# create one data frame by combining 'test' and 'train' data frames
har <- rbind(har_test,har_train)

# add column names
numfeatures <- length(features$V2)
colnames(har) <- features$V2
colnames(har)[numfeatures+1] <- "subject" 
colnames(har)[numfeatures+2] <- "activitycode" 

# add new column representing activity label
har$activity <- activity_labels$V2[match(har$activitycode,activity_labels$V1)]

# only keep subset of columns
har <- har[,grepl("std|mean|subject|activity", colnames(har))]

# create summary of means, grouped by subject & activity
har_means <- ddply(har,.(subject,activity),numcolwise(mean))

