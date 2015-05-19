
## Get the test data set

tst.Data <- read.table("UCI_HAR_Dataset/test/X_test.txt") 


## Get the training data set

trg.Data <- read.table("UCI_HAR_Dataset/train/X_train.txt") 

## Read the label data and subject data into separate data frames

trg.Label <- read.table("./UCI_HAR_Dataset/train/y_train.txt")
trg.Subject <- read.table("./UCI_HAR_Dataset/train/subject_train.txt")


tst.Label <- read.table("./UCI_HAR_Dataset/test/y_test.txt") 
tst.Subject <- read.table("./UCI_HAR_Dataset/test/subject_test.txt")

full.Data <- rbind(trg.Data, tst.Data)
full.Label <- rbind(trg.Label, tst.Label)
full.Subject <- rbind(trg.Subject, tst.Subject)

rm(tst.Data, trg.Data, tst.Label, trg.Label, tst.Subject, trg.Subject)

# My approach is to create a new file called subset_features.txt. I manually edited this
# to have the column indices and labels of the columns I need (i.e ones with the
# mean and standard deviation data)
#

ftrs.Data <- read.table("./UCI_HAR_Dataset/subset_features.txt")
required.Indices <- ftrs.Data$V1
required.Indices <- as.numeric(required.Indices)

required.Data <- full.Data[, required.Indices]

# Let us save some memory
rm(full.Data)

# Assign column names to our filtered dataset

names(required.Data) <- ftrs.Data$V2



act.Labels <- read.table("./UCI_HAR_Dataset/activity_labels.txt")
act.Labels$V2 <- as.character(act.Labels$V2)
txt.Activity <- character()
for( i in 1: nrow(full.Label)) 
  txt.Activity[i] <- act.Labels$V2[full.Label$V1[i]]

required.Data$Activity <- txt.Activity
required.Data$Subject <- full.Subject$V1

# Save the processed data to a file names cleaned_data.txt
#

write.table(required.Data, "cleaned_data.txt")

subject.Split <- split(required.Data, required.Data$Subject)

numSubjects <- length(subject.Split)

tidy.data <- matrix(NA, nrow=180, ncol= ncol(required.Data))
tidy.data <- as.data.frame(tidy.data)
colnames(tidy.data) <- colnames(required.Data)

for(i in 1: numSubjects) {
  activity.Split <- split(subject.Split[[i]], subject.Split[[i]]$Activity)
  numActivities <- length(activity.Split)

  for (j in 1: numActivities) {
  
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

write.table(tidy.data, "tidy_data.txt", row.names = FALSE)


