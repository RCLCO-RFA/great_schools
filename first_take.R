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

test_school <- test[[2]]

id <- as.data.frame(test_school[1])

id2 <- as.data.frame(test_school[2])

df <- bind_cols(id, id2)
