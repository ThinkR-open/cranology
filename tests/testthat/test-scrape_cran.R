
test_that("CRAN page url", {
  expect_identical(
    object = cran_page_url(),
    expected = "https://cran.rstudio.com/src/contrib"
  )
  expect_identical(
    object = cran_page_url("Archive"),
    expected = "https://cran.rstudio.com/src/contrib/Archive"
  )
  expect_identical(
    object = cran_page_url("Archive", "dplyr"),
    expected = "https://cran.rstudio.com/src/contrib/Archive/dplyr"
  )
})

test_that("Extract pacakge name from .tar.gz file name", {

  package_names <- extract_package_name(
    file_name = c(
      "afmToolkit_0.0.1.tar.gz",
      "EMDANNhybrid_0.1.0.tar.gz",
      "EpiCurve_2.4-2.tar.gz",
      "smicd_1.1.2.tar.gz",
      "vtreat_1.6.3.tar.gz"
    )
  )

  expect_setequal(
    object = package_names,
    expected = c("afmToolkit", "EMDANNhybrid", "EpiCurve", "smicd", "vtreat")
  )

})

test_that("scrape_cran_page() works", {
  test_scraping_funs(
    fun = scrape_cran_page,
    expected_colnames = c("file_name", "date", "time", "size", "package_name")
  )
})

test_that("get_main_page() works", {
  test_scraping_funs(
    fun = get_main_page,
    expected_colnames = c(
      "file_name",
      "date",
      "time",
      "size",
      "package_name",
      "last_modified",
      "archive"
    )
  )
})

test_that("get_archive_page() works", {
  test_scraping_funs(
    fun = get_archive_page,
    expected_colnames = c(
      "file_name",
      "date",
      "time",
      "size",
      "package_name",
      "last_archived",
      "archive"
    )
  )
})


test_that("get_package_first_release() works", {
  expected_tbl <- structure(
    list(
      package_name = "golem",
      first_date = structure(
        1565020200,
        tzone = "UTC",
        class = c("POSIXct","POSIXt")
      ),
      n_versions = 4L
    ),
    row.names = c(NA, -1L),
    class = c("tbl_df", "tbl", "data.frame")
  )
  expect_identical(
    get_package_first_release("golem"),
    expected_tbl
  )
})
