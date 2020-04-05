## Validamos Existencia de Carpeta

if (!file.exists("dataFinal")){
  dir.create("dataFinal")
}
dir()

## Obtenemos las BBDD de Test (x, y, subject)

destfile_x_test<-"./dataFinal/test/X_test.txt"
destfile_y_test<-"./dataFinal/test/y_test.txt"
destfile_subject_test<- "./dataFinal/test/subject_test.txt"

x_test<-read.table(destfile_x_test, header = FALSE)
y_test<-read.table(destfile_y_test, header = FALSE)
subjet_test<- read.table(destfile_subject_test, header = FALSE)

## Obtenemos las BBDD de Train (x, y, subject)

destfile_x_train<-"./dataFinal/train/X_train.txt"
destfile_y_train<-"./dataFinal/train/y_train.txt"
destfile_subject_train<- "./dataFinal/train/subject_train.txt"

x_train<-read.table(destfile_x_train, header = FALSE)
y_train<-read.table(destfile_y_train, header = FALSE)
subjet_train<- read.table(destfile_subject_train, header = FALSE)

## Obtenemos la lista de las características

destfile_features<- "./dataFinal/features.txt"
features<- read.table(destfile_features, header = FALSE)


## rbind

dSubject <- rbind(subjet_train, subjet_test)
dActivity<- rbind(y_train, y_test)
dFeatures<- rbind(x_train, x_test)

## Set el nombre de las variables

names(dFeatures)<- features$V2

names(dActivity)<- c("Activity")

names(dSubject)<-c("subject")

## Merge columns to get the data frame Data for all data

dJoin <- cbind(dSubject, dActivity)
bdd <- cbind(dFeatures, dJoin)
View(bdd)

## Extracts only the measurements on the mean and standard deviation for each measurement.

selectedCol <- grepl("mean\\(\\)", names(bdd)) |  grepl("std\\(\\)", names(bdd))

selectedMeanStd <- bdd[, selectedCol]

## Uses descriptive activity names to name the activities in the data set

destfile_activityLabels <- "./dataFinal/activity_labels.txt"
activityLabels <- read.table(destfile_activityLabels, header = FALSE)
aLabels<- select(activityLabels, V2)


table(dActivity)

bdd$Activity <- factor(bdd$Activity, labels=c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))
bdd$Activity


## Appropriately labels the data set with descriptive variable names.
names(bdd)<- gsub("acc", "accelerometer", names(bdd))
names(bdd)<- gsub("^t", "time", names(bdd))
names(bdd)<- gsub("^f", "frecuency", names(bdd))
names(bdd)<- gsub("Gyro", "giroscope", names(bdd))

## From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
## for each activity and each subject.

melted <- melt(bdd, id=c("subject","Activity"))
lastBDD <- dcast(melted, subject+Activity ~ variable, mean)

write.table(lastBDD, "./lastBDD.txt", row.names=FALSE)



