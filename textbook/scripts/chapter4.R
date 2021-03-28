# Statistics for Linguists: An Introduction Using R
# Code presented inside Chapter 4


# --------------------------------------------------------
# 4.6. A simple linear model in R:

# Load tidyverse:

library(tidyverse)

# Generate 50 random numbers:

x <- rnorm(50)

# Check first 6 values:

head(x)

# Create y’s with intercept = 10 and slope = 3:

y <- 10 + 3 * x

# Make a quick plot of the x- and y-values:

plot(x, y, pch = 19)

# The relationship is perfect, so we need to add noise:

error <- rnorm(50)
y <- 10 + 3 * x + error

# Make another plot:

plot(y ~ x)   # looks better

# Fit the model:

lm(y ~ x)

# Printing the model object returns the coefficients:

xmdl

# First six fitted values (predictions):

head(fitted(xmdl))

# First six residuals:

head(residuals(xmdl))

# Summarize the model:

summary(xmdl)

# Extract the coefficients:

coef(xmdl)

# Extract intercept:

coef(xmdl)[1]

# Extract slope:

coef(xmdl)[2]

# Using the names instead of positions:

coef(xmdl)['(Intercept)']
coef(xmdl)['x']

# Compute predicted value for x = 10:

coef(xmdl)['(Intercept)'] + coef(xmdl)['x'] * 10

# Create sequence of numbers from -3 to 3 in 0.1 intervals:

xvals <- seq(from = -3, to = 3, by = 0.1)

# Put this into tibble for predict():

mypreds <- tibble(x = xvals)

# Add fit:

mypreds$fit <- predict(xmdl, newdata = mypreds)

# Check predictions:

mypreds



# --------------------------------------------------------
# 4.7. Linear models with tidyverse functions

# Put data into tibble:

mydf <- tibble(x, y)

# Re-fit model:

xmdl <- lm(y ~ x, data = mydf)

# Load broom package for tidy linear model output:

library(broom)

# Summary:

tidy(xmdl)

# Extract coefficient estimates:

tidy(xmdl)$estimate

# Check overall model performance:

glance(xmdl)

# Make a ggplot of this data:

mydf %>% ggplot(aes(x = x, y = y)) +
  geom_point() + geom_smooth(method = 'lm') +
  theme_minimal()



# --------------------------------------------------------
# 4.8. Model formula notation: Intercept placeholders

# These two formulas produce the same outcome:

xmdl <- lm(y ~ x, data = mydf)
xmdl <- lm(y ~ 1 + x, data = mydf)

# The '1' (one) acts as intercept placeholder...
# ... so the second formula is more explicit.

# Fitting an intercept-only model:

xmdl_null <- lm(y ~ 1, data = mydf)

# Look at the intercept estimate:

coef(xmdl_null)

# Compare against the mean:

mean(y)   # same



