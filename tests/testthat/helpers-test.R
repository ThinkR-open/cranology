
test_scraping_funs <- function(fun, expected_colnames, ...) {

    cran_page_tbl <- eval(fun)(...)

    # Ouput is a tibble
    expect_s3_class(cran_page_tbl, class = c("tbl_df", "tbl", "data.frame"))
    # Output has expected colum names
    expect_identical(
      object = colnames(cran_page_tbl),
      expected = expected_colnames
    )
    # The resulting as > 0 rows
    expect_true(nrow(cran_page_tbl) > 0)
}

expect_no_error <- function(...) {
  expect_error(..., regexp = NA)
}

expect_invalid_date <- function(...) {
  expect_error(...,  regexp = "`dates` must be either:")
}
