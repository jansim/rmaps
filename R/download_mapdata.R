#' Download map data for a certain area, as indicated by a bounding box
#'
#' @param data_id string id to save the data under
#' @param boundingbox bounding box of the area to download
#' @param water download data of water bodies
#' @param buildings download data of buildings (can be large for cities) 
#' @param roads download road data
#' @param coast download coastline data (to render e.g. oceans)
#'
#' @return
#' @export
#'
download_mapdata <- function (data_id, boundingbox, water = T, buildings = F, roads = T, coast = T) {
  
  # Save bounding box as well
  save(boundingbox, file = get_cache_path(data_id = data_id, type = "boundingbox"))

  if (water) {
    natural_water_data <- boundingbox %>%
      opq() %>%
      add_osm_feature(key = "natural", value = "water") %>%
      osmdata_sf()
    riverbanks_water_data <- boundingbox %>%
      opq() %>%
      add_osm_feature(key = "waterway", value = "riverbank") %>%
      osmdata_sf()
    water_data <- c(natural_water_data, riverbanks_water_data)
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
  
  if (coast) {
    coast_data <- boundingbox %>%
      opq() %>%
      add_osm_feature(key = "natural", value = "coastline") %>%
      osmdata_sf() 
    save(coast_data, file = get_cache_path(data_id = data_id, type = "coast"))
  }
  
}