
# Download datasets
start <- Sys.time()
future::plan(future::multisession)
l_data <- cranology::scrape_cran_history()

cran_packages_history <- l_data$cran_packages_history
cran_monthly_package_number <- l_data$cran_monthly_package_number
readr::write_rds(
  cran_packages_history,
  file = "data-raw/cran_packages_history.rds"
)
readr::write_rds(
  cran_monthly_package_number,
  file = "data-raw/cran_monthly_package_number.rds"
)
end <- Sys.time()
(duration <- end-start)


# Use datasets in package
usethis::use_data(cran_packages_history, overwrite = TRUE)
usethis::use_data(cran_monthly_package_number, overwrite = TRUE)

# Document data set
checkhelper::use_data_doc("cran_packages_history")
cranology:::update_dataset_doc_with_time_stamp()
checkhelper::use_data_doc("cran_monthly_package_number")
file.edit("R/doc_cran_monthly_package_number.R")
