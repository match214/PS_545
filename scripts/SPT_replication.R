# 0 Model Comparisons. ----------------------------------------------------


# Published Trounstine Table 2 Results
# Model 1: -0.051
# Model 2: -0.053
#
# Replicated Results
# Model 1: -0.0507
# Model 2: -0.0527


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


# 5a Build the OLS model 1. -----------------------------------------------
# DV = percent white, IV = fair housing imp, need to factor city and year for fixed effects
# Trounstine Table 2 Model 1
# Using lm() is way too much computation for the laptop to do
model_1 <- lm(pctnhwht_cityi ~ 
                fairhousingimp_v1+
                factor(incuplace98)+
                factor(year),
              data = table2_datayears)

# check against Table 2
summary(model_1) # get the coefficients
coef(model_1)["(Intercept)"] # derive the intercept constant

# this model using the fixest feols() function, and does it much faster
model_1_fe <- feols(
  pctnhwht_cityi ~ fairhousingimp_v1 |
    incuplace98 + year,
  data = table2_datayears
)

# check against Table 2
summary(model_1_fe) # get the coefficients
coef(model_1_fe)["(Intercept)"] # derive the intercept constant

# 5b Build the OLS model 2. -------------------------------------------------------
# Control variables of percent wealthy, percent renter log population, home value, and percent vacant
# Trounstine Table 2 Model 2
# Using lm() is way too much computation for the laptop to do
model_2 <- lm(
  pctnhwht_cityi ~
    fairhousingimp_v1 +
    pctrenter_cityi + # to calculate for housing, switch the sign on the coefficient
    pctwlth_city2i +
    logpop +
    homevali + # not transformed to 100000, multiply coefficient
    pct_vacanti +
    factor(incuplace98) +
    factor(year),
  data = table2_datayears
)
# check against Table 2
summary(model_2) # get the coefficients
coef(model_2)["(Intercept)"] # derive the intercept constant

# this model using the fixest feols() function, and does it much faster
model_2_fe <-feols(pctnhwht_cityi ~ fairhousingimp_v1  +
                     pctrenter_cityi +
                     pctwlth_city2i +
                     logpop +
                     homevali +
                     pct_vacanti |
                     incuplace98 + year,
                   data = table2_datayears
)

# check against Table 2
summary(model_2_fe) # get the coefficients
coef(model_2_fe)["(Intercept)"] # derive the intercept constant
