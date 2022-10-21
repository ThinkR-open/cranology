
### Daily ----------------------------------------------------------------------

attachment::att_amend_desc(
  pkg_ignore = "roxygen2",
  extra.suggests = c(
    "knitr",
    "roxygen2",
    "usethis",
    "withr",
    "checkhelper"
  )
)
usethis::use_dev_package("checkhelper", type = "Suggests")

devtools::check()

checkhelper::print_globals()


### Setup ----------------------------------------------------------------------

# Hide this file from build
usethis::use_build_ignore("dev/")

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
