
scale_package_number <- function(number_packages) {
  max_n <- max(number_packages)
  order_magnitude <- 10 ^ (nchar(max_n) - 1)
  max_y <- round(max_n / order_magnitude, digits = 2) * order_magnitude
  seq(
    from = 0,
    to = max_y,
    by = 1000
  )
}

#' Plot monthly evolution of package number on CRAN
#'
#' This function is a convenience tool to quickly draw a line
#' showing the evolution of packages number on CRAN since its
#' beginning. It uses the `cran_monthly_package_number` dataset.
#'
#' @return A ggplot object
#'
#' @importFrom ggplot2 ggplot aes geom_line scale_x_date scale_y_continuous labs
#' @importFrom ggplot2 theme_bw theme element_text
#'
#' @export
#'
#' @examples
#' plot_cran_monthly_package_number()
plot_cran_monthly_package_number <- function() {

  ggplot(cranology::cran_monthly_package_number) +
    aes(x = date, y = number_packages) +
    geom_line(colour = "#15b7d6", lwd = 1) +
    scale_x_date(
      expand = c(0, 1),
      date_breaks = "1 year",
      date_labels = "%Y"
    ) +
    scale_y_continuous(
      minor_breaks = scale_package_number(
        cranology::cran_monthly_package_number$number_packages
      )
    ) +
    labs(
      title = "The evolution of the number of packages on CRAN",
      x = "Year",
      y = "Number of packages"
    ) +
    theme_bw() +
    theme(
      axis.text.x = element_text(vjust = 0.5, hjust = 0.5, angle = 45)
    )

}
