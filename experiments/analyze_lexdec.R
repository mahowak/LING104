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
# 10. Reading time.
# 11. KeyCode.
# 12. Newline?
# 13. Sentence (or sentence MD5).
d = read_csv("experiments/lexdec.csv", comment = "#",
             col_names = c("time", "subj", "exp",
                           "item", "element", "type",
                           "garbage", "wordnum", 
                           "word", "RT", "guess", 
                           "Sent")) %>%
  filter(type != "words")

d$correct = (d$guess == "S" & d$type == "wordsYES") | 
            (d$guess == "K" & d$type == "wordsNO")


unique(d$word)

select(d, word, type)


