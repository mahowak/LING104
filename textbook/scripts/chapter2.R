# Statistics for Linguists: An Introduction Using R
# Code presented inside Chapter 2


# --------------------------------------------------------
# 2.1. Introduction to the tidyverse:

# Install package if you haven't done so already:

install.packages('tidyverse')

# Load the tidyverse package:

library(tidyverse)

# This loads several relate packages. Relevant for us are:
# tibble, readr, dplyr, magrittr, and ggploot2



# --------------------------------------------------------
# 2.2. tibble and readr:

# Set your working directory to data folder here.

# Load Nettle (1999) data with read.csv():

nettle <- read.csv('nettle_1999_climate.csv')

# This is a data frame. Transform to tibble as follows:

nettle <- as_tibble(nettle)

# Check:

nettle

# Notice that the text columns are coded as factors.
# This is because of the defaults of read.csv().

# Load in Nettle (1999) the tidy way, with read_csv():

nettle <- read_csv('nettle_1999_climate.csv')

# Text columns are now coded as characters:

nettle

# Load in tab-delimited file as follows:

x <- read_delim('example_file.txt', delim = '\t')
x



# --------------------------------------------------------
# 2.3. dplyr:

# Filter nettle tibble to countries with >500 languages:

filter(nettle, Langs > 500)

# Reduce nettle tibble to row with 'Nepal':

filter(nettle, Country == 'Nepal')

# Select 'Langs' and 'Country' columns from nettle tibble:

select(nettle, Langs, Country)

# Select everything but the 'Country' column:

select(nettle, -Country)

# Select consecutive columns from 'Area' to 'Langs':

select(nettle, Area:Langs)

# Rename the 'Population' column to 'Pop':

nettle <- rename(nettle, Pop = Population)
nettle

# Create new column called 'Lang100' ...
# ... which contains "languages in 100ths" measure:

nettle <- mutate(nettle, Lang100 = Langs / 100)
nettle

# Sort tibble in ascending order by 'Langs' column:

arrange(nettle, Langs)

# Same, descending order:

arrange(nettle, desc(Langs))



# --------------------------------------------------------
# 2.4. ggplot2:

# Create a scatterplot with MGS on the x-axis, and ...
# ... the language count on the y-axis:

ggplot(nettle) +
  geom_point(mapping = aes(x = MGS, y = Langs))

# The aesthetic mappings can also be defined in the ...
# ... ggplot2 function call (rather than in the geom) ...
# ... in which case all following geoms use the same ...
# ... mapping. Also, the aesthetics argument does not ...
# ... have to be named.

ggplot(nettle, aes(x = MGS, y = Langs)) +
  geom_point()

# Swapping geom_point() with geom_text() returns an error:

ggplot(nettle, aes(x = MGS, y = Langs)) +
  geom_text()

# Because this geom needs an additional mapping, it ...
# ...needs to knwo which column contains the text to plot!

ggplot(nettle, aes(x = MGS, y = Langs, label = Country)) +
  geom_text()

# To save an open ggplot, just type:

ggsave('nettle.png', width = 8, height = 6)

# To create a double-plot, first save each plot:

plot1 <- ggplot(nettle) +
  geom_point(mapping = aes(x = MGS, y = Langs))

plot2 <- ggplot(nettle,
	aes(x = MGS, y = Langs, label = Country)) +
  geom_text()

# Then use 'gridExtra' to create double-plot:

library(gridExtra)
grid.arrange(plot1, plot2, ncol = 2)



# --------------------------------------------------------
# 2.5 Piping with magrittr:

# Create a plotting pipeline:

nettle %>%
  filter(MGS > 8) %>%
	ggplot(aes(x = MGS, y = Langs, label = Country)) +
	geom_text()



# --------------------------------------------------------
# 2.6 A more extensive example: iconicity and the senses:

# Load in data:

icon <- read_csv('perry_winter_2017_iconicity.csv')
mod <- read_csv('lynott_connell_2009_modality.csv')

# Check iconicity tibble:

icon

# Reduce tibble to relevant columns via select():

icon <- select(icon, Word, POS, Iconicity)
icon

# Check range of the iconicity measure:

range(icon$Iconicity)

## Draw a histogram:

ggplot(icon, aes(x = Iconicity)) +
  geom_histogram(fill = 'peachpuff3') +
  geom_vline(aes(xintercept = 0), linetype = 2) +
  theme_minimal()

# Check the contents of the mod tibble:

mod

# To display all columns:

mod %>% print(width = Inf)

# To display all rows:

mod %>% print(n = Inf)

# Take relevant subset:

mod <- select(mod, Word, DominantModality:Smell)

# Check:

mod

# Rename 'DominantModality' column to 'Modality':

mod <- rename(mod, Modality = DominantModality)

# Check random rows to get a feel for the tibble:

sample_n(mod, 4)

# Merge the 'mod' tibble into the 'icon' tibble:

both <- left_join(icon, mod)

# Take only the three major content classes:

both <- filter(both,
               POS %in% c('Adjective', 'Verb', 'Noun'))

# Make a boxplot of iconicity as a function of modality:

ggplot(both,
       aes(x = Modality, y = Iconicity, fill = Modality)) +
  geom_boxplot() + theme_minimal()

# Pipeline that excludes NAs:

both %>% filter(!is.na(Modality)) %>%
  ggplot(aes(x = Modality, y = Iconicity,
             fill = Modality)) +
  geom_boxplot() + theme_minimal()

# Let's count modalities:

both %>% count(Modality)

## Let's make a bar plot:

both %>% count(Modality) %>%
  filter(!is.na(Modality)) %>%
  ggplot(aes(x = Modality, y = n, fill = Modality)) +
  geom_bar(stat = 'identity') + theme_minimal()

# Same bar plot without creating an intervening tibble ...
# ... of counts by hand. This time, geom_bar() does ...
# ... the counting:

both %>% filter(!is.na(Modality)) %>%
  ggplot(aes(Modality, fill = Modality)) +
  geom_bar(stat = 'count') + theme_minimal()

