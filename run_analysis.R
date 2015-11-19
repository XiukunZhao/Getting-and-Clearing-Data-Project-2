# Prepare tidy data that can be used for later analysis

library(data.table)
library(reshape2)

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]
# Load activity labels and data column names

extract_features <- grepl("mean|std", features)
# Extract only the measurements on the mean and standard deviation for each measurement

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

names(X_test) = features

X_test = X_test[,extract_features]
# Extract only the measurements on the mean and standard deviation for each measurement

y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

test_data <- cbind(as.data.table(subject_test), y_test, X_test)
# Bind data

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_train) = features

X_train = X_train[,extract_features]
# Extract only the measurements on the mean and standard deviation for each measurement

y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

train_data <- cbind(as.data.table(subject_train), y_train, X_train)
# Bind data

data = rbind(test_data, train_data)
# Merge the test and the training sets to create one data set

id_labels = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data = melt(data, id = id_labels, measure.vars = data_labels)

tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, mean)
# Apply mean function to dataset using dcast function

write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)
# A txt file is created 
