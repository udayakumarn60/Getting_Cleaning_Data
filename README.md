# Getting_Cleaning_Data
Assignment for the Getting and Cleaning Data coursework
## Procedure used by run_analysis.R
1. Get the test data set from X_test.txt
2. Get the training data set from X_train.txt
3. Read the label data and subject data into separate data frames. Activity labels for each row in the data set is available in y_test.txt and y_train.txt respectively. Subject data for each row in the data set is available in subject_test.txt and subject_train.txt
4. Combine test and training dataset into one data frame
5. Get the subset data indices and column names from the file subset_features.txt
6. Get rid of unwanted columns in the target. We need only 66 columns
7. Name the remaining columns of the target - cleaned data set
8. Translate activity codes to activity names. Code to name mapping is available in activity_labels.txt - This is our code book
9. Append two columns to cleaned data set, namely Activity Labels and Subject code
10. Save the processed data to a file names cleaned_data.txt
11. Get the subjectwise split using the split function
12. Create the container data frame for the tidy data set
13. For each subject (that we got from step 11) get the activity wise split
14.     For each activity group of the selected subject
15.         compute the column means and add it to tidy data set
16.         Add the activity label and the subject code to the row
17. Write the output to tidy_data.txt
We are done!

