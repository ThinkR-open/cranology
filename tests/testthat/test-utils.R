test_that("update_dataset_doc() works", {

  dummypackage <- tempfile("dummypackage")
  usethis::create_package(dummypackage, open = FALSE)

  withr::with_dir(dummypackage, {

    name_dummy_dataset <- "dummy_dataset"
    path_doc_dummy_dataset <- paste0("R/doc_", name_dummy_dataset, ".R")

    dummy_dataset <- data.frame(
      a = 1:10,
      b = 1:10
    )
    usethis::use_data(dummy_dataset)

    writeLines(
      text = c(
        "#' blabla",
        "#' Last update: 2021-09-13.",
        "#' @format A data frame with 1 rows and 1 variables:",
        "#' patatipatata"
      ),
      con = path_doc_dummy_dataset
    )

    update_dataset_doc(dataset_name = name_dummy_dataset)

    updated_doc <- readLines(path_doc_dummy_dataset)
    # Time stamp properly updated
    expect_true(
      any(
        grepl(
          pattern = sprintf("#' Last update: %s.", lubridate::today()),
          updated_doc
        )
      )
    )
    # Dimensions properly updated
    format_line <- grep("^#' @format", updated_doc, value = TRUE)
    expect_equal(
      gsub(
        pattern = "#' @format A data frame with (\\d+) rows and (\\d+) variables:",
        replacement = "\\1__\\2",
        x = format_line
      ),
      "10__2"
    )

  })

})
