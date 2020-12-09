### Load packages, data

library(tidyverse)
library(dplyr)
library(MASS)
library(car)
library(faraway)

### Cancer data
mort = read_csv("./Appendix/Datasets/nrippner-cancer-linear-regression-model-tutorial/death .csv", 
                col_types = cols(
                  County = col_character(),
                  FIPS = col_double(),
                  `Met Objective of 45.5? (1)` = col_character(),
                  `Age-Adjusted Death Rate` = col_character(),
                  `Lower 95% Confidence Interval for Death Rate` = col_character(),
                  `Upper 95% Confidence Interval for Death Rate` = col_character(),
                  `Average Deaths per Year` = col_character(),
                  `Recent Trend (2)` = col_character(),
                  `Recent 5-Year Trend (2) in Death Rates` = col_character(),
                  `Lower 95% Confidence Interval for Trend` = col_character(),
                  `Upper 95% Confidence Interval for Trend` = col_character()
                ))

incd = read_csv("./Appendix/Datasets/nrippner-cancer-linear-regression-model-tutorial/incd.csv")

### incd has some strange symbols in the variable names of columns 3 and 8, so I will alter them
colnames(incd)[3] = "Age Adjusted Incidence Rate per 100,000"
colnames(incd)[8] = "Recent 5-year trend in incidence rates"

### I am also going to rename some of the common columns (specifically, recent trends), so that after joining the data, I can decipher what it represents
colnames(mort)[8] = "Recent Trend (death rates)"
colnames(mort)[10] = "Lower 95% Confidence Interval for Trend (death rates)" 
colnames(mort)[11] = "Upper 95% Confidence Interval for Trend (death rates)"

colnames(incd)[4] = "Lower 95% Confidence Interval (incidence rates)"
colnames(incd)[5] = "Upper 95% Confidence Interval (incidence rates)"
colnames(incd)[6] = "Average Annual Count (incidence)"
colnames(incd)[7] = "Recent Trend (incidence rates)"
colnames(incd)[9] = "Lower 95% Confidence Interval for Trend (incidence rates)" 
colnames(incd)[10] = "Upper 95% Confidence Interval for Trend (incidence rates)"

### Then, join by FIPS.

full_cancer_data = left_join(mort, incd, by = "FIPS")

### First, clean up Age-Adjusted Death Rates. This is going to be the variable I perform the regression on. First, there are '*' contained as values. As per the documentation contained in cancer_data_notes.csv, this represents, data is being withheld for reasons of confidentiality. Looking at the data, this appears to occur in a variety of states. I decided to remove these because we aren't looking to answer the question of which places have different confidentiality agreements and I know I want to use this variable.

full_cancer_data = full_cancer_data[!(full_cancer_data$`Age-Adjusted Death Rate` == "*"),]
### Since this looks good now, I am going to parse as a number
full_cancer_data$`Age-Adjusted Death Rate` = parse_number(full_cancer_data$`Age-Adjusted Death Rate`)

### The confidence interval variables for the death rate, as well as the average deaths per year also look good now, so I will convert them to numeric as well.
full_cancer_data$`Lower 95% Confidence Interval for Death Rate` = parse_number(full_cancer_data$`Lower 95% Confidence Interval for Death Rate`)
full_cancer_data$`Upper 95% Confidence Interval for Death Rate` = parse_number(full_cancer_data$`Upper 95% Confidence Interval for Death Rate`)
full_cancer_data$`Average Deaths per Year` = parse_number(full_cancer_data$`Average Deaths per Year`)

### Now, for the variables related to the death rate trends, we have values of '**'. In the documentation, this is described as the data being too sparse to estimate the trends. For now, I will set these values to NA, but will leave the observations in the data, since I am not yet sure how I am going to be using these variables.

full_cancer_data$`Recent 5-Year Trend (2) in Death Rates` = as.numeric(full_cancer_data$`Recent 5-Year Trend (2) in Death Rates`)
full_cancer_data$`Lower 95% Confidence Interval for Trend (death rates)` = as.numeric(full_cancer_data$`Lower 95% Confidence Interval for Trend (death rates)`)
full_cancer_data$`Upper 95% Confidence Interval for Trend (death rates)` = as.numeric(full_cancer_data$`Upper 95% Confidence Interval for Trend (death rates)`)

### Cleaning up Age Adjusted Incidence Rate: we have '*', '_' and '__' as values. '*' are once again present due to confidentiality, but also occur if the counts are too low (fewer that 16 reported cases). We can see that in the corresponding value for Average annual count (incidence), which is "3 or lower". I've decided to set these to NA for now as well because I have no reasonable estimate as to what the true values could be. 

### For values '_', we have and '__', they have to do with state legistlation. Once again, we'll set these to NA. For values that contain hashtags, this is about not including cases diagnosed in other states. For now, I'll store which observations have this, and test if its significant later.

hashtag_data = grepl( "#", full_cancer_data$`Age Adjusted Incidence Rate per 100,000`, fixed = TRUE)
hashtag_FIPS = list()

for(i in seq(1, length(hashtag_data), by = 1)){
  if(hashtag_data[[i]] == TRUE){
    hashtag_FIPS = append(hashtag_FIPS, full_cancer_data$FIPS[[i]])
  }
}

### then, parse these as a number.

full_cancer_data$`Age Adjusted Incidence Rate per 100,000` = parse_number(full_cancer_data$`Age Adjusted Incidence Rate per 100,000`)
full_cancer_data$`Lower 95% Confidence Interval (incidence rates)` = parse_number(full_cancer_data$`Lower 95% Confidence Interval (incidence rates)`)
full_cancer_data$`Upper 95% Confidence Interval (incidence rates)` = parse_number(full_cancer_data$`Upper 95% Confidence Interval (incidence rates)`)
full_cancer_data$`Average Annual Count (incidence)` = parse_number(full_cancer_data$`Average Annual Count (incidence)`)
full_cancer_data$`Recent 5-year trend in incidence rates` = parse_number(full_cancer_data$`Recent 5-year trend in incidence rates`)
full_cancer_data$`Lower 95% Confidence Interval for Trend (incidence rates)` = parse_number(full_cancer_data$`Lower 95% Confidence Interval for Trend (incidence rates)`)
full_cancer_data$`Upper 95% Confidence Interval for Trend (incidence rates)` = parse_number(full_cancer_data$`Upper 95% Confidence Interval for Trend (incidence rates)`)

### Lastly, remove "**" from both death and Incident Recent Trends
for(i in seq(1, nrow(full_cancer_data), by = 1)){
  if(full_cancer_data$`Recent Trend (death rates)`[[i]] == "**"){
    full_cancer_data$`Recent Trend (death rates)`[[i]] = NA
  }
  if(full_cancer_data$`Recent Trend (incidence rates)`[[i]] == "**" | full_cancer_data$`Recent Trend (incidence rates)`[[i]] == "*" 
     |full_cancer_data$`Recent Trend (incidence rates)`[[i]] == "_" | full_cancer_data$`Recent Trend (incidence rates)`[[i]] == "	__"){
    full_cancer_data$`Recent Trend (incidence rates)`[[i]] = NA
  }
}
