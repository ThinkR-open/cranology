# cranology 1.0.0

### Breaking change

* As of July 1, 2023, the MRAN site no longer exists. The dependent functions have been replaced and renamed to scrape number of available packages on PPM (`https://packagemanager.posit.co`) : 
  - `get_package_number_mran()` -> `get_package_number_ppm()`

### Update

* Data update : 
  - cran_monthly_package_number
  - cran_packages_history

# cranology 0.1.0

### Stabilise API

* `scrape_cran()`: function to generate both `cran_packages_history` and `cran_monthly_package_number` datasets.
* `get_package_number_mran()`: function to scrape number of available packages on MRAN.
* `update_montly_package_number()`: uses `get_package_number_mran()` to update datase `cran_monthly_package_number`.
* `plot_montly_package_number()`: function to plot `cran_monthly_package_number`.

### Misc

* Add Continous Integration
* Update README to a decent standard
