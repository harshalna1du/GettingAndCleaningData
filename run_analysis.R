##########################################################################################################

## Harshal Naidu's submission for the Course project getdata-032 - Getting and Cleaning Data
## Program Description 
### Pre-Requisites
###  - The original folder structure and dataset to be set up in the structire described in the codebook ".
###  - data.table, dplyr adn tidyr packages are installed.


### Dataset Description
###  - There are two broad data groups Training and Test that are presumably used for training and testng the ML algorithm
###  - For the purpose of this analysis these need to  be mergerd
###  - Subjects are people who were part of the experiment. 
###  - Each activity has a unique label stored in activity_labels.txt
###  - The parameters (or variables) that were measures are listed in Features.txt
###  - The Observations for each of the parameter is stored in XTrain and XTest File
###  - The corresponding activity for each measurement is stored in YTrain and YTest file
###  - The corresponding subject who performed the activity is stored in the SubjectTrain or SubjectTest file
###  - The number of values for the Subject, activities and observations match, i.e the relevant data is split into 3 type of files.
###  - Note: Unlike a unique list of Activities and MeasurementParameters, there's no unique list of subjects.
###  - Inertial Signals are not used in this analysis 


### Program Logic
###  1. Load the packages using Library command
###  2. Load the Activity Label from activity_Lables.txt
###  3. Load the MEasurement Parameters from Features.txt
###  4. Load Test and Training data using read.tables.

###  Assignment Question 1 - "Merge the training and the test sets to create one data set"
###  5. Merge the training and the test data using the rbind 

###  Assignment Question 2 - "Extract only the measurements on the mean and standard deviation for each measurement"
###  6. Use regular expression to extract teh index of columns with standard deviation and mean. Discard other columns

###  Assignment Question 3 -"Use descriptive activity names to name the activities in the data set"
###  7. Set descriptive activity names
###  8. Combine the Subject-Activity-Observation Datasets

###  Assignment Question 4 -"Appropriately labels the data set with descriptive variable names"
###  9. Clean up the MeasurementParameter naming.

###  Assignment Question 5 -"From the data set in step 4, creates a second, independent tidy data set with the average of
###                          each variable for each activity and each subject"
###  10.For the purpose of this assignment, the program demonstrates wide and narrow datasets
#### 10.1.1 Wide: Group by Activity first, then subject. Summarise each MeasurementParameter by mean. (As asked in the assignment)
#### 10.1.2 Wide: Group by Subject first, then Activity. Summarise each MeasurementParameter by mean. (Another way of looking at it)
#### 10.2. Gather all but SubjectID and Activity columns to make a narrow dataset such that each MeasurementParameter is 
####       transposed to a value from a column resultig in a Subject->Activity->MeasurementParameter->Value stucture.
####       Summarise by mean of the observation.
####       
####       Each summarised dataset is writen to disk using write.table command
##########################################################################################################


# Initialize Program

  setwd("C:/Coursera/GettingAndCleaningdata/Course Project/Analysis")
  library(data.table)
  library(dplyr)
  library(tidyr)

# Load Activity lables and set descriptive names to the columns
  
  Activity_Labels<-read.table("Dataset/activity_labels.txt")
  Activity_Labels<-rename(Activity_Labels, Activity_Id=V1,Activity_Desc=V2)
  
# Load MeasurementParameters from Features.txt and set descriptive column names
  MeasurementParameters<-read.table("Dataset/features.txt")
  MeasurementParameters<-rename(MeasurementParameters, Variable_id=V1,MeasurementParameter=V2)
  
# Load Training Data

  XTrain<-read.table("Dataset/train/X_train.txt")
  YTrain<-read.table("Dataset/train/y_train.txt")
  SubjectTrain<-read.table("Dataset/train/subject_train.txt")

# Load Test Data


  XTest<-read.table("Dataset/test/X_test.txt")
  YTest<-read.table("Dataset/test/y_test.txt")
  SubjectTest<-read.table("Dataset/test/subject_test.txt")

