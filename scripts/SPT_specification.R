# 0 Adding a new variable to the new model. ----------------------------------------------------




# 1 Load the libraries. ---------------------------------------------------

library(tidyverse)
library(haven) # load in a stata file
library(fixest) # testing model 1 with fixed effects
library(broom) # get coefficients


# 2 Load in the data. -----------------------------------------------------

my_data <- read_dta(file.choose()) # this is the coolest function ever

# 3 Build dataset for the OLS models. ---------------------------------------

table2_dataraw <- my_data |>
  select(incuplace98,
         fairhousingimp_v1,
         pctnhwht_cityi,
         pctrenter_cityi,
         pctwlth_city2i,
         logpop,
         homevali,
         pct_vacanti,
         year,
         minyear)

# 4 Filter the data to the right year frame. ------------------------------

table2_datayears <- table2_dataraw |>
  filter(year > 1968,
         minyear < 2011)

# Check against Trounstine's observations
nrow(table2_datayears)

# check against Trounstine's cities
table2_datayears |>
  summarize(
    cities = n_distinct(incuplace98, na.rm = TRUE)
  )
# The paper reports 4,568 cities. The variable "incuplace98" contains 4,566 
# unique municipalities, closely matching the published count

# 5b Build the OLS model 2. -------------------------------------------------------
# Remove Control variables of home value, and percent vacant
# this model using the fixest feols() function, and does it much faster
model_2_fe <-feols(pctnhwht_cityi ~ fairhousingimp_v1  +
                     pctrenter_cityi +
                     pctwlth_city2i +
                     logpop |
                     incuplace98 + year,
                   data = table2_datayears
)

# check against Table 2
summary(model_2_fe) # get the coefficients
coef(model_2_fe)["(Intercept)"] # derive the intercept constant
