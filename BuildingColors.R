#-----------initialize libraries. This needs to be done for each new R session
library(sf)
library(foreign)
library(tidyverse)
library(lwgeom)

options(stringsAsFactors = FALSE)

#-----------set some basic info about the city you're mapping
pt <- data.frame(lat = 40.445591, long = -79.962149)
city <- 'Pittsburgh'
geoid <-  c('42003')
rad <- 19140.2


featname <- read.dbf("OSM_Pennsylvania/gis_osm_buildings_a_free_1.dbf",  as.is = TRUE) # list of buildings
buildings <- read_sf("./OSM_Pennsylvania","gis_osm_buildings_a_free_1") # building shapes
pofw <- read_sf("./OSM_Pennsylvania", "gis_osm_pofw_a_free_1")
allbuildings <- rbind

#allbuildings <- inner_join(buildings, featname, by = "osm_id") 

## Subset the building in a circle ------------
pt <- pt %>% st_as_sf(coords = c("long", "lat"), crs = 4326) %>% st_transform(2163)
circle <- st_buffer(pt, dist = rad)
circle <- circle %>% st_transform(st_crs(allbuildings))
allbuildings <- st_intersection(circle, allbuildings)


blankbg <-theme(axis.line=element_blank(),axis.text.x=element_blank(),
                axis.text.y=element_blank(),axis.ticks=element_blank(),
                axis.title.x=element_blank(), axis.title.y=element_blank(),
                panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                panel.grid.minor=element_blank(),plot.background=element_blank())

ggplot() + blankbg + theme(panel.grid.major = element_line(colour = "transparent")) + 
  geom_sf(data=allbuildings, size = .25)

ggsave(paste0("./", city, "buildings.png"), plot = last_plot(),
       scale = 1, width = 24, height = 24, units = "in",
       dpi = 200)


