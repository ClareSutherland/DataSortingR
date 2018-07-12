#some basic R commands
#last edited 6/5/18
#Nichola Burton

#R can work out of (more or less) any location on your computer. This means that it will look for files to open in
#that location, and save them there as well. This is called the "working directory". You can find the current working
#directory like this:

getwd()

#anything formatted like this is a function: getwd is the name of the function, and the brackets after it are a place
#where you put any input values that the function needs to run. getwd doesn't need any input values, so we leave that blank.

#we can also set the working directory:

setwd("/Users/00056678/Dropbox/Postdoc/resources/R/Data_Processing_Workshop/DataProcessingRMaterials")

#the directory I specified here exists on my computer, but probably not on yours... so you will need type in your own directory.
#if you know the file structure of your computer really well, then you could try typing it from memory - but any typos will stop R from finding 
#the location that you want.

#you can also find the address of your chosen directory (known as a "path") by using the file.choose function:

file.choose()

#this will open a system dialogue that will let you navigate to your folder. choose any file in that folder, and the full path of that file will
#appear in the console below, like this:

#[1] "/Users/00056678/Dropbox/Postdoc/resources/R/DataFolder/Data/578104_undefined_20180414_213816.csv"

#note that this path directs to a specific file - but you want the folder that that file is in. So drop the file name (the part after the last "/")
#and just copy in the stuff before it - in this case, the path for that folder is:

#"/Users/00056678/Dropbox/Postdoc/resources/R/DataFolder/Data/"

#One of the things you can do in R is create objects and assign them values.

#we can make object x equal to 1 like this:
#you'll see it pop up in the "Environment" panel 

x <- 1


#you can also (in some circumstances) use = like in other languages:
x = 2

#but this doesn't always work predictably, so go with <-

#because "=" can be used to assign values, we use "==" to ask the question "is this equal to that"?
#you'll see the answer appear in the console

x==3
x==2

#and we can also use some other basic operators:

x <- 1+4

x == 2+3
x > 4
x > 5
x >= 5

#as well as assigning a number to an object, you can also assign a string (a set of characters)

y <- "hello"

#there are other types of objects as well (lists, matrices, etc) - they each hold a different type of data, in different formats
#different functions take in different object types, so that's something to check if your code unexpectedly doesn't work.

#this should produce an error (for obvious reasons):

z = y+2

# You can put together a vector of separate values using the "concatenate" function:

z <- c(2,4,6,8)

#and now we can refer to specific values in that vector using square brackets:

z[3]

#a matrix is like a vector but with more dimensions:

m <- matrix(0, nrow = 3, ncol = 3)

#take a look at this matrix by clicking on it in the environment panel, or by entering the following:

View(m)

#we can refer to values in this matrix using square brackets like this: [row, column]

m[2,3]

m[2,3] <- 5

#we can also refer to more than one value in this matrix at once. For instance, let's get all of row 1:

m[1,]

#and here's all of column 3:

m[,3]

#how about rows 2 to 3 of column 3:

m[2:3, 3]

#what if we want rows 1 and 3, but not 2?
#we can use the c() function from earlier:

m[c(1,3),]

#a useful format we will use a lot is a dataframe, which can hold lots of different sorts of variables at once.
#we can make m into a dataframe like this:

d <- as.data.frame(m)

#variables in a data frame can have names. Let's name our variables to make this data into information about number of
#pets owned by three people:

names(d)[1] <- "cats"
names(d)[2:3] <- c("dogs", "fish")

#lets add some values for rows 1 and 3

d[1,] <- c(1,0,1)
d[3,] <- c(2,3,1)

#as well as the d[,] format above, we can also refer to a dataframe variable like this:

d$cats

#and we can use this format to add a new variable and name it at the same time:

d$rabbits <- c(0, 2, 0)
d$gender <- c("male", "female", "male")

#we can also use the names to refer to specific cells within the dataframe, like this:

#number of rabbits owned by each personn:
d[,"rabbits"]

#number of rabbits owned by person number 2:
d[2, "rabbits"]

#what if we just want the male pet owners? that's a little bit tricker, but we can do it. What we want to ask for is this:
#"give me all of the rows of "d", where the variable "gender" (contained within "d") is equal to "male".

d[d$gender == "male",]

#we can't just ask for this:

d[gender == "male",]

#because programming languages are very, very literal - it's obvious to a person that when you say "gender", that must mean
#the variable contained within d - but R needs you to tell it what data frame that variable is contained within before it can 
#find it.

#finally, let's make a new dataframe that just contains the number of cats and dogs owned by males:

c <- d[d$gender == "male", c("cats", "dogs")]


