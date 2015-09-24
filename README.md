#Getting-and-Cleaning-Data-Course-Project
##This file contains a code book and a description of the code that produces the tidy data set ouput in run_analysis.R.

###Assumptions and/or preconditions:

 1. The dataset with top level directory "UCI HAR Dataset" exists within your R working directory.
 2. The "UCI HAR Dataset" contains the following files:

				a.) ..\\UCI HAR Dataset\\activity_labels.txt
				b.) ..\\UCI HAR Dataset\\features.txt
				c.) .\\UCI HAR Dataset\\train\\X_train.txt
				d.) ..\\UCI HAR Dataset\\train\\y_train.txt
				e.) .\\UCI HAR Dataset\\train\\subject_train.txt
				f.) ..\\UCI HAR Dataset\\test\\X_test.txt
				g.) ..\\UCI HAR Dataset\\test\\y_test.txt
				h.) ..\\UCI HAR Dataset\\test\\subject_test.txt
				
 3. There exists a data directory within your R working directory such that the code in run_analysis.R can output to files to within the subdirectory .\\data

###Code Book / Data Dictionary:

 1. features : a data.frame of size 561x2 used to read in and store the features data stored in features.txt.
 2. column_names : an array of length 561 containing the column names for the data stored in X_train.txt and X_test.txt.
 3. activity_labels : a data.frame of size 6x2 used to read in and store the activity labels stored in activity_labels.txt.
 4. trainData : a data.frame initially of size 7352x561 used to read in and store the training data from X_train.txt. Size increases to 7352x563 when I column bind the subject and activity data into the data.frame.
 5. trainData_y : a data.frame of size 7352x1 used to read in and store the activity information for the training data from y_train.txt.
 6. subject_train : a data.frame of size 7352x1 used to read in and store the subject information for the training data from subject_train.txt.
 7. testData : a data.frame initially of size 2947x561 used to read in and store the testing data from X_test.txt. Size increases to 2947x563 when I column bind the subject and activity data into the data.frame.
 8. testData_y : a data.frame of size 2947x1 used to read in and store the activity information for the testing data from y_test.txt.
 9. subject_test : a data.frame of size 2947x1 used to read in and store the subject information for the testing data from subject_test.txt.
 10. mergedData : a data.frame of size 10299x563 containing the merged training and test data sets including subject and activity data.
 11. mean_column_indices : integer array of length 53 containing the column indices that are either means or based upon means of data.
 12. std_column_indices: integer array of length 33 containing the column indices that are either standard deviations or based upon standard deviations.
 13. extraction_column_indices : integer array initially of length 86 containing the column indices that are either means or standard deviations or based upon means or standard deviations. This array length increases to 88 when I add the categorical columns for the subject and the activity.
 14. prep_for_tidy_data : a data.frame of size 10299x88 containing the subject and activity factor variables as well as all of the columns from mergedData that is either a mean or standard deviation or based upon a mean or standard deviation.
 15. tidy_data :  a data.frame of size 180x88 containing the tidy data requested from item number 5 of the course project assignment. This data.frame contains averages grouped by subject and activity of all 86 data columns that were either a mean or standard deviation or based upon a mean or standard deviation.

###Description of How Code Works:
 
I first read in the features from features.txt and assign them to column_names. Then I read in activities from activity_labels.txt and assign them to activity_labels.

	features <- read.table("UCI HAR Dataset\\features.txt", sep=" ")
	column_names <- features[,2]
	activity_labels <- read.table("UCI HAR Dataset\\activity_labels.txt", sep=" ")

Next I read in the training data from X_train.txt into trainData and assign column_names to label trainData's column names. Training data activities from y_train.txt is then read into trainData_y, the column name is set to "Activity" and I transform all the activity numbers in trainData_y$Activity to descriptive factor activity names using the factor function and the activity_labels data.frame. Subject information for the training data is then read into subject_train from subject_train.txt and the column name of subject_train is set to "Subject". 

	trainData <- read.table(file="UCI HAR Dataset\\train\\X_train.txt", sep="")
	colnames(trainData) <- column_names
	trainData_y <- read.table(file="UCI HAR Dataset\\train\\y_train.txt", sep="")
	colnames(trainData_y) <- "Activity"
	trainData_y$Activity <- factor(trainData_y$Activity, levels = activity_labels[,1], labels = activity_labels[,2])
	subject_train <- read.table(file="UCI HAR Dataset\\train\\subject_train.txt", sep="")
	colnames(subject_train) <- "Subject"


I then column bind training subjects, activities, and data into trainData with the line of code:

		trainData <- cbind(subject_train,trainData_y,trainData)

Next I read in the test data from X_test.txt into testData and assign column_names to label testData's column names. Test data activities from y_test.txt is then read into testData_y, the column name is set to "Activity" and I transform all the activity numbers in testData_y$Activity to descriptive factor activity names using the factor function and the activity_labels data.frame. Subject information for the test data is then read into subject_test from subject_test.txt and the column name of subject_test is set to "Subject". 

	testData <- read.table(file="UCI HAR Dataset\\test\\X_test.txt", sep="")
	colnames(testData) <- column_names
	testData_y <- read.table(file="UCI HAR Dataset\\test\\y_test.txt", sep="")
	colnames(testData_y) <- "Activity"
	testData_y$Activity <- factor(testData_y$Activity, levels = activity_labels[,1], labels = activity_labels[,2])
	subject_test <- read.table(file="UCI HAR Dataset\\test\\subject_test.txt", sep="")
	colnames(subject_test) <- "Subject"

I then column bind test subjects, activities, and data into testData with the line of code:

		testData <- cbind(subject_test,testData_y,testData)

I then merge the training and test data sets into data.frame mergedData by row binding trainData and testData with the following line of code:

	mergedData <- rbind(trainData, testData)

Using function grep I then find all column indices that are means or standard deviations or are based upon means or standard deviations and store them in extraction_column_indices. I then add 2 to each column index since I will prepend the Subject and the Activity to the the first two indices in the tidy data set. I then extract the Subject, Activity, and all extraction indices into data.frame prep_for_tidy_data.

	mean_column_indices <- features[grep("MEAN",sapply(features[,2],toupper)),1]
	std_column_indices <- features[grep("STD",sapply(features[,2],toupper)),1]
	extraction_column_indices <- c(mean_column_indices, std_column_indices)
	extraction_column_indices <- sort(extraction_column_indices)
	extraction_column_indices <- extraction_column_indices + 2
	extraction_column_indices <- c(1,2,extraction_column_indices)	
	prep_for_tidy_data <- mergedData[,extraction_column_indices]

I then use the aggregate function to compute the average of the 86 numeric variables while grouping by Subject and Activity. The result is a tidy data frame that contains six averages for each subject. The six averages correspond to the six activities. Thus, each subject has it's own average for each activity. I then rename the columns of this tidy data set and sort the tidy data set first by Subject then by Activity and write it out to a file named "tidy_data.txt" using write.table with row.names=FALSE.

	tidy_data <- aggregate(prep_for_tidy_data[,3:88], by = list(prep_for_tidy_data$Subject,prep_for_tidy_data$Activity), FUN = "mean")

	colnames(tidy_data) <- colnames(prep_for_tidy_data)
	tidy_data <- tidy_data[order(tidy_data$Subject, tidy_data$Activity),]  
	write.table(tidy_data, file="data\\tidy_data.txt",row.names=FALSE,col.names=TRUE)