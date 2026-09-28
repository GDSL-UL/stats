# Every package loaded in labs/*.qmd. tidyverse ships with the image; setup.sh
# runs this when a codespace is created to install the rest.
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
  # The image's default repo is Posit Package Manager binaries, so nothing
  # compiles from source.
  install.packages(missing)
}

still_missing <- setdiff(packages, rownames(installed.packages()))
if (length(still_missing) > 0) {
  stop("Failed to install: ", paste(still_missing, collapse = ", "))
}
