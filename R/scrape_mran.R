
#' @importFrom lubridate ymd
#' @noRd
is_parsable_date <- function(date) {
  parsed_date <- ymd(date, quiet = TRUE)
  if ( is.na(parsed_date) ) {
    FALSE
  } else {
    TRUE
  }
}

date_error_message <- function() {
  paste0(
    "`dates` must be either:\n",
    "- a Date -> as.Date(Sys.time())\n",
    "- a character string of the form 'year-month-day': -> '2018-04-10'\n"
  )
}

#' @importFrom lubridate is.Date
#' @noRd
is_valid_date <- function(date) {
  invalid_date <- !is.Date(date) & is.character(date) & !is_parsable_date(date)
  if ( invalid_date ) {
    stop(
      date_error_message(),
      call. = FALSE
    )
  }
}

#' @importFrom purrr map safely transpose pluck map_lgl
#' @noRd
is_valid_dates <- function(dates) {

  id_problematic_dates <- dates %>%
    map(safely(is_valid_date)) %>%
    transpose() %>%
    pluck("error")  %>%
    map_lgl(~ !is.null(.x)) %>%
    which()

  if ( length(id_problematic_dates) > 0 ) {
    stop(
      "Some dates are not valid dates:\n",
      paste(
        paste0(id_problematic_dates, ": ", dates[id_problematic_dates]),
        collapse = "\n"
      ),
      "\n",
      date_error_message(),
      call. = FALSE
    )
  }

}

#' @importFrom utils available.packages
#' @noRd
.get_package_number_mran <- function(date) {
  tryCatch(
    error = function(cnd) {
      message(
        sprintf(
          "Impossible to query MRAN for this particualar date: %s",
          date
        )
      )
      data.frame(
        date = date,
        n = NA
      )
    },
    data.frame(
      date = date,
      n = nrow(
        available.packages(
          repos = sprintf("https://mran.microsoft.com/snapshot/%s", date)
        )
      )
    )
  )
}



#' Get number of package on CRAN on a given date using MRAN
#'
#' This function queries MRAN to retrieve the number of package on CRAN
#' on a given date.
#'
#' @param dates A vector of dates. Either a character vector of the form "yyyy-mm-dd"
#' or a vector of class "Date".
#'
#' @return A data.frame with two volumns `date` and `n` the number of packages on CRAN
#' at that given `date`.
#'
#' @importFrom furrr future_map_dfr
#' @export
#'
#' @examples
#' get_package_number_mran(c("2018-04-10", "2020-03-19"))

get_package_number_mran <- function(dates) {
  is_valid_dates(dates)
  message("Scraping MRAN...")
  future_map_dfr(
    dates,
    .get_package_number_mran
  )
}
