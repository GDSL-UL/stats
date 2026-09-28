#!/bin/bash

set -e

# RStudio runs as this (non-root) user in single-user mode, but the base image
# leaves its state dir owned by root -> "Permission denied ... session-rpc-key".
if [ -d /var/lib/rstudio-server ]; then
  sudo chown -R "$(id -u):$(id -g)" /var/lib/rstudio-server
fi

# Show students only the course material in their folder. Everything else
# (website build, Quarto config, ...) stays in the repo but is not checked out
# here. Edit the list to show/hide more; .devcontainer must stay.
git sparse-checkout set --no-cone \
  '/.devcontainer/' \
  '/labs/' \
  '/myLabs/' \
  '/data/' \
  '/img/' \
  '/envs225.Rproj'

echo "Checking R packages..."

# tidyverse ships with the image; this adds the rest.
Rscript .devcontainer/packages.R
