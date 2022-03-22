
cran_page_url <- function(...) {
  file.path('https://cran.rstudio.com/src/contrib', ...)
}

#' Extract package name from tar.gz file name
#'
#' For example:
#' > extract_package_name("AATtools_0.0.1.tar.gz")
#' [1] "AATtools"
#'
#' @param file_name A character string corresponding to a file in CRAN entries
#' @noRd
extract_package_name <- function(file_name) {
  # package name should contain only (ASCII) letters, numbers and dot
  sub("^([a-zA-Z0-9\\.]*).*", "\\1", file_name)
}

#' Scrape a html page from CRAN
#' @param page Name of page to parse
#' @importFrom rvest read_html html_nodes html_text
#' @importFrom stringr str_split str_trim
#' @importFrom stringi stri_remove_empty
#' @importFrom dplyr as_tibble mutate
#' @importFrom lubridate ymd_hm
#' @noRd
scrape_cran_page <- function(page = "") {

  # Get content of the page
  text_rvest <- read_html(cran_page_url(page))

  # Extract pkg list as character vector
  page_text_chr <- text_rvest %>%
    html_nodes("pre") %>%
    html_text() %>%
    str_split("\n") %>%
    unlist()

  # Remove useless first line with header and Parent directory link
  page_text_chr <- page_text_chr[-1]

  # Separate text element into 3
  # The output is a matrix with column names.
  page_text_matrix <- page_text_chr %>%
    # Remove empty string => last item
    stri_remove_empty() %>%
    # trim white space padding each item
    str_trim() %>%
    str_split("\\s+", simplify = TRUE)
  colnames(page_text_matrix) <- c("file_name", "date", "time", "size")

  # Convert text matrix to tibble
  page_text_tbl <- page_text_matrix %>%
    as_tibble() %>%
    mutate(
      # grab date from last modified timestamp
      date = ymd_hm(paste(date, time)),
      # Extract package names to distinguish them from other type of content
      package_name = extract_package_name(file_name)
    )

  return(page_text_tbl)
}


#' Get main CRAN page
#' @importFrom dplyr filter mutate
#' @importFrom stringr str_detect
#' @noRd
get_main_page <- function() {
  scrape_cran_page() %>%
    filter(
      # Keep only line corresponding to packages (all .tar.gz files)
      str_detect(file_name, "\\.tar\\.gz$")
    ) %>%
    mutate(
      last_modified = date,
      archive = FALSE
    )
}

# Get archives
#' @importFrom dplyr filter mutate
#' @importFrom stringr str_detect
#' @noRd
get_archive_page <- function() {
  scrape_cran_page("Archive") %>%
    filter(
      # Keep only directories to later be able to recurse through them
      str_detect(file_name, "/$")
    ) %>%
    mutate(
      last_archived = date,
      archive = TRUE
    )
}

#' Get first release of package
#'
#' Scrape every folder of the CRAN archive to retrieve both the date of
#' the first release and the number of versions released for all archived packaged.
#'
#' @param package_name A character string. The package name.
#' @return A tibble with three columns: _package_name_, _first_date_ and _n_versions_.
#'
#' @importFrom dplyr filter summarise mutate n everything
#' @importFrom stringr str_detect
get_package_first_release <- function(package_name) {
  file.path("Archive", package_name) %>%
    scrape_cran_page() %>%
    filter(
      # Keep only line corresponding to packages (all .tar.gz files)
      str_detect(file_name, "\\.tar\\.gz$")
    ) %>%
    summarise(
      first_date = min(date), # first release
      n_versions = n() # number of releases/versions
    ) %>%
    mutate(
      package_name = package_name,
      .before = everything()
    )
}

#' Coucou
#'
#' Parse the entire archive only once
#'
#' @importFrom furrr future_map_dfr
#' @importFrom readr read_rds write_rds
#' @importFrom dplyr left_join bind_rows group_by summarise mutate tibble filter
#' @importFrom lubridate as_datetime now
#' @importFrom purrr map_dbl
scrape_cran_packages_history <- function() {

  main_page_df <- get_main_page()
  archive_page_df <- get_archive_page()
  # This takes ~ 15 mins on a 8-core
  archive_first_release_df <- furrr::future_map_dfr(
    archive_page_df$package_name,
    get_package_first_release
  )

  # Combine main, archive page and first release info
  all_packages_df <- archive_page_df %>%
    # Add date of first release and number of versions
    left_join(archive_first_release_df, by = "package_name") %>%
    # Combine with packages currently on available
    bind_rows(main_page_df)

  return(all_packages_df)
}

#' Title
#'
#' Description
#'
#' @param cran_packages_history_df A data.frame similar to cranology::cran_packages_history
#' which is the default value.
#'
get_cran_monthly_package_number <- function(
  cran_packages_history_df = cran_packages_history
) {
  # There may be multiple version of same package in "current" repository
  all_pkgs_summary <- cran_packages_history_df %>%
    group_by(package_name) %>%
    summarise(
      current = any(!archive),
      n_versions = ifelse(
        any(!archive),
        sum(n_versions, 1, na.rm = TRUE),
        n_versions[archive]
      ),
      last_modified = ifelse(
        any(!archive),
        max(last_modified[!archive]),
        last_archived[archive]
      ),
      first_created = ifelse(
        any(archive),
        first_date,
        min(last_modified)
      ),
      .groups = "drop"
    ) %>%
    mutate(
      last_modified = as_datetime(last_modified),
      first_created = as_datetime(first_created),
      last_available = ifelse(current, now(), last_modified) %>% as_datetime()
    )

  seq_months <- tibble(
    date = seq(
      from = min(all_pkgs_summary$first_created, na.rm = TRUE),
      to = now(),
      by = "1 month"
    )
  )

  all_pkgs_summary_time <- seq_months %>%
    mutate(
      number_packages = map_dbl(date, function(date) {
        all_pkgs_summary %>%
          filter(date >= first_created & date <= last_available) %>%
          nrow()
      })
    )

  return(all_pkgs_summary_time)
}


