#Data Processing Step 4b
#Nichola Burton
#Last edited 7/6/18

#this is the cleaned-up version of our script with some added checks!

#(remember to update the directories below to the ones on your computer)

#begin by setting the working directory to your analysis folder - this is where you will save to in the end
setwd("/Users/00056678/Dropbox/Postdoc/resources/R/Data_Processing_Workshop/DataProcessingRMaterials")

#specify a sub-folder in which I've put all of the raw .csv data files from Testable
dataLocation <- "/Users/00056678/Dropbox/Postdoc/resources/R/Data_Processing_Workshop/DataProcessingRMaterials/Data"

#make a list of all of the files in that dataLocation folder
datafileNames <- list.files(dataLocation)

#make a data frame to hold the values as we run through the files
compiledParticipantInfo <- data.frame(matrix(0, nrow = length(datafileNames), ncol = 35))

#for checking purposes, make a data frame to hold the target names as we run through the files
compiledTargetNames <- data.frame(matrix(0, nrow = length(datafileNames), ncol = 21))

#run through the files in a loop
for(fileNo in 1:length(datafileNames)){
  #Find the name of the datafile. 
  filename <- datafileNames[fileNo]
  
  #read in our data file
  fullData <- read.csv(paste(dataLocation, filename, sep ="/"), header = FALSE, stringsAsFactors = FALSE)
  
  #drop any unwanted blank rows (because of the annoying thing Testable does)
  fullData <- fullData[fullData[,1] != "",]
  
  #check the dimensions of the data file and only process if they are as expected...
  if(nrow(fullData)==33 & ncol(fullData)==52){
  
    #Testable saves some info about the session in the first 8 cells of row 2. 
    #start putting together the info from this file by making an object (participantInfo) that holds that information
    participantInfo <- as.data.frame(fullData[2,1:8])
    #name the columns from the labels supplied by Testable in row 1:
    names(participantInfo)[1:8] <- fullData[1,1:8]
    
    #name the variables in fullData with the names in row 3:
    names(fullData) <- fullData[3,]
    
    #drop out those top three rows
    fullData <- fullData[-1:-3,]
    
    #extract the responses to the demographic questions:
    participantInfo[9:14] <- fullData[1:6, "response"]
    #and name those columns with the question text
    names(participantInfo)[9:14] <- fullData[1:6, "head"]
    
    #we also want to save the filename in here becaue it contains the date/time info:
    participantInfo$Filename <- filename
    
    #find the ratings responses and re-order them (randomized for each participant):
    
    #make a new data frame containing just the ratings trials
    temp <- fullData[fullData$condition1 == "rating", ]
    #drop the first two (practice) trials:
    temp <- temp[-1:-2,]
    
    #convert the trial numbers to numeric format
    temp$trialNo <- as.numeric(temp$trialNo)
    #and sort by trial number
    temp <- temp[order(temp$trialNo),] 
    
    #add rating responses to participantInfo
    participantInfo[16:35] <- temp[, "response"]
    #name based on the stimulus names listed in the "target" column
    names(participantInfo)[16:35] <- temp[,"target"]
    
    #before we run the loop again, we want to copy out this version of participantInfo into the compiledParticipantInfo dataframe.
    #this line fills the row of compiledParticipantInfo defined by "fileNo" with the contents of participantInfo
    compiledParticipantInfo[fileNo,] <- participantInfo
    
    #for checking purposes, we also want to save the target names into our compiledTargetNames dataframe
    compiledTargetNames[fileNo, 1] <- filename
    compiledTargetNames[fileNo, 2:21] <- temp[,"target"]
    
  #if the dimensions of the file are other than expected, just print the filename in the console  
  }else{
    message(filename)
  }
}

#name the columns of compiledParticipantInfo
names(compiledParticipantInfo) <- names(participantInfo)

#write this dataframe out as a .csv:
write.csv(compiledParticipantInfo, "compiledParticipantInfo.csv")
