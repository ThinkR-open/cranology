
## Download datasets
start <- Sys.time()
future::plan(future::multisession)
l_data <- cranology::scrape_cran_history()
cran_packages_history <- l_data$cran_packages_history
cran_monthly_package_number <- l_data$cran_monthly_package_number
end <- Sys.time()
(duration <- end-start)


## Use datasets in package
usethis::use_data(cran_packages_history, overwrite = TRUE)
usethis::use_data(cran_monthly_package_number, overwrite = TRUE)

## Document data set

# Used once at the beginning
# checkhelper::use_data_doc("cran_packages_history")
# cranology:::update_dataset_doc_with_time_stamp()
# checkhelper::use_data_doc("cran_monthly_package_number",)

# Update documentation
cranology:::update_dataset_doc(dataset_name = "cran_packages_history")
cranology:::update_dataset_doc(dataset_name = "cran_monthly_package_number")
