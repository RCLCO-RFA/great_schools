convert_to_polygon_string = function(geom_object){
  # geom_object = observed_data$features[[1]]$geometry
  longitude = c()
  latitude = c()
  for(i in geom_object){
    for(j in i[[1]]){
      for(k in j){
        tmp = unlist(j)
        longitude = c(longitude, tmp[1])
        latitude = c(latitude, tmp[2])
      }
    }
  }
  longitude = as.numeric(longitude[2:length(longitude)])
  latitude = as.numeric(latitude[2:length(latitude)])
  poly_string = "POLYGON (("
  for(i in 1:length(longitude)){
    poly_string = paste0(poly_string, longitude[i], ' ', latitude[i], ', ')
  }
  poly_string = gsub('.{2}$', '))', poly_string)
  return(poly_string)
}