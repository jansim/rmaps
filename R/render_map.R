render_map <- function (
  data,
  background = "#FFFFFF",
  text = "#000000",
  grid = "#FFFFFF",
  water = "#0000FF",
  roads = "#000000",
  buildings = "#FF0000",
  spacing = F,
  crop = F,
  bounding_box = NULL,
  linesize = .5,
  textsize = 10
) {
  
  my_theme <- theme(
    plot.background = element_rect(fill = background),
    panel.background = element_rect(fill = background),
    text = element_text(color = text, size = textsize),
    axis.text = element_text(color = text, size = textsize),
    axis.line = element_line(color = text, size = linesize),
    
    panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = grid),
    panel.grid.minor = element_line(size = 0.25, linetype = 'solid', colour = grid)
    
    # panel.grid.major = element_blank(),
    # panel.grid.minor = element_blank()
  )
  
  if (is.null(bounding_box)) {
    bb <- data$bb  
  } else {
    bb <- bounding_box
  }
  
  limits <- list(
    x = c(bb$xmin, bb$xmax),
    y = c(bb$ymin, bb$ymax)
  )
  # This only looks good with propper cropping
  if (spacing) {
    limits$x[1] <- limits$x[1] - (diff(limits$x) * spacing)
    limits$y[1] <- limits$y[1] - (diff(limits$y) * spacing)
  }
  
  roads_data <- data$roads$osm_lines
  water_data <- bind_rows(
    data$water$osm_polygons,
    data$water$osm_multipolygons
  )
  
  if (crop) {
    roads_data <- st_crop(roads_data, bb %>% st_as_sfc %>% st_set_crs(4326))
    water_data <- st_crop(water_data %>% st_make_valid(), bb %>% st_as_sfc %>% st_set_crs(4326))
  }
  
  ggplot(roads_data) +
    theme_classic() +
    theme(axis.text.y = element_text(angle = -90, hjust = .5)) +
    geom_sf(data = water_data, inherit.aes = F, fill = water, color = water) +
    geom_sf(data = roads_data, color = roads, size = linesize) +
    coord_sf(xlim = limits$x, ylim = limits$y, expand = F) +
    
    my_theme

    # TODO: opt. highlight point
    # geom_point(aes(x = 4.9, y = 52.37), color = "#d62828", shape = 18) +
    # theme(axis.title.x=element_blank(), axis.title.y=element_blank())
}