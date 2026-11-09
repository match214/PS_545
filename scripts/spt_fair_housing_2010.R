# A script to clean the data by taking the city year 2010 White share data
# Install packages
library(tidyverse)
library(haven)
library(here)

# Load the data
fair_housing <- read_dta(
  here("data", "raw", "FairHousing.dta")
)

summary(fair_housing$firstyr)

# fair housing lawsuit historgram
fair_housing |>
  filter(!is.na(firstyr)) |>
  ggplot(aes(x = firstyr)) +
  geom_histogram(binwidth = 2)

# calculate change between 2010 white percent and initial white percent
city_change <- fair_housing |>
  filter(!is.na(firstyr)) |>
  group_by(incuplace98) |>
  summarize(
    firstyr = first(firstyr),
    white_initial = pctnhwht_cityi[year == firstyr][1],
    white_2010 = pctnhwht_cityi[year == 2010][1],
    .groups = "drop"
  ) |>
  mutate(
    change_white = white_2010 - white_initial
  )

write_csv(
  city_change,
  here("data", "clean", "city_change.csv")
)
