Getting and Cleaning Data Course Project
==========================================

The description of raw data set could be found at [UCI Machine Learning
Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). Shortly, it''s data
about six activities performed by group of 30 volunteers. It has been partitioned into two sets: training data and test
data.

For each record in the dataset it is provided: 
* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

The resulting data set is combination of data from following files:
* train/X_train.txt
* train/y_train.txt
* train/subject_train.txt
* test/X_test.txt
* test/y_test.txt
* test/subject_test.txt

Label for activities are taken from activity_labels.txt and column names are from features.txt. Transformations were
applied to make column names more readable. So, tBodyAcc-mean()-X has become tBodyAccelerationMeanByX, tBodyGyro-std()-Z
 - tBodyGyroscopeStdDevByZ and so on.

As per assignment, only columns which contain the measurements on the mean and standard deviation for each measurement
were preserverd.

aggregate function has been used to get average of each variable for each activity and each subject.
