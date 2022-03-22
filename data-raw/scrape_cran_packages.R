
# Functions
update_dataset_doc_with_time_stamp <- function(
  path_doc = "R/doc_cran_packages_history.R"
) {
  data_doc <- readLines(path_doc)
  data_doc <- sub(
    pattern = "^#' Description\\.$",
    replacement = sprintf(
      "#' All packages ever available on CRAN as of %s.",
      lubridate::today()
    ),
    x = data_doc
  )
  writeLines(
    text = data_doc,
    con = path_doc
  )
}

# Download dataset
tictoc::tic()
future::plan(future::multisession)
cran_packages_history <- cranology::scrape_cran_packages_history()
readr::write_rds(
  cran_packages_history,
  file = "data-raw/cran_packages_history.rds"
)
tictoc::toc()

# Use dataset in package
cran_packages_history <- readRDS("data-raw/cran_packages_history.rds")
cran_monthly_package_number <- cranology::get_cran_monthly_package_number(
  cran_packages_history_df = cran_packages_history
)
usethis::use_data(cran_packages_history)
usethis::use_data(cran_monthly_package_number)

# Document data set
checkhelper::use_data_doc("cran_packages_history")
update_dataset_doc_with_time_stamp()
checkhelper::use_data_doc("cran_monthly_package_number")
file.edit("R/doc_cran_monthly_package_number.R")
