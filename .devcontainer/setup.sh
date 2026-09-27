#!/bin/bash

set -e

echo "Checking R packages..."

# Most packages ship with the image; this only fills gaps. Uses the image's
# default repo (Posit Package Manager binaries) so nothing compiles from source.
Rscript - <<EOF

packages <- c(
  "tidyverse",
  "sf",
  "terra",
  "tmap",
  "leaflet",
  "knitr",
  "rmarkdown",
  "quarto"
)

missing <- setdiff(packages, rownames(installed.packages()))

if (length(missing) > 0) {
  install.packages(missing)
}

still_missing <- setdiff(packages, rownames(installed.packages()))
if (length(still_missing) > 0) {
  stop("Failed to install: ", paste(still_missing, collapse = ", "))
}

EOF
