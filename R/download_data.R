download_mapdata <- function (data_id, boundingbox, water = T, buildings = F, roads = T) {
  
  # Save bounding box as well
  save(boundingbox, file = get_cache_path(data_id = data_id, type = "boundingbox"))

  if (water) {
    water_data <- boundingbox %>%
      opq() %>%
      add_osm_feature(key = "natural", value = "water") %>%
      osmdata_sf() 
    save(water_data, file = get_cache_path(data_id = data_id, type = "water"))
  }
  
  if (buildings) {
    buildings_data <- boundingbox %>% 
      opq() %>% 
      add_osm_feature(key = "building") %>% 
      osmdata_sf() 
    save(buildings_data, file = get_cache_path(data_id = data_id, type = "buildings"))
  }
  
  if (roads) {
    roads_data <- boundingbox %>%
      opq() %>%
      add_osm_feature(key = "highway") %>%
      osmdata_sf()
    save(roads_data, file = get_cache_path(data_id = data_id, type = "roads"))
  }
  
}