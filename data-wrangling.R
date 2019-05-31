library(dplyr)
library(stringr)

causes <- read.csv("data/NCHS_Leading_Causes_of_Death_United_States.csv", sep = ",", stringsAsFactors = FALSE)

crude <-  causes %>%
  select(Year, X113.Cause.Name, Cause.Name, State, Deaths) %>%

age_adjusted <-  causes %>%
  select(Year, X113.Cause.Name, Cause.Name, State, Age.adjusted.Death.Rate)