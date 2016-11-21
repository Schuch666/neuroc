


# Using Neuroconductor

[Install and start the latest release version of R](#installing-and-starting-r) and then you can install a package using the following command:


```r
## try https:// if http:// URLs are supported
source("http://neuroconductor.org/neurocLite.R")
neuro_install("PACKAGE")
```
where `PACKAGE` is the name of the package you'd like to install, such as `fslr`.  For example, if we want to install `hcp` and `fslr` we can run:

```r
source("http://neuroconductor.org/neurocLite.R")
neuro_install(c("fslr", "hcp"))
```

As with Bioconductor, which uses the `biocLite` function to install packages, we have created a duplicate of `neuro_install`, called `neurocLite`, so that the same command could have been executed as follows:

```r
source("http://neuroconductor.org/neurocLite.R")
neurocLite(c("fslr", "hcp"))
```

## Installing `neurocInstall`

The `neurocInstall` package contains the `neurocLite`/`neuro_install` functions, as well as others relevant for Neuroconductor.  You can install the package as follows:


```r
source("http://neuroconductor.org/neurocLite.R")
neuro_install("neurocInstall")
```

In the future, you can use `neurocInstall::neuroc_install()` to install packages without source-ing the URL above.

# Installing and Starting R 

1.  Download the most recent version of R from [https://cran.r-project.org/](https://cran.r-project.org/). There are detailed instructions on the R website as well as the specific R installation for the platform you are using, typically Linux, OSX, and Windows.

2.  Start R; we recommend using R through [RStudio](https://www.rstudio.com/).  You can start R using RStudio (Windows, OSX, Linux), typing "R" at in a terminal (Linux or OSX), or using the R application either by double-clicking on the R application (Windows and OSX).

3.  For learning R, there are many resources such as [Try-R at codeschool](http://tryr.codeschool.com/) and [DataCamp](https://www.datacamp.com/getting-started?step=2&track=r).