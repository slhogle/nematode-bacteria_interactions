# nematode-bacteria_interactions

[Click here to view rendered notebooks of the analysis.](https://slhogle.github.io/nematode-bacteria_interactions/)

## Manuscript:

### Published record

TBD

### Preprint

TBD

## Availability

Data and code in this GitHub repository (<https://github.com/slhogle/nematode-bacteria_interactions>) are provided under [GNU AGPL3](https://www.gnu.org/licenses/agpl-3.0.html).
The rendered project site is available at <https://slhogle.github.io/nematode-bacteria_interactions/>, which has been produced using [Quarto notebooks](https://quarto.org/). 
The content on the rendered site is released under the [CC BY 4.0.](https://creativecommons.org/licenses/by/4.0/)
This repository hosts all code and data for this project, including the code necessary to fully recreate the rendered webpage.

An archived release of the code is available from Zenodo: <https://zenodo.org/records/EVENTUAL_ZENODO_RECORD>

Raw sequencing data used in the project is available from NCBI Bioproject [PRJNA00000000](https://www.ncbi.nlm.nih

## Reproducibility

The project uses [`renv`](https://rstudio.github.io/renv/index.html) to create a reproducible environment to execute the code in this project. [See here](https://rstudio.github.io/renv/articles/renv.html#collaboration) for a brief overview on collaboration and reproduction of the entire project. 
To get up and running from an established repository, you could do:

``` r
install.packages("renv")
renv::restore()
```

To initiate `renv` for a new project:

``` r
# if on linux set cran here to download binaries
options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/latest"))
install.packages("renv")
# initialize
renv::init(bioconductor = TRUE)
# install some new packages
renv::install("tidyverse", "here", "fs", "edgeR", "archive")
# record those packages in the lockfile
renv::snapshot()
```
