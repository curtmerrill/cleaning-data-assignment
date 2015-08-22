# Create a tidy data set from raw data collected by sensors on a smartphone
# Working directory should be the root of the Git repository

# Create a directory to store the processed data
if(!file.exists("./data")) {
  dir.create("./data")
}

trainSubjects <- read.csv("raw_data/train/subject_train.txt", header=FALSE)
testSubjects <- read.csv("raw_data/test/subject_test.txt", header=FALSE)

# rename subject columns so we can use rbind()
names(trainSubjects)[names(trainSubjects)=='V1'] <- 'subject'
names(testSubjects)[names(testSubjects)=='V1'] <- 'subject'

# Combine subjects
allSubjects <- rbind(trainSubjects, testSubjects)

# Convert subjects to factor variable
allSubjects$subject <- factor(allSubjects$subject)

# remove separated subjects from environment to save memory
rm(trainSubjects)
rm(testSubjects)

# Repeat load-merge-cleanup process for activities
trainActivities <- read.csv("raw_data/train/y_train.txt", header=FALSE)
testActivities <- read.csv("raw_data/test/y_test.txt", header=FALSE)

allActivities <- rbind(trainActivities, testActivities)

rm(trainActivities)
rm(testActivities)

# Load activity key
activity_key = read.csv("./raw_data/activity_labels.txt", header=FALSE, sep="")

# Find activity label for each activity ID
allActivities$label <- activity_key$V2[allActivities$V1]

# combine activity label and subject
myData <- cbind(allSubjects,allActivities$label)

# rename activity column to make it more readable
names(myData)[names(myData)=='allActivities$label'] <- 'activity'

# clean up environment
rm(activity_key)
rm(allActivities)
rm(allSubjects)

# get test and training data
trainData = read.csv("./raw_data/train/X_train.txt", header=FALSE, sep="")
testData = read.csv("./raw_data/test/X_test.txt", header=FALSE, sep="")

# combine data and clean up environment
allData <- rbind(trainData, testData)
rm(trainData)
rm(testData)

# name columns of combined data frame
columnNames = read.csv("./raw_data/features.txt", header=FALSE, sep="")
colnames(allData) <- columnNames$V2

# add columns with means and standard deviations to main data frame
for(n in colnames(allData)) {
  if( grepl("(mean\\(\\)|std\\(\\))", n) ) {
    myData[[n]] <- allData[[n]]
  }
}

# rename columns
colnames(myData) <- c("subject","activity","TimeBodyAccMeanX","TimeBodyAccMeanY","TimeBodyAccMeanZ","TimeBodyAccStdevX","TimeBodyAccStdevY","TimeBodyAccStdevZ","TimeGravityAccMeanX","TimeGravityAccMeanY","TimeGravityAccMeanZ","TimeGravityAccStdevX","TimeGravityAccStdevY","TimeGravityAccStdevZ","TimeBodyAccJerkMeanX","TimeBodyAccJerkMeanY","TimeBodyAccJerkMeanZ","TimeBodyAccJerkStdevX","TimeBodyAccJerkStdevY","TimeBodyAccJerkStdevZ","TimeBodyGyroMeanX","TimeBodyGyroMeanY","TimeBodyGyroMeanZ","TimeBodyGyroStdevX","TimeBodyGyroStdevY","TimeBodyGyroStdevZ","TimeBodyGyroJerkMeanX","TimeBodyGyroJerkMeanY","TimeBodyGyroJerkMeanZ","TimeBodyGyroJerkStdevX","TimeBodyGyroJerkStdevY","TimeBodyGyroJerkStdevZ","TimeBodyAccMagMean","TimeBodyAccMagStdev","TimeGravityAccMagMean","TimeGravityAccMagStdev","TimeBodyAccJerkMagMean","TimeBodyAccJerkMagStdev","TimeBodyGyroMagMean","TimeBodyGyroMagStdev","TimeBodyGyroJerkMagMean","TimeBodyGyroJerkMagStdev","FourBodyAccMeanX","FourBodyAccMeanY","FourBodyAccMeanZ","FourBodyAccStdevX","FourBodyAccStdevY","FourBodyAccStdevZ","FourBodyAccJerkMeanX","FourBodyAccJerkMeanY","FourBodyAccJerkMeanZ","FourBodyAccJerkStdevX","FourBodyAccJerkStdevY","FourBodyAccJerkStdevZ","FourBodyGyroMeanX","FourBodyGyroMeanY","FourBodyGyroMeanZ","FourBodyGyroStdevX","FourBodyGyroStdevY","FourBodyGyroStdevZ","FourBodyAccMagMean","FourBodyAccMagStdev","FourBodyBodyAccJerkMagMean","FourBodyBodyAccJerkMagStdev","FourBodyBodyGyroMagMean","FourBodyBodyGyroMagStdev","FourBodyBodyGyroJerkMagMean","FourBodyBodyGyroJerkMagStdev")

