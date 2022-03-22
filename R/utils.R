
#' Access files in the current app
#'
#' @param ... Character vector specifying directory and or file to
#'     point to inside the current package.
#'
#' @noRd
app_sys <- function(...) {
  system.file(..., package = "cranology")
}


#' Function to debug problematic date vectors
#'
#' Problematic as won't be parsed properly and throw a warning.
#'
#' @param fishy_dates_chr, A character vector, encoding date in the ymd hm format.
#' @param reverse A logical, Should the date vector be reversed or not.
#' Useful if you have good reason to believe the issue is happening at the end.
#' @param n A numeric, sample size to evaluate,
#'
#' @importFrom purrr map safely transpose map_lgl
#' @noRd
detect_id_problematic_date_chr <- function(
  fishy_dates_chr,
  reverse = TRUE,
  n = 100
) {

  # Promote warning to errors
  options(warn = 2)
  on.exit(options(warn = 0))

  if (reverse) {
    dates_sample <- rev(fishy_dates_chr)[1:n]
  } else {
    dates_sample <- fishy_dates_chr[1:n]
  }

  result_raw <- map(dates_sample, safely(ymd_hm))
  result <- transpose(result_raw)
  id_error <- which(map_lgl(result$error, ~ !is.null(.x)))

  if (reverse) {
    id_error <- length(fishy_dates_chr) - rev_id_error + 1
  }

  return(id_error)
}
