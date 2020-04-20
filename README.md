# Geography data

### Open Street Map

Open source data of everything that goes on map - Haven't yet figured out how to extract data beyond nodes and relations
Files downloaded are in XML or OSM

https://www.openstreetmap.org/export#map=15/40.4402/-79.9664

Need to use Overpass API to download a lot of data


### Microsoft Building Footprints

Building footprints of a lot of places. Not comprehensive I think
https://github.com/Microsoft/USBuildingFootprints


Check this cool NYTimes article for what it can do.
https://www.nytimes.com/interactive/2018/10/12/us/map-of-every-building-in-the-united-states.html

Files downloaded are in GeoJSON format

### Data that is actualy used
http://download.geofabrik.de/north-america/us/pennsylvania.html
https://www.r-spatial.org/r/2018/10/25/ggplot2-sf.html


#### Converting OSM to GeoJSON

https://pypi.org/project/osm2geojson/
Haven't tried it yet

### Other things that were found but of no use
https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.html
https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.html
https://freegisdata.rtwilson.com/
http://www.poi-factory.com/node/6348
https://libguides.mit.edu/gis/buildings
https://www.sciencebase.gov/catalog/item/5775469ce4b07dd077c7088a
https://uhcl.libguides.com/gis-data/GIS/data/us
https://towardsdatascience.com/loading-data-from-openstreetmap-with-python-and-the-overpass-api-513882a27fd0



# Notes from original Author for road colors erdavis1/RoadColors
# RoadColors

United States:
Plot roads in a US city, coloring each by its designation (e.g. Street, Road, Avenue)

Before you get started, you’ll need to get a few things prepared:

1. Find the lat/long point you’d like to be at the center of your map
2. Identify the GEOIDs of counties that are within 15 miles of this point. This site is very helpful: https://census.missouri.edu/geocodes/
3. Download roads shapefiles for the counties in step 2: 
ftp://ftp2.census.gov/geo/tiger/TIGER2018/ROADS/
4. Download feature names shapefiles for the counties in step 2: https://www2.census.gov/geo/tiger/TIGER2018/FEATNAMES/

This code isn't as well commented as Canada or Worldwide, so you might want to start with either of those first.

Canada:
Plot roads in a Canadian city, coloring each by its designation

Worldwide:
Plot roads in any worldwide city using OpenStreetMap data. It derives road designations from the road name. I only wrote this to work for countries that use English or Romance languages--it doesn't work for languages like German (which mashes the road designation into the road name with no spaces) or languages that don't use the Latin alphabet.
