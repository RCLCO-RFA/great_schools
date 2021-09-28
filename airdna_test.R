p_number = '09-REEPG.0009'
task_number = 20
email = 'sstoltzman@rclco.com'
metric = 'adr'
city_id = 59380
bedrooms = 3
start_year = 2021


api_url = rclcoData::build_api_url(paste0('airdna/monthly_metrics?p_number=', 
                                          p_number,
                                          "&task_number=",
                                          task_number,
                                          "&email=",
                                          email,
                                          "&metric=",
                                          metric,
                                          "&city_id=",
                                          city_id,
                                          "&bedrooms=",
                                          bedrooms,
                                          '&start_year=',
                                          start_year))

airdna_df = jsonlite::fromJSON(api_url)
data = tibble::as_tibble(airdna_df$results)
