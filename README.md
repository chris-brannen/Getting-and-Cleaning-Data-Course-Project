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
 

