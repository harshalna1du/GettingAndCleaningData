# Harshal Naidu's submission for the Course project getdata-032 - Getting and Cleaning Data
#### Program Description 
##### Pre-Requisites
The original folder structure and dataset to be set up in the structire described in the codebook ".
data.table, dplyr adn tidyr packages are installed.


##### Dataset Description
- There are two broad data groups Training and Test that are presumably used for training and testng the ML algorithm
- For the purpose of this analysis these need to  be mergerd
- Subjects are people who were part of the experiment. 
- Each activity has a unique label stored in activity_labels.txt
- The parameters (or variables) that were measures are listed in Features.txt
- The Observations for each of the parameter is stored in XTrain and XTest File
- The corresponding activity for each measurement is stored in YTrain and YTest file
- The corresponding subject who performed the activity is stored in the SubjectTrain or SubjectTest file
- The number of values for the Subject, activities and observations match, i.e the relevant data is split into 3 type of files.
- Note: Unlike a unique list of Activities and MeasurementParameters, there's no unique list of subjects.
- Inertial Signals are not used in this analysis 


##### Program Logic
1. Load the packages using Library command
2. Load the Activity Label from activity_Lables.txt
3. Load the MEasurement Parameters from Features.txt
4. Load Test and Training data using read.tables.
5. Assignment Question 1 - "Merge the training and the test sets to create one data set". Merge the training and the test data using the rbind 
6. Assignment Question 2 - "Extract only the measurements on the mean and standard deviation for each measurement": Use regular expression to extract teh index of columns with standard deviation and mean. Discard other columns
7. Assignment Question 3 -"Use descriptive activity names to name the activities in the data set": Set descriptive activity names
8. Combine the Subject-Activity-Observation Datasets
9. Assignment Question 4 -"Appropriately labels the data set with descriptive variable names"
10. Clean up the MeasurementParameter naming.
11. Assignment Question 5 -"From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject"
 - For the purpose of this assignment, the program demonstrates wide and narrow datasets
 - Wide: Group by Activity first, then subject. Summarise each MeasurementParameter by mean. (As asked in the assignment)
 - Wide: Group by Subject first, then Activity. Summarise each MeasurementParameter by mean. (Another way of looking at it)
 - Narrow: Gather all but SubjectID and Activity columns to make a narrow dataset such that each MeasurementParameter is transposed to a value from a column resultig in a Subject->Activity->MeasurementParameter->Value stucture.Summarise by mean of the observation.
 - Each summarised dataset is writen to disk using write.table command
 - Files stores in Output directory
