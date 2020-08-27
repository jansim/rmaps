load_mapdata <- function (data_id, water = T, buildings = F, roads = T) {

  output <- list(
    id = data_id
  )

  load(file = get_cache_path(data_id = data_id, type = "boundingbox"))
  output$bb = boundingbox

  if (water) {
    load(file = get_cache_path(data_id = data_id, type = "water"))
    output$water <- water_data
  }

  if (buildings) {
    load(file = get_cache_path(data_id = data_id, type = "buildings"))
    output$buildings <- buildings_data
  }

  if (roads) {
    load(file = get_cache_path(data_id = data_id, type = "roads"))
    output$roads <- roads_data
  }

  return(output)
}