ensureDataDownloaded <- function(dataDir, url) {
    if (!file.exists(dataDir)) {
        localPath <- "HARDataset.zip"
        download.file(url, destfile = localPath, method = "curl")
        unzip(localPath)
        file.remove(localPath)
    }
}

mergeDataSets <- function() {
    features <- read.table("features.txt")
    allFeaturesNames <- as.character(features$V2)
    featuresToKeepNames <- allFeaturesNames[grepl("mean[(][)]|std[(][)]", allFeaturesNames)]
    descriptiveFeaturesNames <- gsub("()", "", 
                                     gsub("Freq", "Frequency",
                                     gsub("-X", "ByX",
                                     gsub("-Y", "ByY",
                                     gsub("-Z", "ByZ",
                                     gsub("-std()", "StdDev",
                                     gsub("-mean()", "Mean",
                                     gsub("Jerk", "JerkSignal",
                                     gsub("Gyro", "Gyroscope",
                                     gsub("Mag", "Magnitude",
                                     gsub("Acc", "Acceleration",
                                     gsub("^f", "FourierTransform",
                                     gsub("^t","Time", featuresToKeepNames)))))))))))), fixed=TRUE)
    
    activityLabels <- read.table("activity_labels.txt")
    names(activityLabels) <- c("activityId", "activity")

    mergeDataSetsOfType <- function(type) {
        dir <- paste(type, "/", sep = "")
        fNameSuffix <- paste("_", type, ".txt", sep = "")
        
        x <- read.table(paste(dir, "X", fNameSuffix, sep=""))
        names(x) <- allFeaturesNames
        x <- x[, featuresToKeepNames]
        names(x) <- descriptiveFeaturesNames
        y <- read.table(paste(dir, "y", fNameSuffix, sep=""))
        names(y)[1] <- "activityId"
        subj <- read.table(paste(dir, "subject", fNameSuffix, sep=""))
        names(subj)[1] <- "subject"
        
        res <- cbind(subj, y)
        res <- merge(res, activityLabels, by="activityId")
        cbind(res, x)
    }

    rbind(mergeDataSetsOfType("train"), mergeDataSetsOfType("test"))
}

getTidyData <- function(dataset) {
    ds <- dataset[, names(dataset) != 'activity']
    activity <- unique(dataset[, c(1, 3)])
    tidyData <- aggregate(ds[, 3:ncol(ds)], 
                          by = list(activityId = ds$activityId, subject = ds$subject), mean)
    merge(tidyData, activity, by = 'activityId');
}


currDir <- getwd()
dataDir <- "UCI HAR Dataset"

ensureDataDownloaded(dataDir, 
    "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")

setwd(dataDir)

tidyData <- getTidyData(mergeDataSets())

setwd(currDir)

write.table(tidyData, "tidyData.txt", row.names = F, sep = '\t');
