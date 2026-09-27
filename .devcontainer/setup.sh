#!/bin/bash

set -e

apt-get update

apt-get install -y \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libsqlite3-dev \
    libssl-dev \
    libcurl4-openssl-dev

Rscript - <<EOF

packages <- c(
  "tidyverse",
  "ggplot2",
  "dplyr",
  "readr",
  "readxl",
  "haven",
  "janitor",
  "lubridate",
  "broom",
  "knitr",
  "rmarkdown",
  "quarto",
  "sf",
  "terra",
  "tmap",
  "leaflet"
)

installed <- rownames(installed.packages())

for (p in packages) {
  if (!(p %in% installed)) {
    install.packages(p, repos="https://cloud.r-project.org")
  }
}

EOF