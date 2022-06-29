
test_that("is_parsable_date() works", {
  expect_true(is_parsable_date(lubridate::ymd("2016-03-02")))
  expect_true(is_parsable_date("2016-03-02"))
  expect_false(is_parsable_date("2016-28-02"))
  expect_false(is_parsable_date("2016-02-31"))
})

test_that("is_valid_date() works", {

  # Valid cases
  expect_no_error(is_valid_date(as.Date(Sys.time())))
  expect_no_error(is_valid_date(lubridate::dmy("020392")))
  expect_no_error(is_valid_date("2016-03-02"))
  expect_no_error(is_valid_date("20160302"))

  # Invalid cases
  expect_invalid_date(is_valid_date("020392"))
  expect_invalid_date(is_valid_date("2016-31-02"))
})

test_that("is_valid_dates() works", {

  # Valid cases
  today <- as.Date(Sys.time())
  dates <- seq(from = today - 10, to = today, by = "day")
  expect_no_error(is_valid_dates(dates))

  # Invalid cases
  expect_error(
    is_valid_dates(c("2018-02-21", "2017-123-13", "232-344-3")),
    regexp = "Some dates are not valid dates:"
  )
})

test_that("get_package_number_mran() works", {

  ## Valid cases
  dday <- as.Date("2022-04-01", "%Y-%m-%d")
  dates <- seq(from = dday - 2, to = dday, by = "day")
  result <- get_package_number_mran(dates)
  expect_s3_class(result, "data.frame")
  expect_identical(
    result$date,
    structure(c(19081, 19082, 19083), class = "Date")
  )
  # Account for MRAN failure -> NA being returned
  # result$n <- c(19022, NA, 19033)
  value_equal <- result$n %in% c(19022L, 19035L, 19033L)
  expect_true(all(value_equal | is.na(result$n[!value_equal])))

  ## Invalid cases
  expect_error(
    get_package_number_mran(c("2018-02-21", "2017-123-13")),
    regexp = "Some dates are not valid dates:"
  )
  expect_error(
    get_package_number_mran(c("2018-02-21", "232-344-3")),
    regexp = "Some dates are not valid dates:"
  )

})

test_that("update_monthly_package_number() works", {
  date_lag <- 3
  n_additional_dates <- date_lag + 1
  df <- cran_monthly_package_number[
    1:(nrow(cran_monthly_package_number) - date_lag),
  ]
  df_updated <- update_monthly_package_number(
    cran_monthly_package_number_df = df
  )
  # New dates all correspondent to the same day of the month
  expect_length(
    unique(lubridate::day(df_updated$date)),
    1
  )
  expect_equal(
    nrow(df_updated),
    nrow(df) + n_additional_dates
  )
})
