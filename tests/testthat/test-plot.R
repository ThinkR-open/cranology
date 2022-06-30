test_that("scale_package_number() works", {
  expect_equal(
    scale_package_number(3E3),
    seq(0, 3E3, by = 1E3)
  )
  expect_equal(
    scale_package_number(1E4),
    seq(0, 1E4, by = 1E3)
  )
  expect_equal(
    scale_package_number(2E4),
    seq(0, 2E4, by = 1E3)
  )
  expect_equal(
    scale_package_number(2.5E4),
    seq(0, 2.5E4, by = 1E3)
  )
  expect_equal(
    scale_package_number(2E5),
    seq(0, 2E5, by = 1E3)
  )
})

test_that("plot_cran_monthly_package_number()", {
  expect_s3_class(
    plot_cran_monthly_package_number(),
    c("gg", "ggplot")
  )
})
