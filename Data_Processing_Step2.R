#Data Processing Step 2
#Nichola Burton
#Last edited 7/6/18


#now we've listed our files, we want to work out what processing we need to do to get out our important values. 
#in this step, we'll process just one file.


#(remember to update the directories below to the ones on your computer)

#begin by setting the working directory to your analysis folder - this is where you will save to in the end
setwd("/Users/nicholaburton/Dropbox/Postdoc/resources/R/Data_Processing_Workshop/DataProcessingRMaterials")

#specify a sub-folder in which I've put all of the raw .csv data files from Testable
dataLocation <- "/Users/nicholaburton/Dropbox/Postdoc/resources/R/Data_Processing_Workshop/DataProcessingRMaterials/Data"

#make a list of all of the files in that dataLocation folder
datafileNames <- list.files(dataLocation)

#So now we start processing our data. For now we'll just process the first file in the list.

#Let's find the name of the first file. 
#This line makes an object called "filename", and gives it a value by going to datafileNames and finding the item specified by fileNo (in this case, 1)
filename <- datafileNames[1]

#we want to read in the data from this file. But because our file isn't right there in the working directory, just having the name isn't enough.
#we need to give R the full path. to do this, we need to paste together dataLocation, which specifies the folder, and filename, which specifies the file.
#we can do that with paste():
paste(dataLocation, filename, sep = "/")
#paste sticks the parts together, and separates them with whatever you specify in 'sep". 

#now we can point R to our data file. Let's read it:
fullData <- read.csv(paste(dataLocation, filename, sep ="/"), header = FALSE, stringsAsFactors = FALSE)
#header=FALSE says not to treat the first row as a header row (otherwise this row will become column names)
#stringsAsFactors specifies whether or not to treat strings of characters as specifying factors - we want to leave them as strings

#I've noticed that sometimes in Testable a blank row appears in row 3 and sometimes it doesn't - to standardise, we want to pull out any empty rows.
#to do this, I'm dropping any row where the first cell is empty.
#what this actually says is: to make the new fullData object, take the old fullData object but only include those rows where column 1 is not equal to (empty).
fullData <- fullData[fullData[,1] != "",]
#notice where the commas are in within the square brackets: we refer to the contents of a dataframe as [rows, columns]
#so fulldata[,1] means: all of the rows in fulldata (I haven't specified a subset), but only column 1
#and fullData[fullData[,1] != "",] means: give me all the rows specified by (fullData[,1] != ""), and all of the columns.

#Testable saves some info about the session in the first 8 cells of row 2. 
#we will start putting together the info from this file by making an object (participantInfo) that holds that information
participantInfo <- as.data.frame(fullData[2,1:8])
#and we'll name the columns from the labels supplied by Testable in row 1:
names(participantInfo)[1:8] <- fullData[1,1:8]

#here I'm going to name the variables in fullData with the names in row 3:
names(fullData) <- fullData[3,]

#now let's drop out those top three rows (this is a weird R convention where specifying "-1:-3" means "all rows except 1:3"...):
fullData <- fullData[-1:-3,]

#the first few questions of my task were demographics. These end up in rows 1-6 in the "response" column so I'll grab them here:
participantInfo[9:14] <- fullData[1:6, "response"]
#and in my case the question text for those demographics is in the "head" column, so I'll grab that as the names for these values:
names(participantInfo)[9:14] <- fullData[1:6, "head"]

#we also want to save the filename in here becaue it contains the date/time info:
#this format says that there should be a variable in the dataframe with the name "Filename", and then fills it with the value that we assigned to filename
participantInfo$Filename <- filename

#and now let's say that the rest of the data I want to extract are ratings. here we have a nice simple situation: we showed each participant the same
#20 images, and got them to make a rating for each one. The images were shown in random order for each participant, so we can't just pull the responses from
#the same locations for each file like we do above with the demographics. So instead let's do some sorting:
#first, let's say that each of my rating rows is marked with the label "rating" in the condition1 column. We can make a new dataframe with just the rating data like this:
temp <- fullData[fullData$condition1 == "rating", ]
#the first two rows are the practice trials, so we'll drop those:
temp <- temp[-1:-2,]

#and now we want to sort it into the same order for each participant. 
#to do this, I'm going to use the order() function. 
#order() produces a vector of numbers that you can use to sort the input, from smallest to largest or alphabetically.
#easier to understand with a demo:

x <- c("B", "C", "A", "D")
order(x)

y <- x[order(x)]

#for our data we want to sort by the trial number found in the "trialNo" column:
temp <- temp[order(temp$trialNo),] 
#but there's a problem! Our trial numbers are currently stored as strings, so they won't sort correctly. first we need to make them into number format:
temp$trialNo <- as.numeric(temp$trialNo)
#and now they will sort properly.
temp <- temp[order(temp$trialNo),] 

#now let's put all of the responses from these ratings trials into our participant info dataframe:
participantInfo[16:35] <- temp[, "response"]
#and let's name those variables based on the stimulus names listed in the "target" column
names(participantInfo)[16:35] <- temp[,"target"]

#and now we have all the data we want from this participant in a single row!