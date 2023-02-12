projectfile <- "getdata_projectfiles_UCI HAR Dataset"
if (!file.exists(projectfile)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(URL, projectfile, method = "curl")
}
if(!file.exists("UCI HAR Dataset")){
  unzip(projectfile)
}
features <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt",col.names = c("n","functions"))
activity <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt",col.names = c("code","activity"))
subject_test <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt",col.names = "subject")
x_test <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt",col.names = features$functions)
y_test <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt",col.names = "code")
subjext_train <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt",col.names = "subject")
x_train <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt",col.names = features$functions)
y_train <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt",col.names = "code")
x <- rbind(x_train,x_test)
y <- rbind(y_train,y_test)
subject <- rbind(subjext_train,subject_test)
merge_data <- cbind(subject,x,y)
mean_std <- merge_data %>% select(subject,code,contains("mean"),contains("std"))
mean_std$code <- activity[mean_std$code, 2]
names(mean_std)[2] = "activity"
names(mean_std) <- gsub("Acc","Accelerator",names(mean_std))
names(mean_std) <- gsub("Gyro","Gyroscope",names(mean_std))
names(mean_std) <- gsub("BodyBody","Body",names(mean_std))
names(mean_std) <- gsub("Mag","Magnitude",names(mean_std))
names(mean_std) <- gsub("^t","Time",names(mean_std))
names(mean_std) <- gsub("^f","Frequency",names(mean_std))
names(mean_std) <- gsub("tBody","TimeBody",names(mean_std))
names(mean_std) <- gsub("-mean()","mean",names(mean_std), ignore.case = TRUE)
names(mean_std) <- gsub("-std()","std",names(mean_std), ignore.case = TRUE)
names(mean_std) <- gsub("-freq()","Frequency",names(mean_std), ignore.case = TRUE)
tidy_data <- mean_std %>% group_by(subject,activity) %>% summarise_all(funs(mean))
write.table(tidy_data, "tidydata.txt", row.names = FALSE)
