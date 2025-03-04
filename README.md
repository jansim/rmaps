
# 🗺️ rmaps: Minimal maps generated with R and ggplot

[![Mockup of rendered map on the
wall.](./example.jpg)](./README_files/example.pdf)

Collection of R functions to render minimal maps using `ggplot`.

# Getting Started

This project is not a R package and thus cannot be installed. To use
this project, clone the repository and run `renv::install()` to install
necessary packages / dependencies (if you do not have `rev` installed
yet, you might have to run `install.packages("renv")` first and restart
your R session). To quickly render a map, simply run the following
snippet of code with the working directory set to this repository.

    # This will load all included functions & packages
    source("load.R")

    # Download mapdata
    if (!file.exists(get_cache_path("amsterdam_example", type = "boundingbox"))) {
      # Example bounding box of central Amsterdam
      boundingbox <- st_bbox(c(xmin = 4.861836, ymin = 52.340088, xmax = 4.934535, ymax = 52.401469))
      
      # This will download the data and automatically write it into a cache file
      # so as to not overload the free OpenStreetMaps API. All the cached files
      # can be found in data/cache in the directory of this repository.
      download_mapdata(data_id = "amsterdam_example", boundingbox = boundingbox)
    }

    # Load the data from cache
    mapdata <- load_mapdata("amsterdam_example")

    # Render the final map (this function has options for recoloring etc.)
    render_map(mapdata)

![](README_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

## 🖨️ Print-ready PDFs

There is also a convenience function to render a full pdf ready for
printing in DIN A1 size. If you want to create your own poster it might
be a good start to just copy and adjust this function to your liking (or
just use it as is!).

    # Generate pdf for printing
    full_render_to_pdf(
      mapdata,
      name = "Amsterdam, Noord-Holland, Netherlands",
      filename = "example.pdf",
      dir = "README_files"
    )

The resulting PDF can be found [here](./README_files/example.pdf).
