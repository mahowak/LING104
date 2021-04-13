# load a library
library(tidyverse)

# doing arithmetic
x = 1 + 1

# types in R
# numeric
x = 1 + 1
y = 18272141

# characters
a = "book"
b = "dog"

# bool (evaluates to numbers)
a = TRUE
b = FALSE


# what is a vector
num_vec = c(10, 11, 2)
num_vec[1]
num_vec[3]
char_vec = c("dog", "toy", "book")

# performing operations on vectors
num_vec
mean(num_vec)
sum(num_vec)
max(num_vec)
min(num_vec)
summary(num_vec)

mean(char_vec)

max_num_vec = max(num_vec)
max_num_vec

# reading in a file
# what is a data frame
d = read_csv("LING104/data/fogo_toys.csv")
d = filter(d, is.na(Toy) == F)
# row, column
d[1, 1]
d[5, 3]
d$Toy
d$Brought
d[, "Brought"]

# create a new column for if the data point is Correct or Incorrect
# it is a bool (TRUE or FALSE)
d$Correct = (d$Brought == d$Toy)
3 == 3
4 == 1 + 1
"octopus" == "octopus"
"octopus" == "diamond ring"
d$Brought == d$Toy

#########
# how often is Fogo correct?
mean(d$Correct)

# create a data frame saying what is rand
d$Random.Brought = sample(d$Brought)
d$Random.Correct = d$Toy == d$Random.Brought
mean(d$Random.Correct)

# Is Fogo doing better than chance?
d = filter(d, is.na(Correct) == F)
mean(d$Correct)
d$Random.Choice = sample(d$Brought)
d$Random.Correct = d$Brought == d$Random.Choice
mean(d$Random.Correct)

#
unique(d$Toy)

# a few ways to filter in R
d[d$Toy == "french fries" , ]
filter(d, Toy == "french fries")
length(d$Toy == "french fries")
nrow(d)



# How does diamond ring compare to all others?
group_by(d, Toy) %>%
  summarise(mean.correct = mean(Correct))

# 1) Is "diamond ring" performance overall better than chance, 
# in the same way overall performance is?

# 2) Is that true on the first few days?

# 3) Is that true on the last few days?



# What is time course of learning?
d.sum = group_by(d, Date, DR = Toy == "diamond ring") %>%
  summarise(mean.correct = mean(Correct))
ggplot(d.sum, aes(x=Date, y=mean.correct, colour=DR, group=DR)) +
  geom_line() +
  geom_point() + 
  theme_bw(12)
