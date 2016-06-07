#Load Required Packages
library(dplyr)
library(reshape2)

#Getting List of Subjects
test_subjects<- read.table("./test/subject_test.txt", header=F)
train_subjects<- read.table("./train/subject_train.txt", header=F)

#Loading X and Y Data
train_x <- read.table("./train/X_train.txt")
train_y <- read.table("./train/Y_train.txt")

test_x <- read.table("./test/X_test.txt")
test_y <- read.table("./test/Y_test.txt")


#Loading Names of Variables
features <- read.table("./features.txt")
features <- features[,2]

#Assigning the Variable Names in the Datasets
names(test_x)<- features
names(train_x)<- features

#Creating a list of relevant variables
getvars <- grepl("mean|std", features)
vars <- subset(features, getvars)
vars <- as.character(vars)

#Subsetting Data
test_x <- test_x[vars]
train_x<- train_x[vars]

#Load and assign Activity Labels
activity<- read.table("./activity_labels.txt")
activity<- activity[,2]
test_y[,2] = activity[test_y[,1]]
train_y[,2] = activity[train_y[,1]]

names(test_y) = c("Activity_ID", "Activity_Label")
names(test_subjects) = "subject"
names(train_y) = c("Activity_ID", "Activity_Label")
names(train_subjects) = "subject"


#Combine the Data
test_data <- cbind(test_subjects, test_y, test_x)
train_data <- cbind(train_subjects, train_y, train_x)
data<- rbind(test_data, train_data)


#Create Tidy Data
id_labels   = c("subject", "Activity_ID", "Activity_Label")
melt_data      = melt(data, id = id_labels, measure.vars = vars)
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")

