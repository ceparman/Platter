# source all file in a directory


sourceDir <- function(path, trace = FALSE, ...) {
  for (nm in list.files(path, pattern = "\\.[RrSsQq]$")) {
    if (trace) {
      cat(nm, ":")
    }
    source(file.path(path, nm), ...)
    if (trace) {
      cat("\n")
    }
  }
}
