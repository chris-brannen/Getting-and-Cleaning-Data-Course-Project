# Read in features and assign to column_names
features <- read.table("UCI HAR Dataset\\features.txt", sep=" ")
column_names <- features[,2]

# Read in activities and assign to activity_labels
activity_labels <- read.table("UCI HAR Dataset\\activity_labels.txt", sep=" ")

# Read in training data and label column names
trainData <- read.table(file="UCI HAR Dataset\\train\\X_train.txt", sep="")
colnames(trainData) <- column_names

# Read in training data activities, assign column name, and transform Activity column from numeric to 
# descriptive named factor form.
trainData_y <- read.table(file="UCI HAR Dataset\\train\\y_train.txt", sep="")
colnames(trainData_y) <- "Activity"
trainData_y$Activity <- factor(trainData_y$Activity, levels = activity_labels[,1], labels = activity_labels[,2])

# Read in training data subjects and assign column name
subject_train <- read.table(file="UCI HAR Dataset\\train\\subject_train.txt", sep="")
colnames(subject_train) <- "Subject"

# column bind Subject, Activity, and Data into one data.frame for training data.
trainData <- cbind(subject_train,trainData_y,trainData)

# Read in test data and label column names
testData <- read.table(file="UCI HAR Dataset\\test\\X_test.txt", sep="")
colnames(testData) <- column_names

# Read in test data activities, assign column name, and transform Activity column from numeric to 
# descriptive named factor form.
testData_y <- read.table(file="UCI HAR Dataset\\test\\y_test.txt", sep="")
colnames(testData_y) <- "Activity"
testData_y$Activity <- factor(testData_y$Activity, levels = activity_labels[,1], labels = activity_labels[,2])

# Read in test data subjects and assign column name
subject_test <- read.table(file="UCI HAR Dataset\\test\\subject_test.txt", sep="")
colnames(subject_test) <- "Subject"

# column bind Subject, Activity, and Data into one data.frame for test data.
testData <- cbind(subject_test,testData_y,testData)

# Row Bind the trainData and testData into a merged data.frame named mergedData
mergedData <- rbind(trainData, testData)

# Find all columns that represent a mean, standard deviation, as 
# well as any columns that are based upon a mean or a standard deviation.
mean_column_indices <- features[grep("MEAN",sapply(features[,2],toupper)),1]
std_column_indices <- features[grep("STD",sapply(features[,2],toupper)),1]
extraction_column_indices <- c(mean_column_indices, std_column_indices)
extraction_column_indices <- sort(extraction_column_indices)
# Add 2 to all extraction column indices to make room for Subject and Activity as
# the first two columns of the tidy data set.
extraction_column_indices <- extraction_column_indices + 2
extraction_column_indices <- c(1,2,extraction_column_indices)
# Extract the Subject, Activity, and all mean and standard deviation based 
# columns and store in data.frame prep_for_tidy_data.
prep_for_tidy_data <- mergedData[,extraction_column_indices]

# While grouping by Subject and Activity, compute the mean of all numeric columns
# such that we now have a tidy data set containing means of means and means of standard 
# deviations for the data grouped by Subject and Activity.
tidy_data <- aggregate(prep_for_tidy_data[,3:88], by = list(prep_for_tidy_data$Subject,prep_for_tidy_data$Activity), FUN = "mean")
# Assign column names to tidy data set so that the first two columns
# are named Subject and Activity instead of Group.1 and Group.2
colnames(tidy_data) <- colnames(prep_for_tidy_data)
# Write the tidy data set out to a text file named tidy_data.txt without row names.
write.table(tidy_data, file="data\\tidy_data.txt",row.names=FALSE,col.names=TRUE)