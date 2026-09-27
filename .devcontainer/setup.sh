#!/bin/bash

set -e

echo "Installing packages..."

Rscript - <<EOF

packages <- c(
  "tidyverse",
  "ggplot2",
  "dplyr",
  "sf",
  "terra",
  "tmap",
  "leaflet",
  "knitr",
  "rmarkdown",
  "quarto"
)

installed <- rownames(installed.packages())

for (p in packages) {
  if (!(p %in% installed)) {
    install.packages(
      p,
      repos="https://cloud.r-project.org"
    )
  }
}

EOF

rstudio-server start || true