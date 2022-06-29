#' cran_packages_history
#'
#' All packages ever available on CRAN.
#' Last update: 2022-06-29.
#'
#' @format A data frame with 312 rows and 10 variables:
#' \describe{
#'   \item{ file_name }{ [character] Either the name of the .tar.gz or the name
#'   of the archive folder holding the .tar.gzs of all versions ever released
#'   of a given package.}
#'   \item{ date }{ [POSIXct,POSIXt] The date of upload on CRAN. }
#'   \item{ time }{ [character] The time of upload on CRAN. }
#'   \item{ size }{ [character] The size of the .tar.gzs. '-' in case of archive folder. }
#'   \item{ package_name }{ [character] The name of the package. }
#'   \item{ last_archived }{ [POSIXct,POSIXt] The date when one version was last archived. }
#'   \item{ archive }{ [logical] Was a version ever archived ? }
#'   \item{ first_date }{ [POSIXct,POSIXt] The date of the first release.  }
#'   \item{ n_versions }{ [integer] The number of versions released. }
#'   \item{ last_modified }{ [POSIXct,POSIXt] The date of last release. }
#' }
#' @source https://cran.rstudio.com/src/contrib/
"cran_packages_history"
