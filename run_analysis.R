#Getting and Cleaning Data
#Merges the training and the test sets to create one data set
features<-read.table("C://Users//Luke.Munyan//Desktop//Cleaning Data Project//features.txt")
features<-as.character(features[,2])

x.test<-read.table("C://Users//Luke.Munyan//Desktop//Cleaning Data Project//test//X_test.txt")
x.train<-read.table("C://Users//Luke.Munyan//Desktop//Cleaning Data Project//train//X_train.txt")
x.total<-rbind(x.train,x.test)
names(x.total)<-features

y.test<-read.table("C://Users//Luke.Munyan//Desktop//Cleaning Data Project//test//y_test.txt")
y.train<-read.table("C://Users//Luke.Munyan//Desktop//Cleaning Data Project//train//y_train.txt")
y.activity.total<-rbind(y.train, y.test)
names(y.activity.total)<-c("Activity")

subject.test<-read.table("C://Users//Luke.Munyan//Desktop//Cleaning Data Project//test//subject_test.txt")
subject.train<-read.table("C://Users//Luke.Munyan//Desktop//Cleaning Data Project//train//subject_train.txt")
subject.total<-rbind(subject.train, subject.test)
names(subject.total)<-c("Subject")

dat<-cbind(subject.total, y.activity.total)
combine<-cbind(dat,x.total)

#Extracts only the measurements on the mean and standard deviation for each measurement
features.subset<-features[grep("mean\\(\\)|std\\(\\)", features)]
select<-c("Subject", "Activity", features.subset)
combine.subset<-combine[,c(select)]

#Part3: Add descriptive activity names
activity.labels<-read.table("C://Users//Luke.Munyan//Desktop//Cleaning Data Project//activity_labels.txt")
activity.labels<-as.character(activity.labels[,2])
combine.subset$Activity<-activity.labels[combine.subset$Activity]

#Appropriately labels the data set with descriptive variable names
names(combine.subset)<-gsub("^t", "Time", names(combine.subset))
names(combine.subset)<-gsub("^f", "Frequency", names(combine.subset))
names(combine.subset)<-gsub("Acc", "Accelerometer", names(combine.subset))
names(combine.subset)<-gsub("Gyro", "Gyroscope", names(combine.subset))
names(combine.subset)<-gsub("Mag", "Magnitude", names(combine.subset))
names(combine.subset)<-gsub("BodyBody", "Body", names(combine.subset))
names(combine.subset)<-gsub("arCoeff", "Autoregression_Coeff", names(combine.subset))
str(combine.subset)
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy.data<-aggregate(.~Subject+Activity, combine.subset, mean)
tidy.data2<-tidy.data[order(tidy.data$Subject, tidy.data$Activity),]

write.table(tidy.data2, file="cleaningdata.txt", row.name=FALSE)
