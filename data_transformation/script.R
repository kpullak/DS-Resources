install.packages("tidyverse")
library(tidyverse)

# While that's installing... checkout the cheatsheet: 
# https://www.rstudio.com/resources/cheatsheets/#dplyr
  
# Load in a dataset. Data on countries of the world.

data <- read_csv("countries.csv")
data

# Research question I: What is the median population of countries in Asia?
# Filter the data to only include the Asia region, and then 
# take the median of the Population variable.

# 1. Use filter() to filter on the Region variable.
a <- data %>% 
  filter(Region == "ASIA") 

head(a)  

# 2. Then use a statistical function median() to take the median value.

median(a$Population)

# Let's do the same steps with the following research question: 
# Research question II: What is the average # phones per 1000 people in Eastern Europe?

# 3. Use filter to create a dataset with only countries in EASTERN EUROPE. 

ee <- data %>%
  filter(Region == "EASTERN EUROPE")

# 4. Now take the average of the `Phones (per 1000)` variable using mean()
mean(ee$`Phones (per 1000)`)

# Research question III: What is the median population of each region?
# Task: group the data by region, and then take the median of each group.

# 5a. Use group_by() to group the data by region and then summarise() to create
# a summary table with the median for each group.

data %>% 
  group_by(Region) %>%
  summarise(medianpop = median(Population)) 

# 5b. Use group_by() to group the data by region and then summarise() to create
# a summary table with the sum for each group.

data %>% 
  group_by(Region) %>%
  summarise(medianpop = sum(Population)) 

# 6. But what if we don't want a summary table? What if we want to add the 
# median data as a new variable (column) in our original dataset? Use group_by() and mutate()

data %>%
  group_by(Region) %>%
  mutate(medianpop = median(Population)) # mutate creates a new column

# We need to assign the computation to a variable then only we will be able to see
# the data appended as a new column. 

# 7. Note we haven't saved any of this until we save it to a variable:
data_medpop <- data %>% 
  group_by(Region) %>%
  mutate(medianpop = median(Population)) # mutate creates a new column 

View(data_medpop)

# Research question IV: What's the average # phones per 1000 people in each region?
# 8. Use group_by() and summarise() to create a summary table of 
# `Phones (per 1000)` for each region. Group by region. Follow example #3.

data %>%
  group_by(Region) %>%
  summarise(Phone_Avg = mean(`Phones (per 1000)`))

# 9. What happened here? Why did we get NA values? Because there were null values in our data. 
# Fix: remove NA values before taking the mean using na.rm=TRUE.

data %>%
  group_by(Region) %>%
  summarise(Phone_Avg = mean(`Phones (per 1000)`, na.rm=TRUE))

# 10. Save the filtered data to a dataset we can use again. Ungroup the data at the end
# as a best practice.

phones_summary <- data %>% 
  group_by(Region) %>%
  summarise(Phone_Avg = mean(`Phones (per 1000)`, na.rm=TRUE)) %>%
  ungroup()

phones_summary

# applying 'ungroup()' function when creating a data subset is a good practice, as we 
# need to ungroup() the dataset before we apply any analytical (or) graphing functions.

# 11. Use group_by() and mutate() to add the average `Phones (per 1000)` data as a new column
# save the data to data_phones

data_phones <- data %>%
  group_by(Region) %>%
  mutate(Phone_Avg = mean(`Phones (per 1000)`)) %>%
  ungroup()
  
# Research question V: What countries have the highest net migration?
# 12. Reorder the rows using arrange(). Sort on the `Net migration` variable.

data %>% 
  arrange(`Net migration`) # arrange sorts data in ascending order of the variable given

# 13. Use View function if you want to see the data in a tab:

View(data %>% 
  arrange(`Net migration`))

# 14. Let's sort the data in descending value of Net migration (largest to smallest)

data %>% 
  arrange(desc(`Net migration`))

View(data %>% 
  arrange(desc(`Net migration`)))

# 15. Let's save the sorted data to a dataframe
migration_sorted <- data %>% 
  arrange(desc(`Net migration`))

# 16.
# Research question VI: What countries have the highest literacy rate? 
# Use arrange() with the `Literacy (%)` variable in descending order.

literacy_sorted <- data %>%
  arrange(desc(`Literacy (%)`))

View(literacy_sorted)

# Let's say we only care about Country and `Literacy (%)` variables. Let's first drop the other variables.
# 17. Use select() to only keep the desired 2 variables: Country, `Literacy (%)`.

data %>% 
  select(Country, `Literacy (%)`)

# 18. Let's do that again but add the arrange() function to sort the data in descending order.
data %>% 
  select(Country, `Literacy (%)`) %>%
  arrange(desc(`Literacy (%)`))

# 19. 
# Use select() to select only Country and Birthrate variables.
data %>% 
  select(Country, Birthrate) 

# 20. Sort this data in order of ascending Birthrate. Do not use desc() since we want ascending order.

data %>% 
  select(Country, Birthrate) %>%
  arrange(Birthrate)

# 21. Let's use select() to drop only Population from the dataset. 
# Use the - sign in front of it to signify you want to drop it. 

data %>% 
  select(-Population) 

# 22. Let's use select to drop multiple variables: Population, `Area (sq. mi.)`, Birthrate
# put the variables you want to drop inside of -c( )

data %>%
  select(-c(Population, `Area (sq. mi.)`, Birthrate))  

# 23. Use select() to drop Deathrate, Climate and Agriculture variables from the dataset data.

data %>%
  select(-c(Deathrate, Climate, Agriculture))