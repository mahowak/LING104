# Statistics for Linguists: An Introduction Using R
# Code presented inside Chapter 12


# --------------------------------------------------------
# 12.1. Theoretical background: Data-generating processes

# Applying the logistic function to a few values:

plogis(-2)
plogis(0)
plogis(2)

# Even if you enter extremely large or small values...
# ... the logistic function never goes beyond 0/1.



# --------------------------------------------------------
# 12.4. Speech errors and blood alcohol concentration

# Load tidyverse and broom package:

library(tidyverse)
library(broom)

# Load the speech error data:

alcohol <- read_csv('speech_errors.csv')

# Check:

alcohol

# Fit a logistic regression model:

alcohol_mdl <- glm(speech_error ~ BAC,
                   data = alcohol, family = 'binomial')

# Check output:

tidy(alcohol_mdl)

# Extract intercept and coefficient:

intercept <- tidy(alcohol_mdl)$estimate[1]
slope <- tidy(alcohol_mdl)$estimate[2]

# Check:

intercept
slope

# Calculate log odds for 0 and 0.3 blood alcohol:

intercept + slope * 0	# BAC = 0
intercept + slope * 0.3	# BAC = 0.3

# Same, but apply logistic for probabilities:

plogis(intercept + slope * 0)
plogis(intercept + slope * 0.3)

# Create a sequence of BAC values for plotting the model:

BAC_vals <- seq(0, 0.4, 0.01)

# Calculate fitted values:

y_preds <- plogis(intercept + slope * BAC_vals)

# Put this into a new tibble:

mdl_preds <- tibble(BAC_vals, y_preds)
mdl_preds

# Make a plot of data and model:

ggplot(alcohol, aes(x = BAC, y = speech_error)) +
  geom_point(size = 4, alpha = 0.6) +
  geom_line(data = mdl_preds,
            aes(x = BAC_vals, y = y_preds)) +
  theme_minimal()



# --------------------------------------------------------
# 12.5. Predicting the dative alternation:

# Get the dative dataset from the languageR package:

library(languageR)

# Check first two rows:

head(dative, 2)

# Tabulate the response:

table(dative$RealizationOfRecipient)

# Make a model of dative as a function of animacy:

dative_mdl <- glm(RealizationOfRecipient ~ AnimacyOfRec,
                  data = dative, family = 'binomial')

# Look at coefficients:

tidy(dative_mdl)

# Check the order of levels:

levels(dative$RealizationOfRecipient)

# Extract coefficients:

intercept <- tidy(dative_mdl)$estimate[1]
slope <- tidy(dative_mdl)$estimate[2]

# Check:

intercept
slope

# Calculate predictions for animates and inanimates:

plogis(intercept + slope * 0)
plogis(intercept + slope * 1)

animate_pred <- b0 + b1 * 0
inanimate_pred <- b0 + b1 * 1

# Log odds:

animate_pred
inanimate_pred

# Probabilities:

plogis(animate_pred)
plogis(inanimate_pred)



# --------------------------------------------------------
# 12.6. Analyzing gesture perception: Hassemer & Winter (2016)
# 12.6.1. Exploring the dataset:

# Load data and check:

ges <- read_csv('hassemer_winter_2016_gesture.csv')
ges

# Tabulate distribution of participants over conditions:

table(ges$pinkie_curl)

# Tabulate overall responses:

table(ges$choice)

# Proportion of choices:

table(ges$choice) / sum(table(ges$choice))

# Another way to compute proportions:

prop.table(table(ges$choice))

# Tabulate response choice against pinkie curl condition:

xtab <- table(ges$pinkie_curl, ges$choice)
xtab

# Row-wise proportions:

xtab / rowSums(xtab)

# Another way to compute row-wise proportions:

round(prop.table(xtab, margin = 1), digits = 2)


# 12.6.2. Logistic regression analysis:

# The following yields an error...

ges_mdl <- glm(choice ~ pinkie_curl, data = ges)	# error

# ...because the glm() doesn't know which GLM t run.

# Let's supply the  family argument:

ges_mdl <- glm(choice ~ pinkie_curl,
               data = ges, family = 'binomial')	# error

# The 'choice' column is a character but needs to be factor.
# Convert it to factor:

ges <- mutate(ges, choice = factor(choice))

# Check:

class(ges$choice)

# Check order of levels:

levels(ges$choice)

# Fit the logistic regression model:

ges_mdl <- glm(choice ~ pinkie_curl, data = ges,
               family = 'binomial')

# Interpret coefficients:

tidy(ges_mdl)

# Create tibble for predict():

ges_preds <- tibble(pinkie_curl = 1:9)

# Get predicted log odds:

predict(ges_mdl, ges_preds)

# Or probabilities:

plogis(predict(ges_mdl, ges_preds))

# Alternative way to get probabilities:

predict(ges_mdl, ges_preds, type = 'response')

# Extract predictions and compute 95% confidence interval:

ges_preds <- as_tibble(predict(ges_mdl,
                               ges_preds,
                               se.fit = TRUE)[1:2]) %>%
  mutate(prob = plogis(fit),
         LB = plogis(fit - 1.96 * se.fit),
         UB = plogis(fit + 1.96 * se.fit)) %>%
  bind_cols(ges_preds)

# Make a plot of these predictions:

ges_preds %>% ggplot(aes(x = pinkie_curl, y = prob)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = LB, ymax = UB), width = 0.5) +
  scale_x_continuous(breaks = 1:9) +
  xlab('Pinkie curl') +
  ylab('p(y = Shape)') +
  theme_minimal()




