# Statistics for Linguists: An Introduction Using R
# Code presented inside Chapter 13


# --------------------------------------------------------
# 13.3. Analyzing linguistic diversity using Poisson regression:

# Load tidyverse and broom package:

library(tidyverse)
library(broom)

# Load data:

nettle <- read_csv('nettle_1999_climate.csv')

# Check:

nettle

# What's the range of the predictor?

range(nettle$MGS)

# Check the most extreme values:

filter(nettle, MGS == 0 | MGS == 12)

# Same, but more elegant:

filter(nettle, MGS %in% range(MGS))

# Fit a Poisson regression model:

MGS_mdl <- glm(Langs ~ MGS, data = nettle,
               family = 'poisson')

# Inspect model:

tidy(MGS_mdl)

# Extract coefficients:

mycoefs <- tidy(MGS_mdl)$estimate

intercept <- mycoefs[1]
intercept

slope <- mycoefs[2]
slope

# Compute predictions for 0 to 12 months MGS:

intercept + 0:12 * slope

# These are logs. Compute predicted rates:

exp(intercept + 0:12 * slope)

# For plotting, let's use a smaller stepsize:

myMGS <- seq(0, 12, 0.1)

# Put this into a tibble for predict():

newdata <- tibble(MGS = myMGS)

# Check:

newdata

# Get predictions:

MGS_preds <- predict(MGS_mdl, newdata)
head(MGS_preds)

# Exponentiate for rates:

MGS_preds <- exp(MGS_preds)
head(MGS_preds)

# Alternatively, specify the argument type = 'response':

MGS_preds <- predict(MGS_mdl, newdata, type = 'response')
head(MGS_preds)

# Put predictor values and predictions into same tibble:

mydf <- tibble(MGS = myMGS, Rate = MGS_preds)
mydf

# Create plot:

nettle %>% ggplot(aes(x = MGS, y = Langs)) +
  geom_text(aes(label = Country)) +
  geom_line(data = mydf, mapping = aes(x = MGS, y = Rate),
            col = 'blue', size = 1) +
  theme_minimal()



# --------------------------------------------------------
# 13.4. Adding exposure variables:

# Adding exposure variables:

MGS_mdl_exposure <- glm(Langs ~ MGS + offset(Area),
                        data = nettle, family = 'poisson')

tidy(MGS_mdl_exposure)



# --------------------------------------------------------
# 13.4. Negative binomial regression for overdispersed count data:

# Accounting for overdispersion:

library(MASS)
MGS_mdl_nb <- glm.nb(Langs ~ MGS + offset(Area),
                     data = nettle)

# Check summary:

summary(MGS_mdl_nb)

# Perform overdispersion test:

library(pscl)
odTest(MGS_mdl_nb)


