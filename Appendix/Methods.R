### First, fit the full model.

cancer_lm_full = lm(data = reg_cancer_data,
                    `Age-Adjusted Death Rate` ~ 
                      `Recent 5-Year Trend (2) in Death Rates`*rising_death_rates +
                      `Recent 5-Year Trend (2) in Death Rates`*falling_death_rates +
                      `Recent 5-Year Trend (2) in Death Rates`*rising_incidence_rates +
                      `Recent 5-Year Trend (2) in Death Rates`*falling_incidence_rates +
                      `Age Adjusted Incidence Rate per 100,000`*rising_death_rates +
                      `Age Adjusted Incidence Rate per 100,000`*falling_death_rates +
                      `Age Adjusted Incidence Rate per 100,000`*rising_incidence_rates +
                      `Age Adjusted Incidence Rate per 100,000`*falling_incidence_rates +
                      `Recent 5-year trend in incidence rates`*rising_death_rates +
                      `Recent 5-year trend in incidence rates`*falling_death_rates +
                      `Recent 5-year trend in incidence rates`*rising_incidence_rates +
                      `Recent 5-year trend in incidence rates`*falling_incidence_rates)

summary(cancer_lm_full)

### Looking at the p-values of the slopes, it's clear that not all of these terms are significant, 
### particularly the interaction terms. 
### Because there are many, I next decided to test if any of them are significant by fitting a model without them and 
### using an ANOVA test to see if the models are significantly different.

cancer_lm2 = lm(data = reg_cancer_data, `Age-Adjusted Death Rate` ~ `Age Adjusted Incidence Rate per 100,000` +
                  `Recent 5-Year Trend (2) in Death Rates` + `Recent 5-year trend in incidence rates` + rising_death_rates +
                  falling_death_rates + rising_incidence_rates + falling_incidence_rates)

anova(cancer_lm_full, cancer_lm2)

### We get the p-value 0.0007741, which leads us to rejecting the null hypothesis 
### (that there is no difference). So we can't get rid of the interaction terms. 
### I decide to run a stepwise regression to obtain a better subset model.

stepwise_reg = step(cancer_lm_full, direction = "both")

### This is still a very complicated model. Trying out forward and backward selection and well gives very complicated models

### I decide to perform my own backward regression using p-values instead of AIC

summary(cancer_lm_full)
### Remove `Recent 5-Year Trend (2) in Death Rates`:falling_death_rates 

cancer_lm_step1 = lm(data = reg_cancer_data,
                     `Age-Adjusted Death Rate` ~ 
                       `Recent 5-Year Trend (2) in Death Rates`*rising_death_rates +
                       `Recent 5-Year Trend (2) in Death Rates`*rising_incidence_rates +
                       `Recent 5-Year Trend (2) in Death Rates`*falling_incidence_rates +
                       `Age Adjusted Incidence Rate per 100,000`*rising_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`*falling_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`*rising_incidence_rates +
                       `Age Adjusted Incidence Rate per 100,000`*falling_incidence_rates +
                       `Recent 5-year trend in incidence rates`*rising_death_rates +
                       `Recent 5-year trend in incidence rates`*falling_death_rates +
                       `Recent 5-year trend in incidence rates`*rising_incidence_rates +
                       `Recent 5-year trend in incidence rates`*falling_incidence_rates)
summary(cancer_lm_step1)
### Remove `Recent 5-Year Trend (2) in Death Rates`:rising_incidence_rates
cancer_lm_step2 = lm(data = reg_cancer_data,
                     `Age-Adjusted Death Rate` ~ 
                       `Recent 5-Year Trend (2) in Death Rates`*rising_death_rates +
                       `Recent 5-Year Trend (2) in Death Rates`*falling_incidence_rates +
                       `Age Adjusted Incidence Rate per 100,000`*rising_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`*falling_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`*rising_incidence_rates +
                       `Age Adjusted Incidence Rate per 100,000`*falling_incidence_rates +
                       `Recent 5-year trend in incidence rates`*rising_death_rates +
                       `Recent 5-year trend in incidence rates`*falling_death_rates +
                       `Recent 5-year trend in incidence rates`*rising_incidence_rates +
                       `Recent 5-year trend in incidence rates`*falling_incidence_rates)
summary(cancer_lm_step2)

### Remove falling_death_rates     
cancer_lm_step4 = lm(data = reg_cancer_data,
                     `Age-Adjusted Death Rate` ~ 
                       `Recent 5-Year Trend (2) in Death Rates`*rising_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`*rising_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`:falling_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`*rising_incidence_rates +
                       `Age Adjusted Incidence Rate per 100,000`*falling_incidence_rates +
                       `Recent 5-year trend in incidence rates`*rising_death_rates +
                       `Recent 5-year trend in incidence rates`:falling_death_rates +
                       `Recent 5-year trend in incidence rates`*rising_incidence_rates +
                       `Recent 5-year trend in incidence rates`*falling_incidence_rates)
summary(cancer_lm_step4)

### Remove rising_death_rates:`Recent 5-year trend in incidence rates`
cancer_lm_step5 = lm(data = reg_cancer_data,
                     `Age-Adjusted Death Rate` ~ 
                       `Recent 5-Year Trend (2) in Death Rates`*rising_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`*rising_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`:falling_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`*rising_incidence_rates +
                       `Age Adjusted Incidence Rate per 100,000`*falling_incidence_rates +
                       `Recent 5-year trend in incidence rates`:falling_death_rates +
                       `Recent 5-year trend in incidence rates`*rising_incidence_rates +
                       `Recent 5-year trend in incidence rates`*falling_incidence_rates)
