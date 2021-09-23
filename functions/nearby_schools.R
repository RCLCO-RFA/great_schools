nearby_schools <- function(lat = 40.4766772, lon = -106.8583795, radius = 5, limit = 10){
  
  library(tidyverse)
  library(httr)
  key <- "UL77gEnBSo166x5rDu9FG3Ao3MOBvOG879UqYQYq"
  url <- paste0('https://gs-api.greatschools.org/nearby-schools?lat=',lat,"&lon=",lon,"&limit=",limit,"&distance=",radius)
  
  resp <- httr::GET(url, httr::add_headers("X-API-Key " = key))
  result <- httr::content(resp, as = "parsed")
  
  schools <- result$schools
  
  #need to get NAs out of list
  null_NA <- function(x) {
    x[sapply(x, is.null)] <- NA
    return(x)
  }
  
  #replace null with na
  schools <- lapply(schools, null_NA)
  
  
  #loop through schools list to get df
  df <- NULL
  for(i in 1:length(schools)){
    data_raw <- enframe(unlist(schools[[i]]))
    data_tidy <- tidyr::pivot_wider(data_raw, names_from = name, values_from = value, values_fill = NA)
    df <- bind_rows(df, data_tidy)
    assign("df", df)                    
  }
  
  return(df)
}

school_test <- nearby_schools()
