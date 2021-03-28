# Statistics for Linguists: An Introduction Using R
# Code presented inside Chapter 7


# --------------------------------------------------------
# 7.3. Preprocessing the taste and smell data:

# Load tidyverse and broom package:

library(tidyverse)
library(broom)

# Load senses data:

senses <- read_csv('winter_2016_senses_valence.csv')

# Check:

senses

# Reduce to taste & smell only:

chem <- filter(senses, Modality %in% c('Taste', 'Smell'))

# Check that there's only taste and smell words:

table(chem$Modality)

# Compute descriptive averages:

chem %>% group_by(Modality) %>%
  summarize(M = mean(Val), SD = sd(Val))

# Boxplot of the difference:

chem %>% ggplot(aes(x = Modality, y = Val, fill = Modality)) +
	geom_boxplot() + theme_minimal() +
	scale_fill_brewer(palette = 'PuOr')

# Kernel density of the valence measure:

chem %>% ggplot(aes(x = Val, fill = Modality)) +
	geom_density(alpha = 0.5) + theme_minimal() +
	scale_fill_brewer(palette = 'PuOr')



# --------------------------------------------------------
# 7.4. Treatment coding in R:

# Model of valence by modality:

chem_mdl <- lm(Val ~ Modality, data = chem)

# Look at estimates:

tidy(chem_mdl) %>% select(term, estimate)

# Check first six fitted values:

head(fitted(chem_mdl))

# They are either one of two fitted values, which makes...
# ...sense given that we have two categories.

# Create tibble to generate predictions for:

chem_preds <- tibble(Modality = unique(chem$Modality))

# Check:

chem_preds

# Add predicted vals:

chem_preds$fit <- predict(chem_mdl, chem_preds)

# Check:

chem_preds



# --------------------------------------------------------
# 7.5. Dummy coding by hand:

# Create dummy-coding system by hand:

chem <- mutate(chem,
               Mod01 = ifelse(Modality == 'Taste', 1, 0))

# Compare:

select(chem, Modality, Mod01)

# Fit model with dummy-coded predictor:

lm(Val ~ Mod01, data = chem)



# --------------------------------------------------------
# 7.6. Changing the reference level:

# Changing the reference level:

chem <- mutate(chem,
               Modality = factor(Modality),
               ModRe = relevel(Modality, ref = 'Taste'))

# Alternative without releveling:

chem <- mutate(chem,
               ModRe = factor(Modality, levels = c('Taste', 'Smell')))

# Check:

levels(chem$Modality)
levels(chem$ModRe)

# Fit model and look at estimates:

lm(Val ~ ModRe, data = chem) %>% tidy %>%
	select(term, estimate)



# --------------------------------------------------------
# 7.7. Sum coding in R:

# Just in case, make into factor again:

chem <- mutate(chem, Modality = factor(Modality))

# Check:

class(chem$Modality) == 'factor'

# To look at coding scheme:

contrasts(chem$Modality)

# Compare to treatment coding:

contr.treatment(2)

# Sum-coding:

contr.sum(2)

# Create a new column for the sum-coded predictor:

chem <- mutate(chem,
	ModSum = Modality)

# Change to sum coding:

contrasts(chem$ModSum) <- contr.sum(2)

# Re-fit model with sum-coded predictor:

lm(Val ~ ModSum, data = chem) %>%
	tidy %>% select(term, estimate)

# Show that the intercept is equal to the mean of means:

chem %>% group_by(Modality) %>%
	summarize(MeanVal = mean(Val)) %>%
	summarize(MeanOfMeans = mean(MeanVal))



# --------------------------------------------------------
# 7.8. Categorical predictors with more than two levels

# Go back to the 'senses' tibble, check the modalities:

unique(senses$Modality)

# Fit linear model with this five-level predictor:

sense_all <- lm(Val ~ Modality, data = senses)

# Look at estimates:

tidy(sense_all) %>% select(term:estimate) %>%
	mutate(estimate = round(estimate, 2))

# Create tibble to get predictions for:

sense_preds <- tibble(Modality =
                        sort(unique(senses$Modality)))

# Check:

sense_preds

# Append the fit:

sense_preds$fit <- round(predict(sense_all, sense_preds), 2)

# Check:

sense_preds



# --------------------------------------------------------
# 7.9. Residuals again

# Look at the residuals fo this model:

par(mfrow = c(1, 3))
# Plot 1, histogram:
hist(residuals(sense_all), col = 'skyblue2')
# Plot 2, Q-Q plot:
qqnorm(residuals(sense_all))
qqline(residuals(sense_all))
# Plot 3, residual plot:
plot(fitted(sense_all), residuals(sense_all))



# --------------------------------------------------------
# 7.9. Quick look at Helmert coding:

contr.helmert(5)

