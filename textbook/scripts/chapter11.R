# Statistics for Linguists: An Introduction Using R
# Code presented inside Chapter 11:
# Inferential statistics 3


# --------------------------------------------------------
# 11.2. Standard errors and confidence intervals for regression coefficients

# Load tidyverse and broom package:

library(tidyverse)
library(broom)

# Load data:

icon <- read_csv('perry_winter_2017_iconicity.csv')

# Print first four rows:

icon %>% print(n = 4)

# Standardize predictors:

icon <- mutate(icon,
               SER_z = scale(SER),
               CorteseImag_z = scale(CorteseImag),
               Syst_z = scale(Syst),
               Freq_z = scale(Freq))

# Fit model:

icon_mdl_z <- lm(Iconicity ~ SER_z + CorteseImag_z +
                   Syst_z + Freq_z, data = icon)

# Look at coefficient table:

tidy(icon_mdl_z) %>%
  mutate(p.value = format.pval(p.value, 4),
         estimate = round(estimate, 2),
         std.error = round(std.error, 2),
         statistic = round(statistic, 2))

# Recreate dot-and-whisker plot:

mycoefs <- tidy(icon_mdl_z, conf.int = TRUE) %>%
	filter(term != '(Intercept)')

mycoefs %>% ggplot(aes(x = term, y = estimate)) +
  geom_point() +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high),
                width = 0.2) +
  geom_hline(yintercept = 0, linetype = 2) +
  coord_flip() + theme_minimal()

# Rerun with recoded factor:

pred_order <- arrange(mycoefs, estimate)$term
pred_order

mycoefs <- mutate(mycoefs,
                  term = factor(term, levels = pred_order))

# Rerun the plotting command:

mycoefs %>% ggplot(aes(x = term, y = estimate)) +
	geom_point() +
	geom_errorbar(aes(ymin = conf.low, ymax = conf.high),
	width = 0.2) +
		coord_flip() + theme_minimal()



# --------------------------------------------------------
# 11.3. Significance tests with multi-level categorical predictors

# Load data:

senses <- read_csv('winter_2016_senses_valence.csv')

# First four rows:

senses %>% print(n = 4)

# Fit a model:

senses_mdl <- lm(Val ~ Modality, data = senses)

# Look at the coefficients:

tidy(senses_mdl) %>%
  mutate(estimate = round(estimate, 2),
         std.error = round(std.error, 2),
         statistic = round(statistic, 2),
         p.value = format.pval(p.value, 4))

# Fit null model (intercpet-only):

senses_null <- lm(Val ~ 1, data = senses)

# Model comparison:

anova(senses_null, senses_mdl)

# Overall model performance is the same in this case:

glance(senses_mdl)

# (This is the case because there's only one predictor)

# Load emmeans library:

library(emmeans)

# Perform full suite of pairwise comparisons...
# ... with Bonferroni correction:

emmeans(senses_mdl, list(pairwise ~ Modality),
        adjust = 'bonferroni')



# --------------------------------------------------------
# 11.4. Another example: the absolute valence of taste and smell words

# Create an absolute valence measure ('folded valence'):

senses <- mutate(senses,
                 Val_z = scale(Val),
                 AbsVal = abs(Val_z))

# Fit a model:

abs_mdl <- lm(AbsVal ~ Modality, data = senses)

# Look at overall modality effect:

anova(abs_mdl)

# Chemical senses vector:

chems <- c('Taste', 'Smell')

# Create a chemical senses vs. other variable:

senses <- mutate(senses,
                 ChemVsRest = ifelse(Modality %in% chems,
                                     'Chem', 'Other'))

# Quick sanity check of the new column:

with(senses, table(Modality, ChemVsRest))

# Perform linear model:

abs_mdl <- lm(AbsVal ~ ChemVsRest, data = senses)

# Check output:

tidy(abs_mdl)



# --------------------------------------------------------
# 11.5. Communicating uncertainty around predictions: categorical data

# Get predictions:

newpreds <- tibble(Modality =
                        sort(unique(senses$Modality)))

# Check:

newpreds

# Append fitted values to tibble:

fits <- predict(senses_mdl, newpreds)

# Check:

fits

# Add standard errors of predictions:

SEs <- predict(senses_mdl, newpreds,
               se.fit = TRUE)$se.fit

# Check:

SEs

# Put this into a tibble to compute 95% CIs:

CI_tib <- tibble(fits, SEs)

CI_tib

# Compute CIs:

CI_tib <- mutate(CI_tib,
                 LB = fits - 1.96 * SEs, # lower bound
                 UB = fits + 1.96 * SEs) # upper bound

# Check:

CI_tib

# Comparison:

sense_preds <- predict(senses_mdl, newpreds, interval = 'confidence')

sense_preds

# Append modality labels:

sense_preds <- cbind(newpreds, sense_preds)

sense_preds

# Make a plot of the predictions:

sense_preds %>%
	ggplot(aes(x = Modality, y = fit)) +
		geom_point() +
		geom_errorbar(aes(ymin = lwr, ymax = upr)) +
		theme_minimal()

# Extract ascending order:

sense_order <- arrange(sense_preds, fit)$Modality

# Set factor to this order:

sense_preds <- mutate(sense_preds,
                      Modality = factor(Modality,
                                        levels = sense_order))

# Better plot:

sense_preds %>%
  ggplot(aes(x = Modality, y = fit)) +
  geom_point(size = 4) +
  geom_errorbar(aes(ymin = lwr, ymax = upr),
                size = 1, width = 0.5) +
  ylab('Predicted emotional valence\n') +
  theme_minimal() +
  theme(axis.text.x =
          element_text(face = 'bold', size = 15),
        axis.text.y =
          element_text(face = 'bold', size = 15),
        axis.title =
          element_text(face = 'bold', size = 20))



# --------------------------------------------------------
# 10.6. Communicating uncertainty for continuous data

# Load data:

ELP <- read_csv('ELP_frequency.csv')

# Log-transform:

ELP <- mutate(ELP,
	Log10Freq = log10(Freq))

# Check:

ELP

# Fit RT by log frequency model:

ELP_mdl <- lm(RT ~ Log10Freq, ELP)

# Create tibble with new data:

newdata <- tibble(Log10Freq = seq(0, 5, 0.01))

# Compute 95% confidence interval:

preds <- predict(ELP_mdl, newdata,
                 interval = 'confidence')

# Check:

head(preds)

# Glue together:

preds <- cbind(newdata, preds)

head(preds)

# Plot:

preds %>% ggplot(aes(x = Log10Freq, y = fit)) +
  geom_ribbon(aes(ymin = lwr, ymax = upr),
              fill = 'grey', alpha = 0.5) +
  geom_line() +
  geom_text(data = ELP, aes(y = RT, label = Word)) +
  theme_minimal()







