# Statistics for Linguists: An Introduction Using R
# Code presented inside Chapter 1


# --------------------------------------------------------
# 1.2. Baby steps: simple math with R

# Addition:

2 + 2

# Subtraction:

3 - 2

# Incomplete command; abort with ESC:

3 -

# Division:

3 / 2

# Multiplication:

3 * 2

# Two, squared (2 * 2):

2 ^ 2

# Two, to the power of three (2 * 2 * 2):

2 ^ 3

# Two pluts three (=5), multiplied by 3:

(2 + 3) * 3

# Three times three (=9) plus 2:

2 + (3 * 3)

# Square root of four:

sqrt(4)

# Not supplying an argument gives error:

sqrt()

# Absolute value makes negative numbers positive:

abs(-2)
abs(2)



# --------------------------------------------------------
# 1.4. Assigning variables:

# Assign the output of 2 * 3 to the object named 'x':

x <- 2 * 3

# Print object name to check content of object 'x':

x

# Another way of assigning, less preferred:

x = 2 * 3
x

# Use 'x' as if it's a number:

x / 2

# R is case-sensitive, so capital 'X' yields an error...
# ... because the object doesn't exist:

X

# Check all R objects of current working environments:

ls()



# --------------------------------------------------------
# 1.5. Numeric vectors

# Assign three numbers to 'x', concatenated with c():

x <- c(2.3, 1, 5)
x

# Check how many numbers are in this vector:

length(x)

# Checking the type of vector:

mode(x)
class(x)

# Colon creates an integer sequence from...
# ... the first argument (10) to the second (1):

mynums <- 10:1
mynums

# Sum:

sum(mynums)

# Smalles value (minimum):

min(mynums)

# Smalles value (maximum):

max(mynums)

# Minimum and maximum together:

range(mynums)

# Range: difference between minimum and maximum:

diff(range(mynums))

# Arithmetic mean, see Ch. 3:

mean(mynums)

# Standard deviation, see Ch. 3:

sd(mynums)

# Median, see Ch. 3:

median(mynums)

# Subtract 5 from every number:

mynums - 5

# Divide every number by two:

mynums / 2	# divide every number by two



# --------------------------------------------------------
# 1.6. Indexing:

# Retrieve value at first position:

mynums[1]

# Retrieve value at second position:

mynums[2]

# Retrieve first four values:

mynums[1:4]

# Retrieve everything except second position:

mynums[-2]

# 100 numbers, notice the square brackets [] to the left...
# ... of the console; these list the next position:

1:100



# --------------------------------------------------------
# 1.7. Logical vectors:

# Logical statement: Is the value is larger than 3?

mynums > 3

# Is it larger than or equal to 3?

mynums >= 3

# Smaller than 4?

mynums < 4

# Smaller than or equal to 4?

mynums <= 4

# Equalt o 4?

mynums == 4

# Not equal to 4?

mynums != 4

# Save 'Larger than or equal to 3?' output to...
# ... vector called 'mylog':

mylog <- mynums >= 3

# Check what type of vector this is:

class(mylog)

# Use this vector for indexing:

mynums[mylog]

# Same in one step, using logical statement ...
# ... to index specific values:

mynums[mynums >= 3]



# --------------------------------------------------------
# 1.8. Logical vectors:

# Create a character vector with 5 gender identifiers:

gender <- c('F', 'M', 'M', 'F', 'F')

# Check content of vector:

gender   # notice the quotation marks

# Check vector class:

class(gender)

# As before, you can use positions for indexing ...

gender[2]

# ... or logical statement:

gender[gender == 'F']

# Being a character vector, certain mathematical ...
# ... operations 

mean(gender)



# --------------------------------------------------------
# 1.9. Factor vectors:

# Convert the character vector 'gender' to a factor:

gender <- as.factor(gender)

# Check:

gender   # notice the absence of quotation marks

# Retrieve levels (unique types):

levels(gender)

# Once the levels are fixed, you can't just add new ones:

gender[3] <- 'not_declared'
gender   # notice the NA (missing value)

# Assigning new levels:

levels(gender) <- c('M', 'F', 'not_declared')

# Now it's possible to add the new text:

gender[3] <- 'not_declared'
gender



# --------------------------------------------------------
# 1.10. Data frames:

# Create a new vector of names:

participant <- c('louis', 'paula', 'vincenzo')

# Put this into a dataframe ...
# ... the second column is named 'score' and we assign ...
# ... three numerical values:

mydf <- data.frame(participant, score = c(67, 85, 32))

# Check data frame:

mydf

# Interrogate number of rows:

nrow(mydf)

# Interrogate number of columns:

ncol(mydf)

# Interrogate column names:

colnames(mydf)

# Columns can be indexed with column name and '$':

mydf$score

# Compute the mean of the score column:

mean(mydf$score)

# Retrieve structure of the data frame:

str(mydf)

# Summarize the data frame:

summary(mydf)

# Index first row, no column restrictions:

mydf[1, ]

# Note: everything before the comma relates to rows...
# ... everything after comma to columns.

# Index second column:

mydf[, 2]

# First two rows:

mydf[1:2, ]

# Stacking indexing statements: First column, second entry:

mydf[, 1][2]

# Extract row with participant 'vincenzo':

mydf[mydf$participant == 'vincenzo', ]

# Extract this participant's score:

mydf[mydf$participant == 'vincenzo', ]$score



# --------------------------------------------------------
# 1.11. Loading in files:

# Check current working directory:

getwd()	# output specific to your computer

# List files in the current working directory:

list.files() # output specific to your computer

# Change working directory to where the file...
# 'nettle_1999_climate.csv' is located at...
# ... in RStudio: Click on 'Session' tab, ...
# ... then 'Set working directory', navigate to folder.

# Load in the Nettle (1999) linguistic diversity data:

nettle <- read.csv('nettle_1999_climate.csv')

# Whenever loading a new file, check its content.
# First six rows:

head(nettle)

# Last six rows:

tail(nettle)

# Accidentally overriding the 'Langs' columns with NAs...
# ... is not a problem, because you can just ...
# ... load the file back into R.

nettle$Langs <- NA

# Reading a tab-delimited file:

mydf <- read.table('example_file.txt',
                   sep = '\t', header = TRUE)
                   
# Check:

mydf

# To find out the structure of a file, load it into R...
# ... as text (here, only first two lines: n = 2):

x <- readLines('example_file.txt', n = 2)
x

# The output reveals '\t' tab delimiters.



# --------------------------------------------------------
# 1.12. Plotting:

# Create a histogram:

hist(nettle$Langs)

# Create a salmon-colored histogram:

hist(nettle$Langs, col = 'salmon')

# Notice that 'col' is an optional argument ...
# ... (the function works fine without).

# Retrieve names of all colors pre-defined in R:

colors()



# --------------------------------------------------------
# 1.13. Installing, loading and citing packages:

# Install a package, select server:

install.packages('car')

# Load installed package into current R session:

library(car)

# Check citation:

citation('car')$textVersion

# Check package version:

packageVersion('car')

citation()$textVersion
R.Version()$version.string



# --------------------------------------------------------
# 1.14. Seeking help:

# Access help file of ?seq function:

?seq




