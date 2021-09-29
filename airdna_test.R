# devtools::install_github('RCLCO-RFA/rclcoAnalytics')
# rclcoAnalytics::fetch_custom_shape('scottie_t')
library(tidyverse)
library(rclcoData)

search <- rclcoAnalytics::fetch_airdna_market_search(
  p_number = '09-REEPG.0009',
  task_number = 20,
  email = 'dschoewe@rclco.com',
  search_term = 'punta cana')

p_number = '09-REEPG.0009'
task_number = 20
email = 'dschoewe@rclco.com'
metric = 'revenue'
city_id = 88484
bedrooms = c(1,2,3,4)
start_year = 2018

#review function
?rclcoAnalytics::fetch_airdna_metrics

revenue_output <- NULL
for (i in bedrooms){
  test_revenue <- rclcoAnalytics::fetch_airdna_metrics(p_number = p_number,
                                                       task_number = task_number,
                                                       email = email,
                                                       metric = metric,
                                                       city_id = city_id,
                                                       bedrooms = i,
                                                       start_year = start_year) %>% 
    dplyr::mutate(bedrooms = i)
  revenue_output <- rbind(revenue_output, test_revenue)
  assign("revenue_output", revenue_output)
}



write.csv(revenue_output, "revenue_output_punta_ana.csv")





