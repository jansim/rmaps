#' Resize a bounding-box to have a certain aspect ratio
#'
#' @param bb the original bounding box
#' @param target_ar target aspect ratio
#'
#' @return a bounding box with the aspect ratio target_ar
#' @export
#'
set_bb_aspect_ratio <- function (bb, target_ar) {
  raw_w <- bb$xmax - bb$xmin
  raw_h <- bb$ymax - bb$ymin
  
  ar <- get_bb_aspect_ratio(bb)
  
  if (target_ar > ar) {
    # Reduce height => make "wider"
    ratio <- as.numeric(ar / target_ar)
    delta_h <- ((1 - ratio) * raw_h) / 2
    bb_new <- st_bbox(c(bb$xmin, bb$ymin + delta_h, bb$xmax, bb$ymax - delta_h))
  } else {
    # Reduce width => make "taller"
    ratio <- as.numeric(target_ar / ar)
    delta_w <- ((1 - ratio) * raw_w) / 2
    bb_new <- st_bbox(c(bb$xmin + delta_w, bb$ymin, bb$xmax - delta_w, bb$ymax))
  }
  
  bb_new
}
