
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

#' Update dataset documentation
#'
#' Update time stamp and dataset dimension every time a new version
#' of the data is scraped.
#'
#' @param dataset_name A character string. One of
#' c("cran_packages_history", "cran_monthly_package_number").
#'
#' @return Nothing used for its side effect of updating documentation.
#'
#' @importFrom lubridate today
#' @importFrom cli cat_rule
#'
#' @noRd
update_dataset_doc <- function(dataset_name = "cran_packages_history") {
  if (!requireNamespace("roxygen2")) {
    stop("Please install the {roxygen2} package to add the recommended tests.")
  }

  path_doc <- paste0("R/doc_", dataset_name, ".R")
  data_doc <- readLines(path_doc)

  path_dataset <- paste0("data/", dataset_name, ".rda")
  dataset <- get(load(path_dataset))

  cat_rule("Updating time stamp")
  data_doc <- sub(
    pattern = "^#' Last update: \\d{4}-\\d{2}-\\d{2}\\.$",
    replacement = sprintf(
      "#' Last update: %s.",
      today()
    ),
    x = data_doc
  )

  cat_rule("Updating dimension")
  data_doc <- gsub(
    pattern = "#' @format A data frame with \\d+ rows and \\d variables:",
    replacement = sprintf(
      "#' @format A data frame with %s rows and %s variables:",
      nrow(dataset),
      ncol(dataset)
    ),
    x = data_doc
  )

  writeLines(
    text = data_doc,
    con = path_doc
  )
  cat_rule("Regenerate documentation")
  roxygen2::roxygenise()
}
