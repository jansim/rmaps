full_render_to_pdf <- function (map_data, name, filename = name, filepath = paste0("renders/", filename, ".pdf"), points_to_highlight = NULL) {
  # Render the map
  map <- render_map(
    map_data,
    spacing = .075,
    crop = T,
    bounding_box = set_bb_aspect_ratio(map_data$bb, target_ar = 0.706433102 - .04),
    linesize = .8,
    textsize = 20
  ) +
    theme(
      plot.margin = margin(t = 5, r = 5, b = 4, l = 4.5, unit = "cm"),
      axis.text = element_text(size = 25, color = "#14213d"),
      plot.caption = element_text(size = 25, color = "#14213d", vjust = 25 / 2)
    ) +
    labs(
      caption = name
    )
  
  # Highlight points
  if (!is.null(points_to_highlight)) {
    map <- map +
      geom_point(
        data = points_to_highlight,
        aes(x = long, y = lat),
        color = "#d62828",
        shape = 18,
        size = 5
      ) +
      theme(axis.title.x = element_blank(), axis.title.y = element_blank())
  }
  
  # Save map as a PDF
  ggsave(
    filename = filepath,
    plot = map,
    width = 23.39,
    height = 33.11,
    units = "in",
    limitsize = F
  )
}
