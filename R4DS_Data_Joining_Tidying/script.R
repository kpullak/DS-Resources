# R for Data Science: Data Joins and Tidying
# An NCSU Libraries Workshop 

# Install and load required packages.

install.packages("tidyverse")  #only do this if you haven't installed previously
library(tidyverse)
library(readxl)

# If the libraries have functions with names which conflict with the base R packages
# we see some errors while loading the libraries. The functions from the libraries
# will take precedence, if we want to use the functions from the base packages, we 
# can still use them with the package name (e.g.: stats::filter() function if we
# want to use the base R function over the function which the loaded library provides)

# Section 1: Tidying data 

# 1. Load tech_exports.csv
# Note: this is data on high-technology exports (% of manufacturing exports) by country

tech_exports <- read_csv("tech_exports.csv")
head(tech_exports)

View(tech_exports)

# 2. Tidy the data by collapsing all the year columns into 2 columns: year and exports
tidy_exports <- gather(tech_exports, `1988`:`2016`, key = "year", value = "exports")

# Incase we don't know the names of the columns which we want to tidy, we can get
# the column names using 'names' command
names(tech_exports)
# to view the tidy data in a spread sheet format, we can use the 'view' command
View(tidy_exports)

nrow(tidy_exports)
nrow(tech_exports)
# observation: tidying the data increases the number of rows of data we have

# one reason to tidy the data is when doing a scatter plot, we can use the x-variable as 
# the year and the y-variable as the population (essentially we have just two variables
# which we can plot, rather than having tens of variables)

# 3. Visualize the data with ggplot2 (Come to the graphing workshop for more details...)
tidy_exports %>%
  filter(., country=="United States" | country=="China") %>%
  ggplot(data=., aes(x=year, y=exports, group=country, col=country)) + 
  geom_line() +
  geom_point() +
  theme_classic() +
  labs(title="High Tech Exports, U.S. and China", y="% of Manufacturing Exports")

# '%>%' this symbol is part of the tidyverse, imagine it like a car-wash, 
# this symbol joins different operations of the car-wash process, chaining.

# '+' is part of the ggplot2 graphing syntax

# Note: without having created the variables "year" and "exports", 
# we couldn't have made that graph!

# 4. Practice. Read in sugar.csv and tidy it using the gather() function. Data source: gapminder.org
# This dataset tracks the quantity of sugar and sweeteners consumed in grams per person per day by country

sugar_consumption <- read_csv("sugar.csv")
head(sugar_consumption)
View(sugar_consumption)

tidy_sugar <- gather(sugar_consumption, `1961`:`2013`, key = "year", value = "exports")

# Incase we don't know the names of the columns which we want to tidy, we can get
# the column names using 'names' command
names(tidy_sugar)
# to view the tidy data in a spread sheet format, we can use the 'view' command
View(tidy_sugar)

nrow(sugar_consumption)
nrow(tidy_sugar)

tidy_sugar %>%
  filter(., country=="United States" | country=="China") %>%
  ggplot(data=., aes(x=year, y=exports, group=country, col=country)) + 
  geom_line() +
  geom_point() +
  theme_classic() +
  labs(title="High Tech Exports, U.S. and China", y="% of Manufacturing Exports")

# 5. Spread() function: Break apart columns that have > 1 variable into multiple columns
alcohol <- read_csv("alcohol.csv")  # Data source: https://github.com/alblaine/data-1/tree/master/drug-use-by-age

View(alcohol)

# Quick note on the variables in the alcohol dataset:
# age = age group
# n = sample size
# alcohol-use =	Percentage of those in an age group who used alcohol in the past 12 months
# alcohol-frequency =	Median number of times a user in an age group used alcohol in the past 12 months


# 6. The indicator column has 2 variables. Use spread() to break it into two columns, 1 per unique variable:
names(alcohol)

# 'spread' function breaks down single column into multiple columns, based on unique values for that column
alcohol_tidy <- spread(alcohol, indicator, value)
View(alcohol_tidy)

# 7. Practice. Read in the casepop.csv file and use spread() on the type column.

casepop <- read_csv("casepop.csv")
View(casepop)

casepop_tidy <- spread(casepop, type, count)
View(casepop_tidy)

# Section 2: Joining data tables together

# 8. Load in 4-year public high school graduation rates by state for US states and D.C. (table 1)
graduation <- read_excel("gradrates.xlsx", skip=1) 
View(graduation)

# 9. Load in child poverty rates by state for US states and D.C. (table 2)
# Using 'skip=4' to skip the first 3 rows of data, which is not required
poverty <- read_excel("povrates.xlsx", skip=4)
View(poverty)

# To join tables, you must figure out what the primary key is for both tables.
# The primary key is the column that both tables have in column with unique values 
# that we can match on. What is the primary key for the datasets graduation and poverty?

names(graduation)
names(poverty)

# Guide to data joins: 
# left_join - keep all rows from left table, only matching rows from right
# right_join - keep all rows from right table, only matching rows from left
# inner_join - keep only matching rows from both datasets, and all columns.
# full_join - keep all rows from both datasets

# 10A. Left join. Keep all rows from left table, and keep only matching rows from right table.
gpl <- left_join(graduation, poverty, by = "State")
View(gpl)

# 10B. Right join. Keep all rows from right table, and keep only matching rows from left table.
gpr <- right_join(graduation, poverty, by = "State")
View(gpr)

# 10C. In this case, both joined datasets are equal because both tables had all matching rows.
all.equal(gpl, gpr)

# 11. Let's rename the variables "Total" and "rate" to have more meaningful names
names(gpl) <- c("State", "gradRate", "povRate")


# 12. Create a scatter plot with x = poverty rate, y = graduation rate
ggplot(data=gpl) + 
  geom_point(aes(x=gpl$povRate, y=gpl$gradRate)) + 
  theme_classic() +
  labs(x="Child poverty rate", y="HS Graduation rate")

# 13. Examine if there is a correlation between child poverty and graduation rates.
cor(gpl$povRate, gpl$gradRate)

# 14. Practice: Read in salaries.xlsx, and then 
# join the data to the gpl dataset using inner_join() on the "State" variable.
# example: joined_data <- inner_join(table1, table2, by="primarykey")
# Note: this is teacher salary data from 2015-2016. Source: https://www.sreb.org/k-12-data

salaries <- read_excel("salaries.xlsx")
View(salaries)

gpl_salaries <- inner_join(gpl, salaries, by = "State")
View(gpl_salaries)

#15. Let's change the 201516 variable to the name salaries, since this data is teacher salaries
names(gpl_salaries)
colnames(gpl_salaries)[2] <- "salaries"
names(gpl_salaries)

#16. Let's see the relationship between teacher salaries and poverty Rate as a scatter plot:
ggplot(gpl_salaries, aes(x=salaries, y=povRate)) + geom_point()
