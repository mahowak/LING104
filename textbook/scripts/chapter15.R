# Statistics for Linguists: An Introduction Using R
# Code presented inside Chapter 15:
# Chapter 15


# --------------------------------------------------------
# 15.2. Simulating vowel durations for a mixed model analysis:

# Load tidyverse:

library(tidyverse)

# Set seed value:

set.seed(666)

# Generate participant identifiers for 6 participants & 20 items:

ppt_ids <- gl(6, 20)

# Check:


ppt_ids

# 20 item identifiers:

it_ids <- gl(20, 1)

# Check:

it_ids

# Repeat each 6 times for participant numbers:

it_ids <- rep(it_ids, 6)

# Check that length is the same:

length(ppt_ids)

length(it_ids)

# Create predictor values (mock frequencies):

logfreqs <- round(rexp(20) * 5 , 2)

# Check:

logfreqs

# Repeat for 6 participants:

logfreqs <- rep(logfreqs, 6)

# Check length is the same as the others (=120):

length(logfreqs)

# Check the content:

logfreqs

# Put predictors into tibble:

xdata <- tibble(ppt = ppt_ids, item = it_ids, freq = logfreqs)

# Check:

xdata

# Add intercept:

xdata$int <- 300

# Create participant deviation scores:

ppt_ints <- rnorm(6, sd = 40)
ppt_ints

# Add them, each repeat 20 times to main tibble:

xdata$ppt_ints <- rep(ppt_ints, each = 20)

# Check:

xdata

# Same for items:

item_ints <- rnorm(20, sd = 20)

item_ints

item_ints <- rep(item_ints, times = 6)

# Check length is 120:

length(item_ints)

# Add to tibble:

xdata$item_ints <- item_ints

# Add general error term:

xdata$error <- rnorm(120, sd = 20)

# Add effect:

xdata$effect <- -5 * xdata$freq

# Check:

xdata %>% head(4)

# Put all the different effects into the main response:

xdata <- mutate(xdata,
                dur = int + ppt_ints + item_ints +
                  error + effect)

# For pedagogical purposes, get rid of what's been used to create stuff:

xreal <- dplyr::select(xdata, -(int:effect))

# This is what you would have as the researcher:

xreal



# --------------------------------------------------------
# 15.3. Analyzing the simulated vowel durations with mixed models:

# Load lme4 library:

library(lme4)

# Create varying intercept model:

xmdl <- lmer(dur ~ freq + (1|ppt) + (1|item),
             data = xreal, REML = FALSE)

# Inspect:

summary(xmdl)



# --------------------------------------------------------
# 15.4. Extracting information out of lme4 objects:

# Fixed effects coefficients:

fixef(xmdl)

# Works as usual, e.g., extract slope:

fixef(xmdl)[2]

# Retrieve coefficient table:

summary(xmdl)$coefficients

# Random effects coefficients:

coef(xmdl)

# Participant random effects:

coef(xmdl)$ppt

# Participant deviation scores:

ranef(xmdl)$ppt



# --------------------------------------------------------
# 15.5. Messing up the model:

# Dropping item random intercepts:

xmdl_bad <- lmer(dur ~ freq + (1|ppt),
                 data = xdata, REML = FALSE)
summary(xmdl_bad)

# Adding random slopes even though we didn't generate them:

xmdl_slope <- lmer(dur ~ freq + (1 + freq|ppt) + (1|item),
                   data = xdata, REML = FALSE)

summary(xmdl_slope)$varcor

# Extract participant slopes:

coef(xmdl_slope)$ppt

# De-correlate random effects structure:

xmdl_slope_nocorr <- lmer(dur ~ freq +
                            (1|ppt) + (1|item) +
                            (0 + freq|ppt),
                          data = xdata, REML = FALSE)
summary(xmdl_slope_nocorr)$varcor

# Notice that the random slopes are all the same:

coef(xmdl_slope_nocorr)$ppt



# --------------------------------------------------------
# 15.6. Likelihood ratio tests:

# Construct null model without fixed effect:

xmdl_nofreq <- lmer(dur ~ 1 + (1|ppt) + (1|item),
                    data = xreal, REML = FALSE)

# Model comparison:

anova(xmdl_nofreq, xmdl, test = 'Chisq')

# Full model:

x_REML <- lmer(dur ~ freq + (1|ppt) + (1|item),
               data = xdata, REML = TRUE)

# Reduced model (no item random intercepts):

x_red <- lmer(dur ~ freq + (1|ppt),
              data = xdata, REML = TRUE)

anova(x_red, x_REML, test = 'Chisq', refit = FALSE)

# Use afex for testing fixed effects:

library(afex)
xmdl_afex <- mixed(dur ~ freq + (1|ppt) + (1|item),
                   data = xdata, method = 'LRT')
xmdl_afex

fixef(xmdl_afex$full_model)



# --------------------------------------------------------
# 15.7.2. Computing R-squared for mixed models:

library(MuMIn)
r.squaredGLMM(xmdl_afex$full_model)



# --------------------------------------------------------
# 15.7.3. Predictions from mixed models:

xvals <- seq(0, 18, 0.01)
yvals <- fixef(xmdl_afex$full_model)[1] +
  fixef(xmdl_afex$full_model)[2] * xvals
head(yvals)



# --------------------------------------------------------
# 15.8. Mixed logistic regression: Ugly selfies

# Load data:

selfie <- read_csv('/Users/winterb/Books/stats_textbook/final_version_cut_down/data/ruth_page_selfies.csv')

# Check:

selfie

# Make response into factor:

selfie <- mutate(selfie, UglyCat = factor(UglyCat))

# Create model:

ugly_mdl <- glmer(UglyCat ~ Angle +
                (1 + Angle|ID), data = selfie,
              family = 'binomial')

# Yields a convergence issue:

all_fit(ugly_mdl)   # output not shown

# Refit with bobyqa:

ugly_mdl <- glmer(UglyCat ~ Angle + 
                    (1 + Angle|ID), data = selfie,
                  family = 'binomial',
                  control =
                    glmerControl(optimizer = 'bobyqa'))

summary(ugly_mdl)

levels(selfie$UglyCat)



