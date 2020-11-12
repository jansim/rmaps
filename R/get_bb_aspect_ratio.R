get_bb_aspect_ratio <- function (bb) {
  # Get width and height in actual units
  w <- st_sfc(st_point(c(bb$xmin, bb$ymin)), st_point(c(bb$xmax, bb$ymin)), crs = 4326) %>% st_distance() %>% .[1,2]
  h <- st_sfc(st_point(c(bb$xmin, bb$ymin)), st_point(c(bb$xmin, bb$ymax)), crs = 4326) %>% st_distance() %>% .[1,2]
  
  ar <- as.numeric(w / h)
  
  ar
}
