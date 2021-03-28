# Statistics for Linguists: An Introduction Using R
# Code presented inside Chapter 8


# --------------------------------------------------------
# 8.2. Categorical * continuous interactions:

# Load tidyverse and broom package:

library(tidyverse)
library(broom)

# Load iconicity dataset:

icon <- read_csv('perry_winter_2017_iconicity.csv')

# Check:

icon

# Check unique lexical categories (POS = parts-of-speech):

unique(icon$POS)

# Or better, do a table to also see the counts:

sort(table(icon$POS))

# Extract nouns and verbs only:

NV <- filter(icon, POS %in% c('Noun', 'Verb'))

# Check that this worked:

table(NV$POS)

# Fit model without interaction:

NV_mdl <- lm(Iconicity ~ SER + POS, data = NV)

# Extract terms:

tidy(NV_mdl) %>% select(term, estimate)

# Model with interaction:

NV_int_mdl <- lm(Iconicity ~ SER * POS, data = NV)

# Look at terms:

tidy(NV_int_mdl) %>% select(term, estimate)

# Center the SER predictor:

NV <- mutate(NV, SER_c = SER - mean(SER, na.rm = TRUE))

# Fit model with centered SER predictor:

NV_int_mdl_c <- lm(Iconicity ~ SER_c * POS, data = NV)

# Extract terms:

tidy(NV_int_mdl_c) %>% select(term, estimate)



# --------------------------------------------------------
# 8.3. Categorical * categorical interactions

# Load data:

sim <- read_csv('winter_matlock_2013_similarity.csv')

# Check:

sim

# Count the number of data points per condition:

sim %>% count(Phon, Sem)

# Check whether there are NA's:

sum(is.na(sim$Distance))

# Get rid of the NA:

sim <- filter(sim, !is.na(Distance))

# Achieves the same job:

sim <- filter(sim, complete.cases(Distance))

# Check that there is indeed less in this tibble:

nrow(sim)

# Compute the range:

range(sim$Distance)

# Fit model without interaction:

sim_mdl <- lm(Distance ~ Phon + Sem, data = sim)

# Look at terms:

tidy(sim_mdl) %>% select(term, estimate)

# Fit model with interaction:

sim_mdl_int <- lm(Distance ~ Phon * Sem, data = sim)

# Look at coefficients:

tidy(sim_mdl_int) %>% select(term, estimate)

# Create predictions for all combinations:

Phon <- rep(c('Different', 'Similar'), each = 2)
Sem <- rep(c('Different', 'Similar'), times = 2)

Phon
Sem

newdata <- tibble(Phon, Sem)
newdata

newdata$fit <- predict(sim_mdl_int, newdata)

newdata

# Compare to descriptive averages:

newdata %>% group_by(Sem) %>% summarize(distM = mean(fit))

# Transform to factors and add sum coding scheme:

sim <- mutate(sim,
              Phon_sum = factor(Phon),
              Sem_sum = factor(Sem))
contrasts(sim$Phon_sum) <- contr.sum(2)
contrasts(sim$Sem_sum) <- contr.sum(2)

# Refit model:

sum_mdl <- lm(Distance ~ Phon_sum * Sem_sum, data = sim)

# Look at output:

tidy(sum_mdl) %>% select(term, estimate)

# Example:

sumcodes <- tibble(Phon, Sem)
sumcodes$PhonSum <- c(1, 1, -1, -1)
sumcodes$SemSum <- c(1, -1, 1, -1)



# --------------------------------------------------------
# 8.4. Continuous * continuous interactions

# Load Sidhu & Pexman (2017) data:

lonely <- read_csv('sidhu&pexman_2017_iconicity.csv')

# Check:

lonely

# Get rid of negative iconicity values:

lonely <- filter(lonely, Iconicity >= 0)

# Fit model with interaction:

lonely_mdl <- lm(Iconicity ~ SER * ARC, data = lonely)

# Look at terms:

tidy(lonely_mdl) %>% select(term, estimate)

# Standardize predictors:

lonely <- mutate(lonely,
                 SER_z = (SER - mean(SER)) / sd(SER),
                 ARC_z = (ARC - mean(ARC)) / sd (ARC))

# Check:
	
lonely

# Fit model with standardized predictors:

lonely_mdl <- lm(Iconicity ~ SER_z * ARC_z, data = lonely)

# Interpret coefficients:

tidy(lonely_mdl) %>% select(term, estimate)



# --------------------------------------------------------
# 8.5. Polynomial regression for modeling nonlinear effects

# Load data:

vinson_yelp <- read_csv('vinson_dale_2014_yelp.csv')

# Check:

vinson_yelp

# Make a plot of the averages across Yelp review stars:

vinson_yelp %>% group_by(stars) %>%
  summarize(AUI_mean = mean(across_uni_info)) %>%
  ggplot(aes(x = stars, y = AUI_mean)) +
  geom_line(linetype = 2) +
  geom_point(size = 3) +
  theme_minimal()

# To remind yourself of polynomials, plot squared 'x':

x <- -10:10
plot(x, x ^ 2, type = 'l', main = 'Quadratic')

# And cubed 'x':

x <- -10:10
plot(x, x ^ 3, type = 'l', main = 'Cubic')

# Create a squared review-stars variable:

vinson_yelp <- mutate(vinson_yelp,
                      stars_c = stars - mean(stars),
                      stars_c2 = stars_c ^ 2)

# Add linear and squared effects to a model:

yelp_mdl <- lm(across_uni_info ~ stars_c + stars_c2,
               data = vinson_yelp)

# Interpret coefficients:

tidy(yelp_mdl) %>% select(term:estimate)

# Create tibble for predict:

yelp_preds <- tibble(stars_c = 
                       sort(unique(vinson_yelp$stars_c)))
yelp_preds <- mutate(yelp_preds, stars_c2 = stars_c ^ 2)

# Append predictions:

yelp_preds$fit <- predict(yelp_mdl, yelp_preds)

# Check:

yelp_preds

# Make a plot of these predictions:

yelp_preds %>%
  ggplot(aes(x = stars_c, y = fit)) +
  geom_point(size = 3) +
  geom_line(linetype = 2) +
	theme_minimal()


