# few lines to help make sure we do have everything we need
`%not in%` <- Negate(`%in%`)
error_count <- 0 

needed_packages <-
  c("remotes", "shiny", "flexdashboard", 
    # data wrangling and plotting packages
    "tidyverse", "patchwork", "ggsci", "glue", "thematic",
    # toy datasets
    "palmerpenguins", "gapminder",
    # presenting data interactively
    "DT",
    # interactive plots
    "plotly")

# a helper abbreviation
`%not in%` <- Negate(`%in%`)

for (pkg in needed_packages) {
  if (pkg %not in% rownames(installed.packages())) {
    print(paste("Trying to install", pkg))
    install.packages(pkg)
    if ((pkg %not in% rownames(installed.packages()))) {
      msg <- paste("ERROR: Unsuccessful!", pkg, "not installed!",
                   "Check the log and try installing the package manually.")
      error_count <- error_count + 1
      stop(msg)
    } 
  }
  library(pkg, character.only = TRUE)
  if(pkg %in% loadedNamespaces()) {
    print(paste("Successful!", pkg, "loaded."))
  } else {
    error_count <- error_count + 1
    msg <- paste("ERROR: Unsuccessful!", pkg, 
                 "not loaded. Check error msg.")
    print(msg)
  }
}

# additional packages from github
needed_packages_remotes <- 
  c("rstudio/flexdashboard")

for (pkg in needed_packages_remotes) {
  pkg_name <- basename(pkg)
  if (pkg_name %not in% rownames(installed.packages())) {
    print(paste("Trying to install", pkg_name))
    remotes::install_github(pkg)
    if (pkg_name %not in% rownames(installed.packages())) {
      msg <- paste("ERROR: Unsuccessful!", pkg, "not installed!",
                   "Check the log and try installing the package manually.")
      stop(msg)
    } 
  }
  library(pkg_name, character.only = TRUE)
  if(pkg_name %in% loadedNamespaces()) {
    print(paste("Successful!", pkg_name, "loaded."))
  } else {
    error_count <- error_count + 1
    msg <- paste("ERROR: Unsuccessful!", pkg_name, "installed from:", pkg, 
                 "not loaded. Check error msg for.")
    print(msg)
  }
}

if (error_count == 0) {
  print(glue("SUCCESS: Fantastic! All packages installed and ready."))
}