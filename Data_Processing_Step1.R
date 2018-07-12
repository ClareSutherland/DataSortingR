#Data Processing Step 1
#Nichola Burton
#Last edited 7/6/18

#first, we just want to set the working directory, define the folder that holds our raw data and list the data file names

#begin by setting the working directory to your analysis folder - this is where you will save to in the end
setwd("/Users/rivendell/Dropbox/RTWs/R Data processing/")

#note that this won't be the same on your computer! You can either type the correct directory in by hand if you know it,
#or find it by using:

file.choose()

#to select a file in the directory that you want and then copy-paste from the console. Remember that if you do this, you only want to 
#copy the information to the level of the folder, and not the last file name part. And don't forget the quotation marks!

#here, I specify a sub-folder into which I've put all of the raw .csv data files from Testable
dataLocation <- "/Users/rivendell/Dropbox/RTWs/R Data processing/Data"

#again, you need to set this yourself. 


#here I make a list of all of the files in that dataLocation folder
datafileNames <- list.files(dataLocation)
