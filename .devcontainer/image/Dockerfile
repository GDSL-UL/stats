# Course image: Rocker's Codespaces image plus every package the labs use.
# Built and published to ghcr.io/gdsl-ul/stats-rstudio by
# .github/workflows/devcontainer-image.yml; RStudio Server is added on top by
# the feature in image/devcontainer.json.
FROM ghcr.io/rocker-org/devcontainer/tidyverse:4

# Links the published package to the repo (and its public visibility).
LABEL org.opencontainers.image.source="https://github.com/GDSL-UL/stats"

USER root
COPY packages.R /tmp/packages.R
RUN Rscript /tmp/packages.R && rm /tmp/packages.R
