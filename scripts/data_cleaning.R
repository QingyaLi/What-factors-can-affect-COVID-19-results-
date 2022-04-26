#### Preamble ####
# Purpose: Clean the survey data downloaded from Toronto Open Data Portal
# Author: Qingya Li
# Data: 25 April 2022
# Contact: Qingya.li@mail.utoronto.ca
# License: MIT


# Set up library

## use opendatatoronto to download dataset
library(opendatatoronto)

## use tidyverse and dplyr to clean dataset
library(tidyverse)
library(dplyr)

## use ggplot2, knitr and tidytext to perform visualizations
library(ggplot2)
library(knitr)
library(tidytext)

# Import dataset

## Import package from Toronto Open Data Portal 
package <- show_package("64b54586-6180-4485-83eb-81e8fae3b8fe")

## Import all the resources for the package
resources <- list_package_resources("64b54586-6180-4485-83eb-81e8fae3b8fe")

## Identify the data resources
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))

## Load the raw dataset
raw_df <- filter(datastore_resources, row_number()==1) %>% get_resource()


# Clean dataset

df <- raw_df %>%
  select(`Outbreak Associated`, `Age Group`, `Neighbourhood Name`, `Source of Infection`, Classification, `Client Gender`, Outcome, `Ever Hospitalized`, `Ever in ICU`, `Ever Intubated`) %>% 
  filter(Outcome != "ACTIVE") %>% 
  filter(`Client Gender` == "FEMALE" | `Client Gender` == "MALE") %>% 
  mutate(result = as.factor(ifelse(Outcome %in% c("RESOLVED"), 1,0))) %>% 
  rename(`outbreak associated` = `Outbreak Associated`,
         age = `Age Group`,
         neighbourhood = `Neighbourhood Name`,
         infection = `Source of Infection`,
         classification = Classification,
         gender =  `Client Gender`,
         outcome = Outcome,
         `ever hospitalized` = `Ever Hospitalized`,
         `ever in ICU` = `Ever in ICU`,
         `ever intubated` = `Ever Intubated`) 
write_csv(df, "df.csv")

         