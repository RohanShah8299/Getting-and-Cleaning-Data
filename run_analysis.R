#Downloading and unzipping the data set
library(data.table)
fileurl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('./UCI HAR Dataset.zip')){
    download.file(fileurl,'./UCI HAR Dataset.zip', mode = 'wb')
    unzip("UCI HAR Dataset.zip", exdir = getwd())
}

#Get list of all features
features <- read.csv('./UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
features <- as.character(features[,2])

#Combine the traing data set, by combinig readings, subject IDs and Activity IDs
data.train.x <- read.table('./UCI HAR Dataset/train/X_train.txt')
data.train.activity <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
data.train.subject <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')

#Assign Column Names(according to features)  for ease of analysis 
data.train <-  data.frame(data.train.subject, data.train.activity, data.train.x)
names(data.train) <- c(c('subject', 'activity'), features)

#Combine the test data set, by combinig readings, subject IDs and Activity IDs
data.test.x <- read.table('./UCI HAR Dataset/test/X_test.txt')
data.test.activity <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
data.test.subject <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')

#Assign Column Names(according to features)  for ease of analysis 
data.test <-  data.frame(data.test.subject, data.test.activity, data.test.x)
names(data.test) <- c(c('subject', 'activity'), features)

#Combine Test and Training Datasets
data.all <- rbind(data.train, data.test)

#Extract measurements of mean and standard deviation for each measurement
mean_std.select <- grep('mean|std', features)
data.sub <- data.all[,c(1,2,mean_std.select + 2)]

#Replace Activity ID's with names instead
activity.labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
activity.labels <- as.character(activity.labels[,2])
data.sub$activity <- activity.labels[data.sub$activity]

#format names as perconventions for ease of access during analysis
name.new <- names(data.sub)
name.new <- gsub("[(][)]", "", name.new)
name.new <- gsub("^t", "timedomain_", name.new)
name.new <- gsub("^f", "frequencydomain_", name.new)
name.new <- gsub("Acc", "accelerometer", name.new)
name.new <- gsub("Gyro", "gyroscope", name.new)
name.new <- gsub("Mag", "magnitude", name.new)
name.new <- gsub("-mean-", "_mean_", name.new)
name.new <- gsub("-std-", "_standarddeviation_", name.new)
name.new <- gsub("-", "_", name.new)
names(data.sub) <- name.new

#Finally data aggregated to mean and exported as tidy dataset 
data.tidy <- aggregate(data.sub[,3:81], by = list(activity = data.sub$activity, subject = data.sub$subject),FUN = mean)
write.table(x = data.tidy, file = "data_tidy.txt", row.names = FALSE)
