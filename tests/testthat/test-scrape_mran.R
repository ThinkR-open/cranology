
test_that("is_parsable_date() works", {
  expect_true(is_parsable_date(lubridate::ymd("2016-03-02")))
  expect_true(is_parsable_date("2016-03-02"))
  expect_false(is_parsable_date("2016-28-02"))
  expect_false(is_parsable_date("2016-02-31"))
})

test_that("is_valid_date() works", {

  # Valid cases
  expect_false(is_invalid_date(as.Date(Sys.time())))
  expect_false(is_invalid_date(lubridate::dmy("020392")))
  expect_false(is_invalid_date("2016-03-02"))
  expect_false(is_invalid_date("20160302"))

  # Invalid cases
  expect_true(is_invalid_date("020392"))
  expect_true(is_invalid_date("2016-31-02"))
})

test_that("is_valid_dates() works", {

  # Valid cases
  today <- as.Date(Sys.time())
  dates <- seq(from = today - 10, to = today, by = "day")
  expect_equal(
    is_invalid_dates(dates),
    rep(FALSE, length(dates))
  )

  # Invalid cases
  expect_equal(
    is_invalid_dates(c("2018-02-21", "2017-123-13", "232-344-3")),
    c(FALSE, TRUE, TRUE)
  )
})

test_that("is_anterior_to_mran_launch() works", {
  expect_true(
    is_anterior_to_mran_launch(as.Date("2013-09-10"))
  )
  expect_false(
    is_anterior_to_mran_launch(as.Date("2019-09-10"))
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
  expect_error(
    get_package_number_mran(c("2019-09-10", "2013-09-10")),
    regexp = "Some dates are anterior to MRAN launch:\n2: 2013-09-10"
  )

})

test_that("update_monthly_package_number() works", {
  date_lag <- 3
  n_additional_dates <- date_lag + 1
  df <- cran_monthly_package_number[
    1:(nrow(cran_monthly_package_number) - date_lag),
  ]
  df_updated <- update_monthly_package_number(
    cran_monthly_package_number_df = df,
    update_until = tail(cran_monthly_package_number$date, 1)
  )
  # New dates all correspond to the same day of the month
  expect_length(
    unique(lubridate::day(df_updated$date)),
    1
  )
  expect_equal(
    nrow(df_updated),
    nrow(df) + n_additional_dates
  )
})
