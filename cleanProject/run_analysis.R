###
## This script takes the Samsung dataset from the "Getting and Clearning Data"
## course on Coursera and performs the analysis required for the course project. 
## 
## The accompanying README.md file contains a link to the data, more informmation 
## about the data and the analysis, as well as the codebook.
###


### Read all "test" data
testdata <- list()
testdata$subject <- read.table("test/subject_test.txt")     
testdata$activitycode <- read.table("test/y_test.txt") 
testdata$features <- read.table("test/X_test.txt")

### Read all "training" data
traindata <- list()
traindata$subject <- read.table("train/subject_train.txt")      
traindata$activitycode <- read.table("train/y_train.txt")  
traindata$features <- read.table("train/X_train.txt")

### Read variable and activity names
featureNames <- read.table("features.txt",colClasses="character")
activityNames <- read.table("activity_labels.txt",colClasses="character")

### Merge the two input datasets, attach descriptive names to the variables and activities
alldata <- mapply(rbind,testdata,traindata,SIMPLIFY=FALSE)
names(alldata$features) <- featureNames[[2]]
alldata$activitycode[[1]] <- activityNames[as.numeric(alldata$activitycode[[1]]),2]
names(alldata$subject) <- "subject"
names(alldata$activitycode) <- "activity"

### Keep only the mean and standard deviation features
alldata$features <- alldata$features[,grep("std[()]|mean[()]",names(alldata$features))]
featureNames <- names(alldata$features) ## get shortened list of variable names for later

### Turn the list into a comprehensive data frame and treat subject and activity as factors
alldata <- as.data.frame(alldata)
names(alldata)[-(1:2)] <- featureNames ## fix variable names since as.data.frame messed them up
alldata$subject <- as.factor(alldata$subject)
alldata$activity <- as.factor(alldata$activity)

## Just a bit of cleanup
rm(testdata,traindata,activityNames,featureNames) 

### Create a new, tidy data set which summarizes (averages) the data by activity and subject
averagedata <- aggregate(alldata[,-(1:2)],by=list(alldata$subject,alldata$activity),FUN=mean,na.rm=TRUE)
names(averagedata)[1:2] <- c("subject","activity")  ##fix column names after aggreagting
averagedata <- averagedata[order(averagedata$activity,averagedata$subject),] ##order the data by activity, then subject

### Write summarized data to text file
write.table(averagedata,"course_project_tidyData.txt",row.names=FALSE)