# save data
write.csv(myData, "./data/clean_data.csv")

# reshape data (make it tall and skinny)
library(reshape2)
myDataMelt <- melt(myData, id=c("subject","activity"), measure.vars=c("TimeBodyAccMeanX","TimeBodyAccMeanY","TimeBodyAccMeanZ","TimeBodyAccStdevX","TimeBodyAccStdevY","TimeBodyAccStdevZ","TimeGravityAccMeanX","TimeGravityAccMeanY","TimeGravityAccMeanZ","TimeGravityAccStdevX","TimeGravityAccStdevY","TimeGravityAccStdevZ","TimeBodyAccJerkMeanX","TimeBodyAccJerkMeanY","TimeBodyAccJerkMeanZ","TimeBodyAccJerkStdevX","TimeBodyAccJerkStdevY","TimeBodyAccJerkStdevZ","TimeBodyGyroMeanX","TimeBodyGyroMeanY","TimeBodyGyroMeanZ","TimeBodyGyroStdevX","TimeBodyGyroStdevY","TimeBodyGyroStdevZ","TimeBodyGyroJerkMeanX","TimeBodyGyroJerkMeanY","TimeBodyGyroJerkMeanZ","TimeBodyGyroJerkStdevX","TimeBodyGyroJerkStdevY","TimeBodyGyroJerkStdevZ","TimeBodyAccMagMean","TimeBodyAccMagStdev","TimeGravityAccMagMean","TimeGravityAccMagStdev","TimeBodyAccJerkMagMean","TimeBodyAccJerkMagStdev","TimeBodyGyroMagMean","TimeBodyGyroMagStdev","TimeBodyGyroJerkMagMean","TimeBodyGyroJerkMagStdev","FourBodyAccMeanX","FourBodyAccMeanY","FourBodyAccMeanZ","FourBodyAccStdevX","FourBodyAccStdevY","FourBodyAccStdevZ","FourBodyAccJerkMeanX","FourBodyAccJerkMeanY","FourBodyAccJerkMeanZ","FourBodyAccJerkStdevX","FourBodyAccJerkStdevY","FourBodyAccJerkStdevZ","FourBodyGyroMeanX","FourBodyGyroMeanY","FourBodyGyroMeanZ","FourBodyGyroStdevX","FourBodyGyroStdevY","FourBodyGyroStdevZ","FourBodyAccMagMean","FourBodyAccMagStdev","FourBodyBodyAccJerkMagMean","FourBodyBodyAccJerkMagStdev","FourBodyBodyGyroMagMean","FourBodyBodyGyroMagStdev","FourBodyBodyGyroJerkMagMean","FourBodyBodyGyroJerkMagStdev"))

# calculate mean for each subject and activity
subjectMeans <- dcast(myDataMelt, subject+activity ~ variable, mean)

# output tidy data to 'data' folder
write.table(subjectMeans, "./data/tidy_data.txt", row.names=FALSE)


# TODO: calculate average value per subject/activity combo
