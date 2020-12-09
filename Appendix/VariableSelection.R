## I am going to produce my indicator variables for Recent Trend (death rates) and Recent Trend (incidence rates).

falling_death_rates = list() ### 1 if Recent Trend (death rates) is falling, 0 otherwise
rising_death_rates = list() ### 1 if Recent Trend (death rates) is rising, 0 otherwise
### if both falling and rising death rates are 0, Recent Trend (death rates) is stable

falling_incidence_rates = list() ### 1 if Recent Trend (incidence rates) is falling, 0 otherwise
rising_incidence_rates = list() ### 1 if Recent Trend (incidence rates) rising, 0 otherwise
### if both falling and rising incidence rates are 0, Recent Trend (incidence rates) is stable

for(i in seq(1, nrow(full_cancer_data), by = 1)){
  
  ### first, deal with NAs
  if(is.na(full_cancer_data$`Recent Trend (death rates)`[[i]])){
    rising_death_rates = append(rising_death_rates, NA)
    falling_death_rates = append(falling_death_rates, NA)
  } else if(full_cancer_data$`Recent Trend (death rates)`[[i]] == "rising"){
    rising_death_rates = append(rising_death_rates, 1)
    falling_death_rates = append(falling_death_rates, 0)
  } else if(full_cancer_data$`Recent Trend (death rates)`[[i]] == "falling"){
    rising_death_rates = append(rising_death_rates, 0)
    falling_death_rates = append(falling_death_rates, 1)
  } else{
    rising_death_rates = append(rising_death_rates, 0)
    falling_death_rates = append(falling_death_rates, 0)
  }
  
  if(is.na(full_cancer_data$`Recent Trend (incidence rates)`[i])){
    rising_incidence_rates = append(rising_incidence_rates, NA)
    falling_incidence_rates = append(falling_incidence_rates, NA)
  } else if(full_cancer_data$`Recent Trend (incidence rates)`[i] == "rising"){
    rising_incidence_rates = append(rising_incidence_rates, 1)
    falling_incidence_rates = append(falling_incidence_rates, 0)
  } else if(full_cancer_data$`Recent Trend (incidence rates)`[i] == "falling"){
    rising_incidence_rates = append(rising_incidence_rates, 0)
    falling_incidence_rates = append(falling_incidence_rates, 1)
  } else{
    rising_incidence_rates = append(rising_incidence_rates, 0)
    falling_incidence_rates = append(falling_incidence_rates, 0)
  }
  
}

i_cancer_data = do.call(rbind.data.frame, Map('c', rising_death_rates, falling_death_rates, rising_incidence_rates, falling_incidence_rates))
names(i_cancer_data) = c("rising_death_rates", "falling_death_rates", "rising_incidence_rates", "falling_incidence_rates")

full_cancer_data = cbind(full_cancer_data, i_cancer_data)

## full pairs plot

pairs(full_cancer_data[, c("Age-Adjusted Death Rate", "Lower 95% Confidence Interval for Death Rate", 
                           "Upper 95% Confidence Interval for Death Rate", "Recent 5-Year Trend (2) in Death Rates", 
                           "Lower 95% Confidence Interval for Trend (death rates)", 
                           "Upper 95% Confidence Interval for Trend (death rates)", 
                           "Age Adjusted Incidence Rate per 100,000" , 
                           "Lower 95% Confidence Interval (incidence rates)", 
                           "Upper 95% Confidence Interval (incidence rates)", 
                           "Recent 5-year trend in incidence rates", 
                           "Lower 95% Confidence Interval for Trend (incidence rates)", 
                           "Upper 95% Confidence Interval for Trend (incidence rates)")], col = "dark blue")
title("Full Pairs Plot")

## Remove County.x, County.y, Met Objective of 45.5? (1), Recent Trend (death rates), 
## Recent Trend (incidence rates), Average Deaths per Year, and Average Annual Count (incidence)

reg_cancer_data = full_cancer_data[, !names(full_cancer_data) %in% c(
  "County.x", "County.y", "Met Objective of 45.5? (1)", 
  "Recent Trend (death rates)", "Recent Trend (incidence rates)", "Average Deaths per Year", 
  "Average Annual Count (incidence)", "Lower 95% Confidence Interval for Death Rate", 
  "Upper 95% Confidence Interval for Death Rate", "Lower 95% Confidence Interval (incidence rates)", 
  "Upper 95% Confidence Interval (incidence rates)", "Lower 95% Confidence Interval for Trend (incidence rates)", 
  "Upper 95% Confidence Interval for Trend (incidence rates)", "Lower 95% Confidence Interval for Trend (death rates)",
  "Upper 95% Confidence Interval for Trend (death rates)")]

## Obtaining Test - make sure no NA!!!!!

set.seed(555)
test = list(length = ncol(reg_cancer_data))
test[[1]] = "Test"

for(i in seq(2, ncol(reg_cancer_data), by = 1)){
  test[[i]] = sample(na.omit(reg_cancer_data[,i]), 1)
}

names(test) = names(reg_cancer_data)
reg_cancer_data = rbind(reg_cancer_data, test)