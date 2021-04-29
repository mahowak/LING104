library(tidyverse)
#library(googlesheets4)

d = read_csv("LING104/classes/anchor_data.csv")

d$LogL = log(d$`How many independent (unrelated) language families are there in the world? (Don't Google!)`)

plot(d$`Generate one random number between 1 and 1000 and write it here.`,
     d$LogL)

d$random = d$`Generate one random number between 1 and 1000 and write it here.`
d$lang = d$`How many independent (unrelated) language families are there in the world? (Don't Google!)`

plot(d$random, d$lang)

# Goal: predict how many language families were guessed
mean(d$lang)
d$mean.prediction = mean(d$lang)
sum((d$lang - d$mean.prediction)**2)

# fit a line
ggplot(d, aes(x=random, lang)) + geom_point() +
  xlim(0, 1000) + 
  ylim(0, 100)

# equation of a line: y = mx + b
# a function that maps from x to y
# take x (random number) as an input
# spit out a PREDICTED y value as output
ggplot(d, aes(x=random, lang)) + geom_point() +
  xlim(0, 1000) + 
  ylim(0, 100) + 
  geom_abline(intercept = 12.5,
              slope = 1/10)

# sum squared error when we use the mean to make 
# our predictions
sum((d$lang - d$mean.prediction)**2)

generate.prediction.from.line <- function(x) {
  y = 12.5 + (1/10) * x
  return(y)
}

d$prediction.line = generate.prediction.from.line(d$random)

# plot predictions of the line 
ggplot(d, aes(x=random, lang)) + geom_point() +
  xlim(0, 1000) + 
  ylim(0, 100) + 
  geom_abline(intercept = 12.5,
              slope = 1/10,
              colour="red") +
  geom_point(data=d, aes(x=random, y=prediction.line), colour="red")

# sum squared error when we use the mean to make 
# our predictions
sum((d$lang - d$prediction.line)**2)

ggplot(d, aes(x=random, lang)) + geom_point() +
  xlim(0, 1000) + 
  ylim(0, 100) + 
  geom_abline(intercept = 12.5,
              slope = 1/10,
              colour="red") +
  geom_point(data=d, aes(x=random, y=prediction.line), colour="red") +
  geom_point(data=d, aes(x=random, y=mean.prediction), colour="darkgreen")

###########
generate.prediction.from.some.line <- function(x, intercept, slope) {
  y = intercept + slope * x
  return(y)
}

sum((d$lang - d$prediction.line)**2)

d$prediction.line.2 = generate.prediction.from.some.line(d$random, 12, 1/10)
sum((d$lang - d$prediction.line.2)**2)

d$prediction.line.3 = generate.prediction.from.some.line(d$random, 12, 1/11)
sum((d$lang - d$prediction.line.3)**2)

ggplot(d, aes(x=random, lang)) + geom_point() +
  xlim(0, 1000) + 
  ylim(0, 100) + 
  geom_abline(intercept = 12.5,
              slope = 1/10,
              colour="red") +
  geom_point(data=d, aes(x=random, y=prediction.line), colour="red") +
  geom_point(data=d, aes(x=random, y=mean.prediction), colour="darkgreen") +
  geom_point(data=d, aes(x=random, y=prediction.line.3), colour="blue")  +
  geom_abline(intercept = 12,
              slope = 1/11,
              colour="blue") +
  geom_abline(intercept = mean(d$lang),
              slope = 0,
              colour="darkgreen")

# automate the processs of finding the line
# that minimizes the sum of the squared error

try.for.int = seq(5, 20, .01)
try.for.slope = seq(0, 1, .005)  

best.sum.squared.error = 10000
best.int = NULL
best.slope = NULL
for (i in try.for.int) {
  for (j in try.for.slope) {
    d$try.prediction = generate.prediction.from.some.line(d$random, i, j)
    sum.squared.error = sum((d$lang - d$try.prediction)**2)
    if (sum.squared.error < best.sum.squared.error) {
      best.sum.squared.error = sum.squared.error
      best.int = i
      best.slope = j
    }
  }
}

best.int
best.slope

# add these best values onto our plot in orange
d$prediction.line.best = generate.prediction.from.some.line(
  d$random, best.int, best.slope)

ggplot(d, aes(x=random, lang)) + geom_point() +
  xlim(0, 1000) + 
  ylim(0, 100) + 
  geom_abline(intercept = 12.5,
              slope = 1/10,
              colour="red") +
  geom_point(data=d, aes(x=random, y=prediction.line), colour="red") +
  geom_point(data=d, aes(x=random, y=mean.prediction), colour="darkgreen") +
  geom_point(data=d, aes(x=random, y=prediction.line.3), colour="blue")  +
  geom_point(data=d, aes(x=random, y=prediction.line.best), colour="orange")  +
  geom_abline(intercept = 12,
              slope = 1/11,
              colour="blue") +
  geom_abline(intercept = mean(d$lang),
              slope = 0,
              colour="darkgreen") + 
  geom_abline(intercept = best.int,
              slope = best.slope,
              colour="orange") +
  geom_smooth(method=lm, se=F)

# 
lm(data=d, lang ~ random)



###############
# TRY TO MORE PRECISELY ESTIMATE THE REGRESSION 
try.for.int = seq(11, 13, .001)
try.for.slope = seq(.8, .14, .001)  

best.sum.squared.error = 10000
best.int = NULL
best.slope = NULL
for (i in try.for.int) {
  for (j in try.for.slope) {
    d$try.prediction = generate.prediction.from.some.line(d$random, i, j)
    sum.squared.error = sum((d$lang - d$try.prediction)**2)
    if (sum.squared.error < best.sum.squared.error) {
      best.sum.squared.error = sum.squared.error
      best.int = i
      best.slope = j
    }
  }
}

best.int
best.slope

# What if this data is noise?

d$lang.random = sample(d$lang)
ggplot(d, aes(x=random, lang.random)) + geom_point() +
  xlim(0, 1000) + 
  ylim(0, 100) + 
  geom_smooth(method=lm, se=F)

summary(lm(data=d, lang ~ random))

