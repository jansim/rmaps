pacman::p_load(shiny, leaflet, leaflet.extras, sf, osmdata)

draw_bounding_box <- function (start_place_name = NULL) {
  ui <- fluidPage(
    "Use the square button at the top-right to draw a rectangle bounding box, press 'Submit' to return the value.",
    leafletOutput("map"),
    HTML("<br><br>"),
    tableOutput("boundingBox"),
    tableOutput("info"),
    actionButton("submit", "Submit", icon("paper-plane"), class = "btn btn-primary")
  )
  
  server <- function(input, output, session) {
    bb <- NULL
    output$boundingBox <- NULL
    output$info <- NULL
    
    on_feature_change <- function (feat) {
      coords <- unlist(feat$geometry$coordinates)
      coords <- matrix(coords, ncol = 2, byrow = T)
      poly <- st_sf(st_sfc(st_polygon(list(coords))), crs = 4326)
      
      # Safe bounding box for returning
      bb <<- st_bbox(poly)
      
      # Safe as list for rendering in shiny
      bb_df <- as.data.frame(as.list(bb))
      output$boundingBox <- renderTable(bb_df)
      width <- bb_df$xmax - bb_df$xmin
      height <- bb_df$ymax - bb_df$ymin
      output$info <- renderTable(data.frame(
        aspectRatio = width / height,
        width = width,
        height = height
      ))
    }
    
    output$map <- renderLeaflet({
      m <- leaflet() %>%
        addTiles() %>%
        addDrawToolbar(
          position = "topright",
          singleFeature = T,
          editOptions = editToolbarOptions(remove = F),
          # Disable everything but rectangles
          polylineOptions = F,
          circleOptions = F,
          markerOptions = F,
          circleMarkerOptions = F,
          polygonOptions = F
        )
      
      if (!is.null(start_place_name)) {
        start_bounds <- getbb(start_place_name)
        if (start_bounds) {
          m <- m %>% fitBounds(start_bounds["x", "min"], start_bounds["y", "min"], start_bounds["x", "max"], start_bounds["y", "max"])
        } else {
          message(paste("Couldn't find place", start_place_name))
        }
      }
      
      return(m)
    })
  
    observeEvent(input$map_draw_new_feature, {
      feat <- input$map_draw_new_feature
      on_feature_change(feat)
    })
    
    observeEvent(input$map_draw_edited_features, {
      feat <- input$map_draw_edited_features$features[[1]]
      on_feature_change(feat)
    })
    
    # Stop app and return bounding box when clicking "Submit"
    observeEvent(input$submit, {
      stopApp(returnValue = bb)
    })
  }
  
  return(runApp(shinyApp(ui, server)))
}


