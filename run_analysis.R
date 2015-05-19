## This is Uday's run_analysis.R
## Submitted to Coursera: Getting and Cleaning Data - Peer Assessment project


## 1. Get the test data set from X_test.txt

tst.Data <- read.table("UCI_HAR_Dataset/test/X_test.txt") 


## 2. Get the training data set from X_train.txt

trg.Data <- read.table("UCI_HAR_Dataset/train/X_train.txt") 

## 3. Read the label data and subject data into separate data frames
##
##    Activity labels for each row in the data set is available in y_test.txt
##    and y_train.txt respectively
##
##    Subject data for each row in the data set is available in subject_test.txt
##    and subject_train.txt

tst.Label <- read.table("./UCI_HAR_Dataset/test/y_test.txt") 
tst.Subject <- read.table("./UCI_HAR_Dataset/test/subject_test.txt")

trg.Label <- read.table("./UCI_HAR_Dataset/train/y_train.txt")
trg.Subject <- read.table("./UCI_HAR_Dataset/train/subject_train.txt")

## 4. Combine test and training dataset into one data frame

full.Data <- rbind(trg.Data, tst.Data)
full.Label <- rbind(trg.Label, tst.Label)
full.Subject <- rbind(trg.Subject, tst.Subject)

rm(tst.Data, trg.Data, tst.Label, trg.Label, tst.Subject, trg.Subject)

# My approach is to create a new file called subset_features.txt. I manually edited this
# to have the column indices and labels of the columns I need (i.e ones with the
# mean and standard deviation data)
#

## 5. Get the subset data indices and column names from the file
##    subset_features.txt

ftrs.Data <- read.table("./UCI_HAR_Dataset/subset_features.txt")
required.Indices <- ftrs.Data$V1
required.Indices <- as.numeric(required.Indices)

## 6. Get rid of unwanted columns. We need only 66 columns

required.Data <- full.Data[, required.Indices]

# Let us save some memory
rm(full.Data)

# Assign column names to our filtered dataset

## 7. Name the target - cleaned data set

names(required.Data) <- ftrs.Data$V2


## 8. Translate activity codes to activity names. Code to name mapping is
##    available in activity_labels.txt - This is our code book

act.Labels <- read.table("./UCI_HAR_Dataset/activity_labels.txt")
act.Labels$V2 <- as.character(act.Labels$V2)
txt.Activity <- character()
for( i in 1: nrow(full.Label)) 
  txt.Activity[i] <- act.Labels$V2[full.Label$V1[i]]

## 9. Append two columns to cleaned data set, namely Activity Labels and Subject code

required.Data$Activity <- txt.Activity
required.Data$Subject <- full.Subject$V1

## 10. Save the processed data to a file names cleaned_data.txt
#

write.table(required.Data, "cleaned_data.txt")

## 11. Get the subjectwise split using the split function

subject.Split <- split(required.Data, required.Data$Subject)

numSubjects <- length(subject.Split) # We should get 30 subjects

## 12. Create the container data frame for the tidy data set

tidy.data <- matrix(NA, nrow=180, ncol= ncol(required.Data))
tidy.data <- as.data.frame(tidy.data)
colnames(tidy.data) <- colnames(required.Data)

for(i in 1: numSubjects) {

  ## 13. For each subject get the activity wise split
  
  activity.Split <- split(subject.Split[[i]], subject.Split[[i]]$Activity)
  numActivities <- length(activity.Split)

  for (j in 1: numActivities) {
  
    ## 14. For each activity group for a selected subject, compute the
    ##     column means and store into tidy.data
    ##
    ##     Add the activity label and subject code to the row
  
    # Compute tidy data index
    index <- ((i-1) * numActivities) + j

    # Compute and add column means for accelerometer mean/std data
    
#   print(str(activity.Split[[j]]))
#   message(sprintf("i = %d, j = %d, index = %d\n", i, j, index))
#   scan("")

    tidy.data[index,1:66] <- colMeans(activity.Split[[j]][,1:66])
    # Add the activity name
    tidy.data[index, 67] <- activity.Split[[j]]$Activity[1]
    # Add the subject identifier
    tidy.data[index, 68] <- activity.Split[[j]]$Subject[1]
  }
}



## 15. Melt the data into a simpler format

library(reshape)
tidy.data <- melt(tidy.data, id=c("Subject","Activity"))

## 16. Now we have the final version of tidy.data. Write to a file with
##     row.names = FALSE

write.table(tidy.data, "tidy_data.txt", row.names = FALSE)

## End of run_analysis.R