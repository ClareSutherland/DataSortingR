#Data Processing Step 3
#Nichola Burton
#Last edited 7/6/18

#now we want to run this process for all of our files!

#(remember to update the directories below to the ones on your computer)

#begin by setting the working directory to your analysis folder - this is where you will save to in the end
setwd("/Users/nicholaburton/Dropbox/Postdoc/resources/R/Data_Processing_Workshop/DataProcessingRMaterials")

#specify a sub-folder in which I've put all of the raw .csv data files from Testable
dataLocation <- "/Users/nicholaburton/Dropbox/Postdoc/resources/R/Data_Processing_Workshop/DataProcessingRMaterials/Data"

#make a list of all of the files in that dataLocation folder
datafileNames <- list.files(dataLocation)

#we need to run through our data files in turn, running the process below on each one and saving the resulting row of values somewhere.

#to do this, we use a "for" loop.
#R will run whatever is contained within the loop as many times as you tell it to.
#you specify the number of times it runs by stating some iterative condition
#for instance: "For x in 1:5 [do this thing]": does the thing five times, with x taking the value 1, then 2, then 3, then 4, then 5.

#you don't actually need to use x for anything if you don't need to - it can just count off the rounds of your loop.
#for instance:

for(x in 1:5){
  
  message("hello")
  
}

#but often you will want to use x to help you iterate through a list of things, since the value of x increases each time:

for(x in 1:5){
  
  message(paste("hello", x, sep = " "))
  
}

#also, note that you don't have to call it "x" - it can be called anything you like (so long as you don't need that name for some other object...)
#for our purposes, let's call that iterative value "fileNo". Then we can use it to call each file in turn as we run through the loop!

#we want to run the loop as many times as we have files to process, so our condition will be:
# for (fileNo in 1:length(datafileNames))

#one last thing before we set up the loop: each time we run it, our "Participant Info" values will be replaced with new ones. In order to keep all
#of the values, we need to copy them somewhere before the loop starts again. 

#Here I am making a new data frame, currently containing only zeros, with as many rows as we have files to process and with as many columns
#as the number of values we extract from the files
compiledParticipantInfo <- data.frame(matrix(0, nrow = length(datafileNames), ncol = 35))

#now we can run the loop:

for(fileNo in 1:length(datafileNames)){
  
  #Find the name of the datafile. 
  filename <- datafileNames[fileNo]
  
  #read in our data file
  fullData <- read.csv(paste(dataLocation, filename, sep ="/"), header = FALSE, stringsAsFactors = FALSE)
  
  #drop any unwanted blank rows (because of the annoying thing Testable does)
  fullData <- fullData[fullData[,1] != "",]
  
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

}

#we need to give the columns of compiledParticipantInfo some names - I'm just going to pinch them from the most recent participantInfo dataframe:
names(compiledParticipantInfo) <- names(participantInfo)

#and finally we want to write this dataframe out as a .csv:

write.csv(compiledParticipantInfo, "compiledParticipantInfo.csv")
