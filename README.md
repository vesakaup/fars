# Building R Packages (Coursera)
Week 4 assignment
Vesa Kauppinen
GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Create an Example Package in R

Package: fars
GitHub: https://github.com/vesakaup/Building-R-packages

## Data Source

The functions will be using data from the US National Highway Traffic Safety 
Administration's [Fatality Analysis Reporting 
System](https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars),
which is a nationwide census providing the American public yearly data regarding
fatal injuries suffered in motor vehicle traffic crashes.

## Package functions

The functions in the package allow mapping the test data from the US National Highway Traffic Safety Administration on traffic accidents.

## Review Criteria

For this assignment you'll submit a link to the [GitHub repository](https://github.com/EnriquePH/FARS) which contains
your package. This assessment will ask reviewers the following questions:

* Does this package contain the correct [R file(s) under the R/ directory](https://github.com/vesakaup/Building-R-packages/tree/master/R)?
* Does this package contain a 
[man/](https://github.com/vesakaup/Building-R-packages/tree/master/man)?
* Does this package contain a 
[vignette]
* Does this package have at least one test included in the [tests/]
* Does this package have a [NAMESPACE]
* Does the README.md file for this directory have a [Travis badge]
* Is the build of this package passing on [Travis badge]
* Are the build logs for this package on [Travis badge]