summary(cancer_lm_step5)

### Remove rising_incidence_rates:`Recent 5-year trend in incidence rates``
cancer_lm_step6 = lm(data = reg_cancer_data,
                     `Age-Adjusted Death Rate` ~ 
                       `Recent 5-Year Trend (2) in Death Rates`*rising_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`*rising_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`:falling_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`*rising_incidence_rates +
                       `Age Adjusted Incidence Rate per 100,000`*falling_incidence_rates +
                       `Recent 5-year trend in incidence rates`:falling_death_rates +
                       `Recent 5-year trend in incidence rates`*falling_incidence_rates)
summary(cancer_lm_step6)
### Remove rising_death_rates:`Age Adjusted Incidence Rate per 100,000`
cancer_lm_step7 = lm(data = reg_cancer_data,
                     `Age-Adjusted Death Rate` ~ 
                       `Recent 5-Year Trend (2) in Death Rates`*rising_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`:falling_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`*rising_incidence_rates +
                       `Age Adjusted Incidence Rate per 100,000`*falling_incidence_rates +
                       `Recent 5-year trend in incidence rates`:falling_death_rates +
                       `Recent 5-year trend in incidence rates`*falling_incidence_rates)
summary(cancer_lm_step7)

### Remove `Age Adjusted Incidence Rate per 100,000`:falling_incidence_rates

cancer_lm_step8 = lm(data = reg_cancer_data,
                     `Age-Adjusted Death Rate` ~ 
                       `Recent 5-Year Trend (2) in Death Rates`*rising_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`:falling_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`*rising_incidence_rates +
                       `Recent 5-year trend in incidence rates`:falling_death_rates +
                       `Recent 5-year trend in incidence rates`*falling_incidence_rates)
summary(cancer_lm_step8)

### Remove falling_death_rates:`Recent 5-year trend in incidence rates`  
cancer_lm_step9 = lm(data = reg_cancer_data,
                     `Age-Adjusted Death Rate` ~ 
                       `Recent 5-Year Trend (2) in Death Rates`*rising_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`:falling_death_rates +
                       `Age Adjusted Incidence Rate per 100,000`*rising_incidence_rates +
                       `Recent 5-year trend in incidence rates`*falling_incidence_rates)
summary(cancer_lm_step9)

### Remove rising_incidence_rates                                     
cancer_lm_step10 = lm(data = reg_cancer_data,
                      `Age-Adjusted Death Rate` ~ 
                        `Recent 5-Year Trend (2) in Death Rates`*rising_death_rates +
                        `Age Adjusted Incidence Rate per 100,000`:falling_death_rates +
                        `Age Adjusted Incidence Rate per 100,000`:rising_incidence_rates +
                        `Age Adjusted Incidence Rate per 100,000` +
                        `Recent 5-year trend in incidence rates`*falling_incidence_rates)
summary(cancer_lm_step10)

### Remove `Age Adjusted Incidence Rate per 100,000`:rising_incidence_rates 

cancer_lm_step11 = lm(data = reg_cancer_data,
                      `Age-Adjusted Death Rate` ~ 
                        `Recent 5-Year Trend (2) in Death Rates`*rising_death_rates +
                        `Age Adjusted Incidence Rate per 100,000`:falling_death_rates +
                        `Age Adjusted Incidence Rate per 100,000` +
                        `Recent 5-year trend in incidence rates`*falling_incidence_rates)
summary(cancer_lm_step11)

## No regressor has a p-value less than alpha = 0.05, so I will stop elimination and the final model is:
#`Age-Adjusted Death Rate` ~ 
#`Recent 5-Year Trend (2) in Death Rates`*rising_death_rates +
#`Age Adjusted Incidence Rate per 100,000`:falling_death_rates +
#`Age Adjusted Incidence Rate per 100,000` +
#`Recent 5-year trend in incidence rates`*falling_incidence_rates

### Let's see how different it is from the original model. 
### The high p-value suggests that they are not significantly different. So, I will use this as my model.

anova(cancer_lm_full, cancer_lm_step11)
final_model = cancer_lm_step11

### Checking that we can use complete.cases to obtain the same graphs:

complete_reg_data = reg_cancer_data[complete.cases(reg_cancer_data), ]
test_lm = lm(data = complete_reg_data,
             `Age-Adjusted Death Rate` ~ 
               `Recent 5-Year Trend (2) in Death Rates`*rising_death_rates +
               `Age Adjusted Incidence Rate per 100,000`:falling_death_rates +
               `Age Adjusted Incidence Rate per 100,000` +
               `Recent 5-year trend in incidence rates`*falling_incidence_rates)

anova(final_model, test_lm)

### They are exactly the same, so plotting can be done with complete_reg_data.


  


