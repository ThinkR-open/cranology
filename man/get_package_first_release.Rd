% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scrape_cran.R
\name{get_package_first_release}
\alias{get_package_first_release}
\title{Get first release of package}
\usage{
get_package_first_release(package_name)
}
\arguments{
\item{package_name}{A character string. The package name.}
}
\value{
A tibble with three columns: _package_name_, _first_date_ and _n_versions_.
}
\description{
Scrape every folder of the CRAN archive to retrieve both the date of
the first release and the number of versions released for all archived packaged.
}
