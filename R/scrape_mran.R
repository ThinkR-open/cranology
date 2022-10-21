
#' @importFrom lubridate ymd
#' @noRd
is_parsable_date <- function(date) {
  parsed_date <- ymd(date, quiet = TRUE)
  if (is.na(parsed_date)) {
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
is_invalid_date <- function(date) {
  !is.Date(date) & is.character(date) & !is_parsable_date(date)
}

#' @noRd
is_invalid_dates <- function(dates) {
  vapply(
    X = dates,
    FUN = is_invalid_date,
    FUN.VALUE = logical(1),
    USE.NAMES = FALSE
  )
}

is_anterior_to_mran_launch <- function(valid_date) {
  as.Date("2014-09-17") > valid_date
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
    {
      message(
        sprintf("Scraping number packages on: %s", date)
      )
      data.frame(
        date = date,
        number_packages = nrow(
          available.packages(
            repos = sprintf("https://mran.microsoft.com/snapshot/%s", date)
          )
        )
      )
    }
  )
}



#' Get number of package on CRAN on a given date using MRAN
#'
#' This function queries MRAN to retrieve the number of package on CRAN
#' on a given date.
#'
#' @param dates A vector of dates. Either a character vector of the form "yyyy-mm-dd"
#' or a vector of class "Date". All dates must be posterior to "2014-09-17", the
#' day of MRAN first CRAN snapshot.
#'
#' @param parallelize A logical. If TRUE {furrr} is used to asynchronously scrap
#' mran.
#'
#' @return A data.frame with two columns `date` and `n` the number of packages on CRAN
#' at that given `date`.
#'
#' @importFrom purrr map_dfr
#' @importFrom furrr future_map_dfr
#'
#' @export
#'
#' @name mran
#'
#' @examples
#' get_package_number_mran(c("2018-04-10", "2020-03-19"))
#'
get_package_number_mran <- function(dates, parallelize = FALSE) {
  invalid_dates <- is_invalid_dates(dates)
  if (any(invalid_dates)) {
    stop(
      "Some dates are not valid dates:\n",
      paste(
        paste0(which(invalid_dates), ": ", dates[invalid_dates]),
        collapse = "\n"
      ),
      "\n",
      date_error_message(),
      call. = FALSE
    )
  }

  anterior_to_mran_launch <- is_anterior_to_mran_launch(dates)
  if (any(anterior_to_mran_launch)) {
    stop(
      "Some dates are anterior to MRAN launch:\n",
      paste(
        paste0(which(anterior_to_mran_launch), ": ", dates[anterior_to_mran_launch]),
        collapse = "\n"
      ),
      call. = FALSE
    )
  }

  message("Scraping MRAN...")

  if (isTRUE(parallelize)) {
    future_map_dfr(
      dates,
      .get_package_number_mran
    )
  } else {
    map_dfr(
      dates,
      .get_package_number_mran
    )
  }
}

#' Update `cran_monthly_package_number` dataset
#'
#' The creation `cran_monthly_package_number` using `scrape_cran()` is
#' a long process as the underlying scrapping operations are time consuming.
#' To more rapidly update `cran_monthly_package_number` it is easier to rely
#' on data from MRAN. This what this function does. It uses
#' #' `get_package_number_mran()` to quickly update the dataset.
#'
#' @param cran_monthly_package_number_df A data.frame similar to
#' the `cran_monthly_package_number` dataset included within {cranology}.
#' @inheritParams mran
#'
#' @importFrom utils tail
#' @importFrom lubridate month days today
#'
#' @export
#' @examples
#' # Simulate `cran_monthly_package_number` update
#' date_lag <- 3
#' df <- cran_monthly_package_number[
#'   1:(nrow(cran_monthly_package_number) - date_lag),
#' ]
#' update_monthly_package_number(
#'   cran_monthly_package_number_df = df
#' )
#'
update_monthly_package_number <- function(
  cran_monthly_package_number_df,
  parallelize = FALSE
) {
  first_date <- tail(
    cran_monthly_package_number_df,
    1
  )[["date"]] + month(1) - days(1)
  dates <- seq(
    from = first_date,
    to = today(),
    by = "1 month"
  )
  recent_months <- get_package_number_mran(
    dates = dates,
    parallelize = parallelize
  )
  rbind(
    cran_monthly_package_number_df,
    recent_months
  )
}
