
p_number = '09-REEPG.0009'
task_number = 20
email = 'sstoltzman@rclco.com'
metric = 'revenue'
region_id = 126793
bedrooms = 4
start_year = 2016


api_url = rclcoData::build_api_url(paste0('airdna/monthly_metrics?p_number=', 
                                          p_number,
                                          "&task_number=",
                                          task_number,
                                          "&email=",
                                          email,
                                          "&metric=",
                                          metric,
                                          "&region_id=",
                                          region_id,
                                          "&bedrooms=",
                                          bedrooms,
                                          '&start_year=',
                                          start_year))

airdna_df = jsonlite::fromJSON(api_url)
data = tibble::as_tibble(airdna_df$results)
