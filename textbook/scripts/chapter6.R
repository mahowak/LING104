# Statistics for Linguists: An Introduction Using R
# Code presented inside Chapter 6


# --------------------------------------------------------
# 6.2. Multiple regression in R with standardized coefficients

# Load tidyverse and broom pacakges:

library(tidyverse)
library(broom)

# Load iconicity data:

icon <- read_csv('perry_winter_2017_iconicity.csv')

# Check:

icon %>% print(n = 4, width = Inf)

# Log-transform frequency predictor:

icon <- mutate(icon, Log10Freq = log10(Freq))	

# Fit iconicity multiple regression model:

icon_mdl <- lm(Iconicity ~ SER + CorteseImag +
                 Syst + Log10Freq, data = icon)

# How much variance described overall?

glance(icon_mdl)$r.squared

# Look at estimates:

tidy(icon_mdl) %>% select(term, estimate)

# Round for interpretation:

tidy(icon_mdl) %>% select(term, estimate) %>%
	mutate(estimate = round(estimate, 1))

# What's going on with systematicity?
# Is this really as a massive an effect as it looks?
# Let's check the range:

range(icon$Syst, na.rm = TRUE)

# The issue is that the scale is minute.
# So the coefficient looks massive because it ...
# ... is expressed as "one unit" change.

# Let's standardize predictors:

icon <- mutate(icon,
               SER_z = scale(SER),
               CorteseImag_z = scale(CorteseImag),
               Syst_z = scale(Syst),
               Freq_z = scale(Log10Freq))

# Fit model with standardized predictors:

icon_mdl_z <- lm(Iconicity ~ SER_z + CorteseImag_z +
                   Syst_z + Freq_z, data = icon)

# Check that it is still the same model:

glance(icon_mdl_z)$r.squared

# Yes it is.

# Check the coefficients:

tidy(icon_mdl_z) %>% select(term, estimate) %>%
	mutate(estimate = round(estimate, 1))

# Notice how the systematicity coefficient now tends towards 0.



# --------------------------------------------------------
# 6.3. More on assumptions: Assessing normality and constant variance

# Extract residuals of 

res <- residuals(icon_mdl_z)

# Create plot matrix:

par(mfrow = c(1, 3))

# Plot 1, histogram:

hist(res)

# Plot 2, Q-Q plot:

qqnorm(res)
qqline(res)

# Plot 3, residual plot:

plot(fitted(icon_mdl_z), res)

# To gauge your intuition for residual plots...
# ... let's generate some random data:

par(mfrow = c(3, 3))
for (i in 1:9) plot(rnorm(50), rnorm(50))

# Same with non-constant variance:

par(mfrow = c(3, 3))
for (i in 1:9) plot(1:50, (1:50) * rnorm(50))



# --------------------------------------------------------
# 6.4. Collinearity:

# Set seed value so you and I will have the same values:

set.seed(42)

# Generate 'x' with 50 random numbers:

x <- rnorm(50)

# Setup example as in Ch. 4, with a slope of 3:

y <- 10 + 3 * x + rnorm(50)

# Check a simple linear model:

tidy(lm(y ~ x))

# Make a copy of 'x' and change just one number:

x2 <- x
x2[50] <- -1

# What's the correlation of 'x' and 'x2'?

cor(x, x2)

# Very high...

# What if 'x2' is swapped in as a predictor?

tidy(lm(y ~ x2))

# What if both are added to the same model?

xmdl_both <- lm(y ~ x + x2)
tidy(xmdl_both)

# Coefficients now very different.

# Check variance inflation factors:

library(car)
vif(xmdl_both)

# Very high values.

# Check variance inflation factors of iconicity model:

vif(icon_mdl_z)



# --------------------------------------------------------
# 6.5. Adjusted R^2:

# Check adjusted R-squared:

glance(icon_mdl_z)

# It's very similar to the R-squared value = good.







