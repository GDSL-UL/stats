#!/bin/bash

set -e

# RStudio runs as this (non-root) user in single-user mode, but the base image
# leaves its state dir owned by root -> "Permission denied ... session-rpc-key".
if [ -d /var/lib/rstudio-server ]; then
  sudo chown -R "$(id -u):$(id -g)" /var/lib/rstudio-server
fi

echo "Checking R packages..."

# tidyverse ships with the image; this adds the rest. Uses the image's
# default repo (Posit Package Manager binaries) so nothing compiles from source.
Rscript - <<EOF

# Every package loaded in labs/*.qmd
packages <- c(
  "tidyverse",
  "broom",
  "knitr",
  "rmarkdown",
  "scales",
  "readxl",
  "RColorBrewer",
  "kableExtra",
  "vtable",
  "vcd",
  "pscl",
  "ggridges",
  "corrplot"
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
