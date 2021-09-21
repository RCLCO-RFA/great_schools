library(tidyverse)
library(tigris)
library(geojsonsf)
library(sf)
library(rgdal)


states <- c(state.abb, "DC")

school_dist <- NULL
for (i in states){
  school_int <- school_districts(i)
  school_dist <- rbind(school_dist, school_int)
  assign("school_dist", school_dist)
}

head(school_dist)
str(school_dist)

#export as sf
st_write(school_dist, "school_dist_sf.shp")

#as geojson, all together
st_write(school_dist, "school_dist_geo.geojson")
