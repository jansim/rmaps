get_cache_path <- function (data_id, type, data_dir = "data/cache") {
  # Create directory if it doesn't exist (if it does this would just throw a warning so ¯\_(ツ)_/¯)
  # I guess there would be better places to do this, but this should suffice for now..
  dir.create(data_dir, recursive = T, showWarnings = FALSE)
  
  file.path(data_dir, paste0(data_id, "_", type,".Rdata"))
}