# Assignment Question 1 - "Merge the training and the test sets to create one data set"
# Merge training and Test Sets  
  

  Observation_For_Each_MeasurementParameter_All<-rbind(XTrain,XTest)
  Activity_Associated_With_Each_Observation_All<-rbind(YTrain,YTest)
  Subjects_All<-rbind(SubjectTrain,SubjectTest)

  rm(XTrain,YTrain,SubjectTrain,XTest,YTest,SubjectTest)
  
  
# Assignment Question 2 - "Extract only the measurements on the mean and standard deviation for each measurement"
# Keep only columns for mean and std 

  # Create in integer vector with index of the needed Parameters
  mean_std_vars_index<-grep("-mean\\(\\)|-std\\(\\)",MeasurementParameters[,2]) 
  
  # Remove the parameters not reqired.
  Observation_For_Each_MeasurementParameter_All <- Observation_For_Each_MeasurementParameter_All[,mean_std_vars_index]
  
  # Update the proper coluum names.
  names(Observation_For_Each_MeasurementParameter_All) <- tolower(MeasurementParameters[mean_std_vars_index, 2])

# Assignment Question 3 -"Use descriptive activity names to name the activities in the data set"
# Set Descriptive Activity Names
  
  Activity_Associated_With_Each_Observation_All<-rename(Activity_Associated_With_Each_Observation_All,Activity=V1)
  Activity_Associated_With_Each_Observation_All[,"Activity"] <- Activity_Labels[Activity_Associated_With_Each_Observation_All[,"Activity"],"Activity_Desc"]


  Subjects_All<-rename(Subjects_All, SubjectId=V1)
  Subject_Activity_Observations_Dataset <- cbind(Subjects_All, Activity_Associated_With_Each_Observation_All, Observation_For_Each_MeasurementParameter_All)

#  Assignment Question 4 -"Appropriately label the data set with descriptive variable names"  

  colNames  = colnames(Subject_Activity_Observations_Dataset); 
  

  for (i in 1:length(colNames)) 
  {
    colNames[i] = gsub("\\()","",colNames[i])
    colNames[i] = gsub("-std$","StdDev",colNames[i])
    colNames[i] = gsub("-mean","Mean",colNames[i])
    colNames[i] = gsub("^(t)","time",colNames[i])
    colNames[i] = gsub("^(f)","frequency",colNames[i])
    colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
    colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
    colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
    colNames[i] = gsub("AccMag","AccelerationMagnitude",colNames[i])
    colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccelerationJerkMagnitude",colNames[i])
    colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
    colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
  };

  # update columns names
  colnames(Subject_Activity_Observations_Dataset) = colNames;
  
  
  
  
  
#  Assignment Question 5 -"From the data set in step 4, creates a second, independent tidy data set with the average of 
#                          each variable for each activity and each subject"
  
# Wide Dataset
#  Grouping asn Summary by Activity first, then Subject
  
  Activity_Subject_Grouping_Dataset<-group_by(Subject_Activity_Observations_Dataset,Activity,SubjectId)
  Activity_Subject_Grouping_Summary<-summarise_each(Activity_Subject_Grouping_Dataset,funs(mean))
  write.table(Activity_Subject_Grouping_Summary, "Output/Wide_Activity_Subject_Grouping_Summary.txt", row.name=FALSE)
  
  
#  Grouping and Summary by Subject first, then activity
  
  Subject_Activity_Grouping_Dataset<-group_by(Subject_Activity_Observations_Dataset,Activity,SubjectId)
  Subject_Activity_Grouping_Summary<-summarise_each(Subject_Activity_Grouping_Dataset,funs(mean))
  write.table(Subject_Activity_Grouping_Summary, "Output/Wide_Subject_Activity_Grouping_Summary.txt",row.name=FALSE)  
  

# Tidy Narrow Dataset
  
 Tidy_Narrow<-gather(Subject_Activity_Observations_Dataset,MeasurementParameter,Observation,-SubjectId,-Activity)  
 Narrow_Grouping_Dataset<-group_by(Tidy_Narrow,SubjectId,Activity,MeasurementParameter)
 Tidy_Narrow_Summary<-summarise(Narrow_Grouping_Dataset,mean(Observation))
 write.table(Tidy_Narrow_Summary, "Output/Tidy_Narrow_Summary.txt",row.name=FALSE)

# End of Program

 
 
 
  
  