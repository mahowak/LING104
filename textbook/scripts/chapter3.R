# Statistics for Linguists: An Introduction Using R
# Code presented inside Chapter 3


# --------------------------------------------------------
# 3.7. Summary statistics in R:

# Generate 50 random uniformly distributed numbers:

x <- runif(50)

# Check:

x

# Specify min and max:

x <- runif(50, min = 2, max = 6)

# Check:

head(x)

# Create a quick-and-dirty base R plot:

hist(x, col = 'steelblue')

# Generate random normally distributed numbers & plot 'em:

x <- rnorm(50)
hist(x, col = 'steelblue')
abline(v = mean(x), lty = 2, lwd = 2)

# Create random data with mean = 5 and SD = 2:

x <- rnorm(50, mean = 5, sd = 2)

# Check mean and SD:

mean(x)
sd(x)

# Check the percentiles:

quantile(x)

# Check the values that span the 68% interval:

quantile(x, 0.16)
quantile(x, 0.84)

# This should correspond to +/- 1 SD around the mean:

mean(x) - sd(x)
mean(x) + sd(x)

# The values of the 95% interval:

quantile(x, 0.025)
quantile(x, 0.975)

# This should correspond to +/- 2 SD around the mean:

mean(x) - 2 * sd(x)
mean(x) + 2 * sd(x)

# Execture repeatedly to get a feel for the normal:

hist(rnorm(n = 20))



# --------------------------------------------------------
# 3.8. Exploring the emotional valence ratings:

# Load tidyverse and Warriner et al. (2013) data:

library(tidyverse)

war <- read_csv('warriner_2013_emotional_valence.csv')

# Check:

war

# Check valence measure range:

range(war$Val)

# Check the least and most positive wors:

filter(war, Val == min(Val) | Val == max(Val))

# Same thing, but more compact:

filter(war, Val %in% range(Val))

# Check tibble in ascending order:

arrange(war, Val)

# And descending order:

arrange(war, desc(Val))

# Mean and SD:

mean(war$Val)
sd(war$Val)

# 68% rule:

mean(war$Val) + sd(war$Val)
mean(war$Val) - sd(war$Val)

# Confirm:

quantile(war$Val, c(0.16, 0.84))

# Median:

median(war$Val)

# Which is the same as the 50th percentile:

quantile(war$Val, 0.5)


