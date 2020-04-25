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


#featname <- read.dbf("OSM_Pennsylvania/gis_osm_buildings_a_free_1.dbf",  as.is = TRUE) # list of buildings
buildings <- read_sf("./OSM_Pennsylvania","gis_osm_buildings_a_free_1") # building shapes
buildings$fclass <- buildings$type
buildings$type <- NULL


## Subset the building in a circle ------------
pt <- pt %>% st_as_sf(coords = c("long", "lat"), crs = 4326) %>% st_transform(2163)
circle <- st_buffer(pt, dist = rad)
circle <- circle %>% st_transform(st_crs(buildings))
buildings <- st_intersection(circle, buildings)

abuild <- buildings

nfile <- read_sf("./OSM_Pennsylvania", "gis_osm_pofw_a_free_1")
nfile$fclass <- "Religion"
circle <- st_buffer(pt, dist = rad)
circle <- circle %>% st_transform(st_crs(nfile))
nfile <- st_intersection(circle, nfile)
abuild <- rbind(abuild, nfile[!(nfile$osm_id %in% buildings$osm_id),])

nfile <- read_sf("./OSM_Pennsylvania", "gis_osm_pois_a_free_1")
circle <- st_buffer(pt, dist = rad)
circle <- circle %>% st_transform(st_crs(nfile))
nfile <- st_intersection(circle, nfile)
abuild <- rbind(abuild, nfile[!(nfile$osm_id %in% buildings$osm_id),])

nfile <- read_sf("./OSM_Pennsylvania", "gis_osm_pois_free_1")
circle <- st_buffer(pt, dist = rad)
circle <- circle %>% st_transform(st_crs(nfile))
nfile <- st_intersection(circle, nfile)
abuild <- rbind(abuild, nfile[!(nfile$osm_id %in% buildings$osm_id),])

# Grouping ---------------
abuild$type <- NA
edu <- c("university", "school","college")
religion <- c("church", "cathedral","synagogue","chapel")
resi <- c("house","apartments","residential")
shopping <- c("retail","store","clothes","mall","gift_shop","video_shop",
              "jeweller","florist","butcher","stationery","convenience","shop","store",
              "grocer","market")
food <- c("food_court","bar","pub","fast_food","restaurant","bakery","nightclub","cafe")
ent <- c("movies","cinema","sports","ice_rink","play","swimming_pool",
         "museum","monument","theatre","community","park","post","zoo","golf_course",
         "town_hall","government")
transportation <- c("transportation","train_station","centre","picnic","police","fire")
medicine <- c("hospital","pharmacy","dentist","clinic","optician","doctor","vetrinary",
              "chemist")
commercial <- c("office","commercial","car")
stay <- c("hotel","motel","hostel","nursing_home","dormitory")
abuild$type[which(grepl(paste(edu, collapse = "|"), abuild$fclass))] <- "Education"
abuild$type[which(grepl(paste(religion, collapse = "|"), abuild$fclass))] <- "Religion"
abuild$type[which(grepl(paste(resi, collapse = "|"), abuild$fclass))] <- "Residential"
abuild$type[which(grepl(paste(shopping, collapse = "|"), abuild$fclass))] <- "Shopping"
abuild$type[which(grepl(paste(food, collapse = "|"), abuild$fclass))] <- "Restaurant"
abuild$type[which(grepl(paste(ent, collapse = "|"), abuild$fclass))] <- "Community"
abuild$type[which(grepl(paste(transportation, collapse = "|"), abuild$fclass))] <- "Transportation"
abuild$type[which(grepl(paste(stay, collapse = "|"), abuild$fclass))] <- "Stay"
abuild$type[which(grepl(paste(medicine, collapse = "|"), abuild$fclass))] <- "Medicine"


abuild$fclass[which(grepl(paste(commercial, collapse = "|"), abuild$fclass))] <- "Commercial"


sbuild <- abuild[!is.na(abuild$type),]
blankbg <-theme(axis.line=element_blank(),axis.text.x=element_blank(),
                axis.text.y=element_blank(),axis.ticks=element_blank(),
                axis.title.x=element_blank(), axis.title.y=element_blank(),
                panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                panel.grid.minor=element_blank(),plot.background=element_blank())

ggplot() + blankbg + theme(panel.grid.major = element_line(colour = "transparent")) + 
  geom_sf(data=sbuild, size = .25, aes(fill=type))

ggsave(paste0("./", city, "buildings.png"), plot = last_plot(),
       scale = 1, width = 24, height = 24, units = "in",
       dpi = 500)


