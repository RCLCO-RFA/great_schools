library(httr)
library(tidyverse)
#https://docs.google.com/document/d/1pSe1AeZXGL01m5uG3wwRr9k4pI2Qw52xzPi2NmNrhyI/edit#
#https://docs.rstudio.com/connect/user/api-keys/

test <- "https://gs-api.greatschools.org/usage?api_key=UL77gEnBSo166x5rDu9FG3Ao3MOBvOG879UqYQYq"
httr::GET(test)

key <- "UL77gEnBSo166x5rDu9FG3Ao3MOBvOG879UqYQYq"
url <- 'https://gs-api.greatschools.org/nearby-schools?lat=37.7940627&lon=-122.2680029&limit=3&distance=5'



resp <- httr::GET(url, add_headers("X-API-Key " = key))

result <- httr::content(resp, as = "parsed")

test <- result$schools

null_NA <- function(x) {
  x[sapply(x, is.null)] <- NA
  return(x)
}

test <- lapply(test, null_NA)

data_raw <- enframe(unlist(test))

data_tidy <- tidyr::pivot_wider(data_raw, names_from = name, values_from = value, values_fill = NA)

data_spread <- data_raw %>%
  tidyr::spread(name)
  


#check out stuff in table
school_data <- NULL
for (i in 1:length(test_school)){
  int <- as.data.frame(test_school[i])
  school_data <- bind_cols(school_data, int)
  assign("school_data", school_data)
}

names(school_data)
id[1,1]

subratings <- paste0('https://gs-api.greatschools.org/schools/',id[1,1],'/subratings')
detail <- httr::GET(subratings, add_headers("X-API-Key " = key))
detail <- httr::content(detail, as = "raw")

