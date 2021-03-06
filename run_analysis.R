# PART 1: MERGE THE TRAINING AND THE TEST SETS
# Download training data
setwd("C:/coursera/GettingData/train")
X_train <- read.table("X_train.txt", sep = '	', header = FALSE)
Y_train <- read.table("Y_train.txt", sep = '	', header = FALSE)
subject_train <- read.table("subject_train.txt", sep = "", header = FALSE)

# Combine training data 
train <- cbind(X_train,Y_train,subject_train)

# Download test data
setwd("C:/coursera/GettingData/test")
X_test <- read.table("X_test.txt", sep = '	', header = FALSE)
Y_test <- read.table("Y_test.txt", sep = '	', header = FALSE)
subject_test <- read.table("subject_test.txt", sep = "", header = FALSE)
# Combine test data 
test <- cbind(X_test, Y_test,subject_test)
#Merge the training and the test
data <- rbind(train,test)


# PART 2: EXTRACT ONLY MEASUREMENTS ON THE MEAN AND
# STANDRD DEVIATION

# Download feature names
setwd("C:/coursera/GettingData")
features <- read.table("features.txt", sep = " ", header = FALSE)
features <- features[,2]

#Find indexes of "the mean" features
ind_mean <- grep('[Mm]ean',features)

#Find indexes of "the standard deviation" features
ind_std <- grep('std',features)


# extract measurments of mean and stadard deviation
data <- data[,c(ind_std,ind_mean,ncol(data)-1,ncol(data))]

# 3 USE DESCRIPTIVE ACTIVITY NAMES TO NAME ACTIVITIES
#give names to collums
colnames(data) <- c(as.character(features[c(ind_std,ind_mean)]), "Activities", "Subjects")

# Change labels in activity collum
data$Activities <- factor(data$Activities,
                           labels= c("WALKING","WALKING_UPSTAIRS",
                                     "WALKING_DOWNSTAIRS","SITTING",
                                      "STANDING","LAYING"))


# 4 LABEL THE DATASET WITH BETTER VARIABLE NAMES

# remove characters like  "()" "-" from variable names
colnames(data) <- gsub("-", "", colnames(data))
colnames(data) <- gsub("\\(\\)", "", colnames(data))

# Create descriptive variable names
colnames(data) <- gsub("^t", "Time", colnames(data))
colnames(data) <- gsub("^f", "Frequency", colnames(data))
colnames(data) <- gsub("std", "Std", colnames(data))
colnames(data) <- gsub("mean", "Mean", colnames(data))
colnames(data) <- gsub("Acc", "Accelerometer", colnames(data))
colnames(data) <- gsub("Gyro", "Gyroscope", colnames(data))
colnames(data) <- gsub("Mag", "Magnitude", colnames(data))

# Write clean dataset
write.table(data,"clean.csv", sep = ",")



# CREATE SECOND TIDY DATA SET
names(data)
data$Subjects <- as.factor(data$Subjects)
attach(data)
step5 <- aggregate(data[,c(-(ncol(data)-1),-ncol(data))],
                         by=list(Subjects,Activities),
                         FUN = mean, na.rm = TRUE)
names(step5)[c(1,2)] <- c("Subjects", "Activities")
detach(data)
# write required after step 5 file
write.table(step5, "step5.txt", sep= ",", row.name=FALSE)


