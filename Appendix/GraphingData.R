### I once again want to split my data into rising/falling/stable so that I can make some meaningful graphs

for(i in seq(1, nrow(complete_reg_data), by = 1)){
  if(complete_reg_data$rising_death_rates[[i]] == 1){
    complete_reg_data$'death trend'[[i]] = "rising"
    
  } else if(complete_reg_data$falling_death_rates[[i]] == 1){
    complete_reg_data$'death trend'[[i]] = "falling"
  } else{
    complete_reg_data$'death trend'[[i]] = "stable"
  }
  
  if(complete_reg_data$falling_incidence_rates[[i]] == 1){
    complete_reg_data$'incidence trend'[[i]] = "falling"
  } else{
    complete_reg_data$'incidence trend'[[i]] = "rising or stable"
  }
  
}

### Creating Lines for possible data

data_for_graphing = complete_reg_data

### change names so that I can use car package

colnames(data_for_graphing) = c("FIPS", "age_adj_death_rate", "five_year_trend_death_rates", "age_adj_incidence_rate", "five_year_trend_incidence_rates", "rising_death_rates", "falling_death_rates", "rising_incidence_rates", "falling_incidence_rates", "death_trend", "incidence_trend")

lm_for_graphing = lm(data = data_for_graphing, age_adj_death_rate ~ 
                       five_year_trend_death_rates*rising_death_rates +
                       age_adj_incidence_rate:falling_death_rates +
                       age_adj_incidence_rate +
                       five_year_trend_incidence_rates*falling_incidence_rates)

