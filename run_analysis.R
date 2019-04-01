#Initially Downloaded All Files into One Folder of Current Working Directory

#training data
training_set <- read.table("./X_train.txt")
training_label <- read.table("./y_train.txt")
training_subject <- read.table("./subject_train.txt")

                      
#test data
testing_set <- read.table("./X_test.txt")
testing_label <- read.table("./y_test.txt")
testing_subject <- read.table("./subject_test.txt")


features <- read.table("./features.txt")
activity_labels = read.table("./activity_labels.txt")
colnames(activity_labels) <- c('activityId','activityType')

colnames(training_set) <- features[,2] 
colnames(training_label) <-"activityId"
colnames(training_subject) <- "subjectId"

colnames(testing_set) <- features[,2] 
colnames(testing_label) <- "activityId"
colnames(testing_subject) <- "subjectId"



#combine data
training_all <- cbind(training_set,training_label, training_subject)
testing_all <- cbind(testing_set,testing_label, testing_subject)

fulldata <- rbind(training_all,testing_all)

#clean labels
names(fulldata)<-gsub("^t", "time", names(fulldata))
names(fulldata)<-gsub("^f", "frequency", names(fulldata))
names(fulldata)<-gsub("Acc", "Accelerometer", names(fulldata))
names(fulldata)<-gsub("Gyro", "Gyroscope", names(fulldata))
names(fulldata)<-gsub("angle", "Angle", names(fulldata))
names(fulldata)<-gsub("Mag", "Magnitude", names(fulldata))
names(fulldata)<-gsub("BodyBody", "Body", names(fulldata))

#mean and standard deviation
mean_std <- (          grepl("activityId" , colnames(fulldata)) |
                       grepl("mean.." , colnames(fulldata)) |
                       grepl("std.." , colnames(fulldata))|
                       grepl("subjectId" , colnames(fulldata))     )

mean_stdv_data <- fulldata[ , mean_std == TRUE]

#activities 
activity_names <- merge(mean_stdv_data, activity_labels,
                              by="activityId")


#Tidy Data
Tidy_data <- aggregate(. ~subjectId + activityId, activity_names , mean)
write.table(Tidy_data, "TidyData.txt")
