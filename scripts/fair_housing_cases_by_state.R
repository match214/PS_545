# 1. Install and load required packages

library(haven) 
library(tidyverse)
# set working directory to replciation
setwd("C:/Users/mattc/OneDrive - University Of Oregon/Classes/2026 Fall/PS 545/Replication study")
# import FairHousing data file
fair_housing <- read_dta("FairHousing.dta")
# check out the data
head(fair_housing)
dim(fair_housing)
class(fair_housing)

# explore the fair housing cases vairable to see what the data are like
unique(fair_housing$fairhousingcase)

# Clean fair housing cases
case_data <- fair_housing |>
  filter(!is.na(fairhousingcase))

# check to see if all the NA values are gone
sum(is.na(case_data$fairhousingcase))

# aggregate the data to be at the city level
# this code groups the cleaned fair housing case data by the State variables and sums the case by state
state_counts <- case_data |>
  group_by(state) |>
  summarize(
    fair_cases = sum(fairhousingcase),
    .groups = "drop"
  )


# plot the historgram
ggplot(state_counts, aes(x = fair_cases,))+
  geom_histogram(
    bins= 10,
    fill = "lightblue",
    color = "gray"
  )+
  labs(
    title = "Distribution of Total Fair Housing Cases by State",
    x = "Fair Housing Cases",
    y = "Number of States")


# Save the last displayed plot to the working directory
ggsave("state_fair_housing_cases.png")
