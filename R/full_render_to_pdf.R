#' Convenience function to render a map and create a poster size PDF for printing
#'
#' @param map_data Map data, loaded via load_mapdata
#' @param name basic name used to generate filename & path
#' @param filename filename of the resulting PDF, generated from name
#' @param filepath full filepath of the resulting PDF, generated from filename
#' @param points_to_highlight opt. dataframe of points to highlight needs the columsn long and lat
#'
#' @return nothing
#' @export
#'
full_render_to_pdf <- function (map_data, name, filename = name, filepath = paste0("renders/", filename, ".pdf"), points_to_highlight = NULL) {
  # For the final print, some extra padding has to be added to the document (all in cm)
  print_extra_padding <- .3
  width <- 59.4
  height <- 84.1
  print_width <- width + print_extra_padding * 2
  print_height <- height + print_extra_padding * 2
  
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
      plot.margin = margin(
        t = 5 + print_extra_padding,
        r = 5 + print_extra_padding,
        b = 4 + print_extra_padding,
        l = 4.5 + print_extra_padding,
        unit = "cm"
      ),
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
    width = print_width,
    height = print_height,
    units = "cm",
    limitsize = F,
    device = "pdf",
    colormodel = "cmyk"
  )
  embedFonts(file = filepath)
}
