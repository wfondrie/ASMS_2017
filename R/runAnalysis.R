# Run Analysis

library(knitr)
knit("Rmd/modelBuilding.Rmd")
rm(list = ls())
knit("Rmd/simulateComplexSpectra.Rmd")
rm(list = ls())
