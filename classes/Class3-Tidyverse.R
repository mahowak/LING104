library(tidyverse)

# 1. Time results were received.
# 2. MD5 hash of participant's IP address.
# 3. Controller name.
# 4. Item number.
# 5. Element number.
# 6. Type.
# 7. Group.
# 8. Word number.
# 9. Word.
# 10. Reading time (Reaction Time in milliseconds)
# 11. KeyCode.
# 12. Newline?
# 13. Sentence (or sentence MD5).
d = read_csv("LING104/experiments/lexdec.csv", comment = "#",
             col_names = c("time", "subj", "exp",
                           "item", "element", "type",
                           "garbage", "wordnum", 
                           "word", "RT", "guess", 
                           "Sent")) %>%
  filter(type != "words")

# says if it's correct
# it's correct if: person pressed S and it YES is a word
# it's correct if: person pressed K and it NO is not a word
# it's incorrect: all other times
d$correct = (d$guess == "S" & d$type == "wordsYES") | 
  (d$guess == "K" & d$type == "wordsNO")
mean(d$correct)

unique(d$word)

select(d, word, type)

head(d)
summary(d)

####
hist(d$RT, breaks=50)
max(d$RT)
head(d)
nrow(d)

summary(d$correct)

hist(filter(d)$RT, breaks=50)
hist(filter(d, correct == TRUE)$RT, breaks=50)
hist(filter(d, correct == FALSE)$RT, breaks=50)

##### Tidyverse

### Filter and select
### dplyr: tidyverse way of manipulating data
RT # does not work
filter(d, RT < 200) # works
filter(d, RT > 200, RT < 700, word == "SEE")

select(d, RT, word, guess)
d = select(d, -garbage)
select(d, item:word)

#### The problem with chaining functions
#### is that this is a hot mess, very confusing
#### too many parentheses
filter(select(select(filter(filter(d, RT > 200), word == "SEE"), -item), RT, word), RT  <1000)

#### Using %>%
filter(d, RT > 200, RT < 1000) %>%
  select(word, RT)

select(filter(d, RT > 200, RT < 1000), word, RT)

#### Using group_by()
#### Using summarise()
mean(d$RT)

group_by(d, correct) %>%
  summarise(mean.RT = mean(RT))

group_by(d, subj) %>%
  filter(RT < 3000) %>%
  summarise(mean.RT = mean(RT))

d %>%
  filter(RT < 3000) %>%
  summarise(mean.RT = mean(RT))

mean(d[d$RT < 3000, ]$RT)

# filter, select, group_by, summarise, arrange

d.max.min.med = filter(d) %>%
  group_by(word) %>%
  summarise(max.RT = max(RT),
            min.RT = min(RT),
            median.RT = median(RT))

# mutate
# make a new data frame, which includes
# a new column that includes the maximum
# RT *for that subject*
d = filter(d) %>%
  group_by(subj) %>%
  mutate(max.RT = max(RT))

tail(select(d, subj, RT, max.RT))

# n(): whatever number of elements there are,
# return that number
d = mutate(d, rownumber = 1:n(),
           nothing = "NOTHING")

d = group_by(d, subj) %>%
  mutate(trial_num = 1:n())

select(d, rownumber, trial_num)

plot(d$trial_num, d$RT)

#### To do in the breakout room
# Filter outliers (decide based on our histograms: what are reasonable RT cutoffs?)
# Find the average RT for each word
# Figure out how arrange() works by using ?arrange or Googling it
# Arrange it by the average RT so we can see the words that generate
# the longest RTs and shortest RTs
# This should be no more than 4 short lines of beautiful tidyverse code!

#### Using mutate()


##### TODO in breakout rooms: use mutate to get the average for each subj
##### Using that average, create ResidualRT, a column which is equal to the
##### difference between RT and that subject's *average* RT
##### make a histogram of this, discuss why this might be a good idea
d = group_by(d, subj) %>%
  mutate(ResidualRT = (RT - mean(RT))/sd(RT))
hist(d$ResidualRT, breaks=40)

group_by(d, subj) %>%
  summarise(raw.RT = mean(RT),
            residual.RT = mean(ResidualRT))



