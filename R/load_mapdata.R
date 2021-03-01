#' Load mapdata from the cache
#'
#' @param data_id id the map data is saved under
#' @param water Should water data be loaded (NULL = load if file exists)
#' @param buildings Should buildings data be loaded (NULL = load if file exists)
#' @param roads Should road data be loaded (NULL = load if file exists)
#' @param coast Should coastline data be loaded (NULL = load if file exists)
#'
#' @return loaded map data
#' @export
#'
load_mapdata <- function (data_id, water = NULL, buildings = NULL, roads = NULL, coast = NULL) {

  output <- list(
    id = data_id
  )

  load(file = get_cache_path(data_id = data_id, type = "boundingbox"))
  output$bb = boundingbox
  
  types <- c(
    "water",
    "buildings",
    "roads",
    "coast"
  )
  
  # Load different types of spatial data
  for (type in types) {
    cache_path <- get_cache_path(data_id = data_id, type = type)
    # If not explicitly provided, default to load all data if its cache file exists
    do_load <- if (is.null(get(type))) { file.exists(cache_path) } else { get(type) }
    if (do_load) {
      load(file = cache_path)
      output[[type]] <- get(paste0(type, "_data")) 
    } 
  }

  return(output)
}