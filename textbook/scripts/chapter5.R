# Statistics for Linguists: An Introduction Using R
# Code presented inside Chapter 5


# --------------------------------------------------------
# 5.4. Using logarithms to describe magnitudes

# The log10 tracks the order of magnitude:

log10(100) # corresponds to 10 * 10 (2 times multiplied)
log10(1000) # corresponds to multiplying 10 three times

# The logarithm's inverse is the exponential function:

10 ^ 2
10 ^ 3

# Create a vector with five response times:

RTs <- c(600, 650, 700, 1000, 4000)

# Check:

RTs

# Log-transform these with the natural log (base "e"):

logRTs <- log(RTs)

# Check:

logRTs

# To undo the logging, exponentiate to the power of "e":

exp(logRTs)

# This undoes the logging.



# --------------------------------------------------------
# 5.5. Regression analysis of word frequency data in R:

# Load tidyverse and broom packages:

library(tidyverse)
library(broom)

# Load the frequency data (same as Chapter 4):

ELP <- read_csv('ELP_frequency.csv')

# Check content of tibble:

ELP

# Log10-transform frequency, log-transform RTs:

ELP <- mutate(ELP,
              Log10Freq = log10(Freq),
              LogRT = log(RT))

# Check:

ELP

# Plot of the raw frequency data:

ELP %>% ggplot(aes(x = Freq, y = LogRT, label = Word)) +
  geom_text() +
  geom_smooth(method = 'lm') +
  ggtitle('Log RT ~ raw frequency') +
  theme_minimal()

# Compare to the plot of the Log frequency data:

ELP %>% ggplot(aes(x = Log10Freq, y = LogRT, label = Word)) +
  geom_text() +
  geom_smooth(method = 'lm') +
  ggtitle('Log RT ~ raw frequency') +
  theme_minimal()

# Fit a regression model:

ELP_mdl <- lm(LogRT ~ Log10Freq, data = ELP)

# Look at output:

tidy(ELP_mdl)

# Extract coefficients:

b0 <- tidy(ELP_mdl)$estimate[1]	# intercept
b1 <- tidy(ELP_mdl)$estimate[2]	# slope

# Predicted logRT for log frequency of 1 and 3:

logRT_10freq <- b0 + b1 * 1
logRT_1000freq <- b0 + b1 * 3

# Check:

logRT_10freq
logRT_1000freq

# These are the logRT predictions, so exponentiate...
# ... to get raw RTs:

exp(logRT_10freq)
exp(logRT_1000freq)



# --------------------------------------------------------
# 5.6. Centering and standardization in R:

# Center and standardize in one go:

ELP <- mutate(ELP,
              Log10Freq_c = Log10Freq - mean(Log10Freq),
              Log10Freq_z = Log10Freq_c / sd(Log10Freq_c))

# Select the frequency columns to compare:

select(ELP, Freq, Log10Freq, Log10Freq_c, Log10Freq_z)

# Same as before, but this time using scale():

ELP <- mutate(ELP,
              Log10Freq_c = scale(Log10Freq, scale = FALSE),
              Log10Freq_z = scale(Log10Freq))

# Fit raw, centered and unc

ELP_mdl_c <- lm(LogRT ~ Log10Freq_c, ELP)
ELP_mdl_z <- lm(LogRT ~ Log10Freq_z, ELP)

# Check the estimates:

tidy(ELP_mdl) %>% select(term, estimate)
tidy(ELP_mdl_c) %>% select(term, estimate)
tidy(ELP_mdl_z) %>% select(term, estimate)

# Check the R-squared: should be the same:

glance(ELP_mdl)$r.squared
glance(ELP_mdl_c)$r.squared
glance(ELP_mdl_z)$r.squared

# Compare to nonlinear transformation:

glance(lm(LogRT ~ Freq, ELP))$r.squared

# Clearly a different model, since different fit.

# Check correlation:

with(ELP, cor(Log10Freq, LogRT))

# Make linear regression correspond to correlation:

ELP_cor <- lm(scale(LogRT) ~ -1 + Log10Freq_z, ELP)

# Select estimate:

tidy(ELP_cor) %>% select(estimate)

