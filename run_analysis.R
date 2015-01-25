#uses the dplyer package as described in videos
library(dplyr)

#The following code loads the relevent data from the UCI HAR folder
X_test <- read.table("UCI\ HAR\ Dataset/test/X_test.txt")
y_test <- read.table("UCI\ HAR\ Dataset/test/y_test.txt")
subject_test <- read.table("UCI\ HAR\ Dataset/test/subject_test.txt")
X_train <- read.table("UCI\ HAR\ Dataset/train/X_train.txt")
y_train <- read.table("UCI\ HAR\ Dataset/train/y_train.txt")
subject_train <- read.table("UCI\ HAR\ Dataset/train/subject_train.txt")
features <- read.table("UCI\ HAR\ Dataset/features.txt")

#The following merges the training and test sets into 1 data set
X <- rbind(X_test, X_train)
y <- rbind(y_test, y_train)
subject <- rbind(subject_test, subject_train)

#The following adds the subject and activity identifiers to the data
dat <- cbind(subject, y, X)

#The following appropriately labels the data set with descriptive names
colnames(dat) <- c("ID", "Activity", as.character(features$V2))

#The following extracts only measurements on the mean and standard deviation for each measurement
#All columns are selected using the grepl function that have mean or std in their title
meansstd <- dat[ , grepl("mean|std", names(dat))]

#These columns are then used to replace the existing measurements
dat <- cbind(dat[,1:2], meansstd)

#The following appropriately labels the data with descriptive names
dat$Activity <- factor(dat$Activity, levels = c(1,2,3,4,5,6), labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LYING"))

#This creates an independent tidy data set with average of each subject and activity
data_means <- dat %>% group_by(ID, Activity) %>% summarise_each(funs(mean))
write.table(data_summary, "data_means.txt", row.name=FALSE)

