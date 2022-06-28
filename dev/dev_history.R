
### Daily ----------------------------------------------------------------------

attachment::att_amend_desc(
  extra.suggests = "knitr"
)

devtools::check()

checkhelper::print_globals()


### Setup ----------------------------------------------------------------------

# Hide this file from build
usethis::use_build_ignore("dev/")

# description ----
library(desc)
unlink("DESCRIPTION")

my_desc <- description$new("!new")
my_desc$set_version("0.0.0.9000")
my_desc$set(Package = "cranology")
my_desc$set(Title = "Monitor The Evolution Of The Number Of CRAN Packages")
my_desc$set(
  Description = "Scraping routines to monitor the evolution of of the number of packages on CRAN."
)
my_desc$set(
  "Authors@R",
  'c(
  person("Antoine", "Languillaume", email = "antoine@thinkr.fr", role = c("aut", "cre"), comment = c(ORCID = "0000-0001-9843-5632")),
  person("Sebastien", "Rochette", email = "sebastien@thinkr.fr", role = c("aut"), comment = c(ORCID = "0000-0002-1565-9313")),
  person("Vincent", "Guyader", email = "vincent@thinkr.fr", role = c("aut"), comment = c(ORCID = "0000-0003-0671-9270")),
  person(given = "ThinkR", role = "cph")
)')
my_desc$set("VignetteBuilder", "knitr")
my_desc$del("Maintainer")
my_desc$del("URL")
my_desc$del("BugReports")
my_desc$write(file = "DESCRIPTION")

## Common files
usethis::use_mit_license("ThinkR")
usethis::use_readme_rmd()
usethis::use_code_of_conduct(contact = "Antoine Languillaume")
usethis::use_lifecycle_badge("Experimental")
usethis::use_news_md()

# Pipe
usethis::use_pipe()

# Git
usethis::use_git()

## Add folders and files -----------------------------------

usethis::use_data_raw()

# Adding new files ----
use_r_with_test <- function(name) {
  usethis::use_r(name = name)
  usethis::use_test(name = name)
}
use_r_with_test("scrape_cran")
use_r_with_test("utils")
use_r_with_test("plot")
use_r_with_test("scrape_mran")

## Package quality -----------------------------------------

# Documentation ----
usethis::use_package_doc()

# _Vignette
# file.copy(system.file("templates/html/header_hide.html", package = "thinkridentity"),
#           "vignettes")
# thinkridentity::add_thinkr_css(path = "vignettes")
#
# thinkridentity::create_vignette_thinkr("aa-data-exploration")
# usethis::use_vignette("ab-model")
# devtools::build_vignettes()

# GitHub Actions ----
usethis::use_github_action_check_release()
# usethis::use_github_action_check_standard()
# usethis::use_github_action("pkgdown")
#  _Add remotes::install_github("ThinkR-open/thinkrtemplate") in this action
# usethis::use_github_action("test-coverage")

# _rhub
# rhub::check_for_cran()

# _Badges GitLab
# usethis::use_badge(
#   badge_name = "pipeline status",
#   href = "https://forge.thinkr.fr/<group>/<project>/-/commits/master",
#   src = "https://forge.thinkr.fr/<group>/<project>/badges/master/pipeline.svg"
#   )
# usethis::use_badge(
#   badge_name = "coverage report",
#   href = "http://<group>.pages.thinkr.fr/<project>/coverage.html",
#   src = "https://forge.thinkr.fr/<group>/<project>/badges/master/coverage.svg"
# )

# _Pkgdown - Pas besoin d'inclure le pkgdown pour un projet open-source avec un gh-pages
# usethis::use_pkgdown()
# pkgdown::build_site() # pour tests en local
# chameleon::build_pkgdown(
#   # lazy = TRUE,
#   yml = system.file("pkgdown/_pkgdown.yml", package = "thinkridentity"),
#   favicon = system.file("pkgdown/favicon.ico", package = "thinkridentity"),
#   move = TRUE, clean_before = TRUE, clean_after = TRUE
# )

# chameleon::open_pkgdown_function(path = "docs")
# pkg::open_pkgdown()

# Description and Bibliography
# chameleon::create_pkg_desc_file(out.dir = "inst", source = c("archive"), to = "html")
# thinkridentity::create_pkg_biblio_file_thinkr()
