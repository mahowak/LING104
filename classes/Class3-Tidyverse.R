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

### Filter and select

#### The problem with chaining functions

#### Using %>%


#### Using group_by()


#### Using summarise()


#### Using mutate()


#### To do in the breakout room
# Filter outliers (decide based on our histograms: what are reasonable RT cutoffs?)
# Find the average RT for each word
# Figure out how arrange() works by using ?arrange() or Googling it
# Arrange it by the average RT so we can see the words that generate
# the longest RTs and shortest RTs
# This should be no more than 4 short lines of beautiful tidyverse code!

