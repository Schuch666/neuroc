---
title: "Rxnat: Query and retrieves neuroimaging sets from XNAT projects"
author: "Adi Gherman"
date: "2021-02-18"
output: 
  html_document:
    keep_md: true
    theme: cosmo
    toc: true
    toc_depth: 3
    toc_float:
      collapsed: false
    number_sections: true
bibliography: ../refs.bib
---



# XNAT
[XNAT](https://www.xnat.org) is an open source imaging informatics platform developed by the Neuroinformatics Research Group at Washington University. XNAT was originally developed in the Buckner Lab at Washington University, now at Harvard University. It facilitates common management, productivity, and quality assurance tasks for imaging and associated data. Thanks to its extensibility, XNAT can be used to support a wide range of imaging-based projects. 

XNAT has become the data archiving tool of choice for multiple neuroimaging projects and research labs around the world. Listed below are some of the most popular image repositories that use XANT.

* [NITRC](https://nitrc.org) - Neuroimaging Informatics Tools and Resources Clearinghouse is currently a free one-stop-shop collaboratory for science researchers that need resources such as neuroimaging analysis software, publicly available data sets, or computing power. 
* [ConnectomeDB](https://db.humanconnectome.org/) -  The Human Connectome Project (HCP) is a project to construct a map of the complete structural and functional neural connections in vivo within and across individuals. 
* [XNAT Central](https://central.xnat.org) - XNAT Central is a database for sharing neuroimaging and related data with select collaborators or the general community. 

For a more complete list of XNAT implementations around the world you can click [here](https://www.xnat.org/about/xnat-implementations.php).

## Installing the Rxnat package

You can install `Rxnat` from Neuroconductor (Rxnat will be incorporated with the  Feb 2019 release) or from GitHub with:

```r
source("http://neuroconductor.org/neurocLite.R")
neuro_install("Rxnat", release = "stable")

# install.packages("remotes")
remotes::install_github("adigherman/Rxnat")
```

## Accessing XNAT Data

### How to get a username/password for a XNAT project
XNAT projects can be public or private. In order to access a private repository a set of credentials are required. To obtain a user name and password combo you will need to visit:

* HCP (Human Connectome Project) - [new account request](https://db.humanconnectome.org) and click on the Register button
* NITRC - [new account request](https://www.nitrc.org/account/register.php). Some of the NITRC hosted projects will require additional access reuquests but this can be easily requested using the NITRC web interface for each project.
* XNAT Central - this is mostly public, but you can also perform a [new account request](https://central.xnat.org/app/template/Register.vm) if any of the projects require it. 

### Establishing a XNAT connection with the `Rxnat` package
The `Rxnat` package will accept credentials provided in the function call or read from the system environment.

#### Function parameters
To establish a connection using the credentials as function parameters we can call the `xnat_connect` function:

```r
nitrc <- xnat_connect('https://nitrc.org/ir', username='XXXX', password='YYYY', xnat_name=NULL)
```

#### Setting up system environment variables
To use system environment variables we need to add them to the `.Renviron` file located in the user's home folder. Use `Sys.getenv("HOME")` to get the path (for unix/osx users the location can be easily accessed with ~, eg. `vi ~/.Renviron`).
The `Rxnat` package will be able to automatically read / use a system environment variable provided the following format is used: `XXXX_Rxnat_USER` and `XXXX_Rxnat_PASS`. `XXXX` is provided as an argument when an XNAT connection is initiated. 

As an example `NITRC` is used as argument and the system environment variables names should be `NITRC_Rxnat_USER`, and `NITRC_Rxnat_PASS`.

```r
nitrc <- xnat_connect('https://nitrc.org/ir', xnat_name='NITRC')
```

## Get list of available XNAT projects
Once a connection is established using the `xnat_connect` function a list of available projects can be easily retrieved by using the class internal function `projects`:

```r
hcp <-xnat_connect('https://db.humanconnectome.org', xnat_name = "hcp")
hcp_projects <- hcp$projects()
head(hcp_projects[c('id','name')])
            id                                        name
1 CCF_DMCC_STG                        DMCC Staging Project
2     HCP_1200            WU-Minn HCP Data - 1200 Subjects
3      HCP_500 WU-Minn HCP Data &#150; 500 Subjects + MEG2
4  HCP_500_RST      HCP 500 Subject + MEG2 Restricted Data
5      HCP_900        WU-Minn HCP Data - 900 Subjects + 7T
6    HCP_Coded                                   HCP_Coded
```

## Retrieve a list with all accessible subjects
A full list of subjects for each XNAT connection can be retrieved using the `subjects` function:

```r
hcp_subjects <- hcp$subjects()
head(hcp_subjects)
       project                  ID  label gender handedness yob education ses group race ethnicity
1 HCP_Subjects ConnectomeDB_S02177 100004      M         NA  NA        NA  NA    NA   NA        NA
2 HCP_Subjects ConnectomeDB_S01982 100206      M         NA  NA        NA  NA    NA   NA        NA
3 HCP_Subjects ConnectomeDB_S00230 100307      F         NA  NA        NA  NA    NA   NA        NA
4 HCP_Subjects ConnectomeDB_S00381 100408      M         NA  NA        NA  NA    NA   NA        NA
5 HCP_Subjects ConnectomeDB_S01590 100610      M         NA  NA        NA  NA    NA   NA        NA
6 HCP_Subjects ConnectomeDB_S00551 101006      F         NA  NA        NA  NA    NA   NA        NA
```

## Get full list of experiments
To obtain a full list of experiments the `experiments` function will be used:

```r
hcp_experiments <- hcp$experiments()
head(hcp_experiments)
       project subject                  ID                type      label age
1 HCP_Subjects  100206 ConnectomeDB_E13304  xnat:mrSessionData  100206_3T  26
2 HCP_Subjects  100307 ConnectomeDB_E03657  xnat:mrSessionData  100307_3T  26
3 HCP_Subjects  100307 ConnectomeDB_E10373 xnat:megSessionData 100307_MEG  NA
4 HCP_Subjects  100408 ConnectomeDB_E03658  xnat:mrSessionData  100408_3T  31
5 HCP_Subjects  100610 ConnectomeDB_E11186  xnat:mrSessionData  100610_3T  26
6 HCP_Subjects  100610 ConnectomeDB_E24170  xnat:mrSessionData  100610_7T  26
```

## Get the complete list of resources for a specific experiment
The scan resources for an experiment can be retrieved using the `get_xnat_experiment_resources` function:

```r
ConnectomeDB_E13304_resources <- hcp$get_xnat_experiment_resources('ConnectomeDB_E13304')
head(ConnectomeDB_E13304_resources[c('Name','URI')])
                                 Name                                                                                                        URI
1            100206_3T_BIAS_BC.nii.gz            /data/experiments/ConnectomeDB_E13304/scans/101/resources/274961/files/100206_3T_BIAS_BC.nii.gz
2          100206_3T_BIAS_32CH.nii.gz          /data/experiments/ConnectomeDB_E13304/scans/102/resources/274962/files/100206_3T_BIAS_32CH.nii.gz
3           100206_3T_T1w_MPR1.nii.gz           /data/experiments/ConnectomeDB_E13304/scans/103/resources/274963/files/100206_3T_T1w_MPR1.nii.gz
4           100206_3T_T2w_SPC1.nii.gz           /data/experiments/ConnectomeDB_E13304/scans/106/resources/274964/files/100206_3T_T2w_SPC1.nii.gz
5 100206_3T_FieldMap_Magnitude.nii.gz /data/experiments/ConnectomeDB_E13304/scans/107/resources/274965/files/100206_3T_FieldMap_Magnitude.nii.gz
6     100206_3T_FieldMap_Phase.nii.gz     /data/experiments/ConnectomeDB_E13304/scans/108/resources/274966/files/100206_3T_FieldMap_Phase.nii.gz
```

## Query the XNAT projects for matching entries
If you are interested just in a subset of subjects/experiments that match a certain criteria you can use the `query_scan_resources` function. Accepted query parameters are:

- subject_ID - subject ID identifier 
- project - the project ID
- age - subject's age
- experiment_ID - experiment ID identifier
- type - type of image scan
- TR - repetition time
- TE - echo time
- TI - inversion time
- flip - flip status
- voxel_res - overall image voxel resolution
- voxel_res_X - voxel X resolution
- voxel_res_Y - voxel Y resolution
- voxel_res_Z - voxel Z resolution
- orientation - image orientation

To retrieve a list of all subject IDs and associated experiment IDs we can use the `query_scan_resources` function. In the example below, we are querying the HCP XNAT database for all subjects belonging the the HCP_500 project with scans taken at age 26.

```r
hcp_500_age_26 <- query_scan_resources(hcp,age='26', project='HCP_500')
head(hcp_500_age_26[c("subject_ID","experiment_ID", "Project", "Age")])
           subject_ID       experiment_ID Project Age
1 ConnectomeDB_S00230 ConnectomeDB_E03657 HCP_500  26
2 ConnectomeDB_S00231 ConnectomeDB_E03664 HCP_500  26
3 ConnectomeDB_S00234 ConnectomeDB_E03684 HCP_500  26
4 ConnectomeDB_S00235 ConnectomeDB_E03690 HCP_500  26
5 ConnectomeDB_S00236 ConnectomeDB_E03694 HCP_500  26
6 ConnectomeDB_S00237 ConnectomeDB_E03988 HCP_500  26
```

## Getting Data: Download a single scan image/resource file
To download a single file we will use the `download_file` function. Using the first `experiment_ID` from the above example, we will get all scan resources associated with it first.

```r
scan_resources <- get_scan_resources(hcp,'ConnectomeDB_E03657')
scan_resources[1,"Name"]
[1] "100307_3T_BIAS_BC.nii.gz"
> scan_resources[1,"URI"]
[1] "/data/experiments/ConnectomeDB_E03657/scans/101/resources/69128/files/100307_3T_BIAS_BC.nii.gz"
```
To download the resource file (100307_3T_BIAS_BC.nii.gz) we will do:

```r
> download_xnat_file(hcp,"/data/experiments/ConnectomeDB_E03657/scans/101/resources/69128/files/100307_3T_BIAS_BC.nii.gz")
[1] "/var/folders/wb/l7jtkdy14f761vm4xr9zxjj80000gn/T//RtmpFfYbQ7/100307_3T_BIAS_BC.nii.gz"
```

## Getting Data: Download a directory of data
To download all the T2w type images from experiment ConnectomeDB_E03657 we will use the `download_xnat_dir` function.

```r
download_xnat_dir(hcp, experiment_ID='ConnectomeDB_E03657',scan_type='T2w', verbose=TRUE)
Downloading: 28 MB     [1] "/var/folders/wb/l7jtkdy14f761vm4xr9zxjj80000gn/T//RtmpFfYbQ7/ConnectomeDB_E03657.zip"


# Session Info
```

```r
devtools::session_info()
```

```
─ Session info ───────────────────────────────────────────────────────────────
 setting  value                       
 version  R version 4.0.2 (2020-06-22)
 os       macOS Catalina 10.15.7      
 system   x86_64, darwin17.0          
 ui       X11                         
 language (EN)                        
 collate  en_US.UTF-8                 
 ctype    en_US.UTF-8                 
 tz       America/New_York            
 date     2021-02-18                  

─ Packages ───────────────────────────────────────────────────────────────────
 package     * version  date       lib source                            
 assertthat    0.2.1    2019-03-21 [2] CRAN (R 4.0.0)                    
 bitops        1.0-6    2013-08-17 [2] CRAN (R 4.0.0)                    
 cachem        1.0.4    2021-02-13 [1] CRAN (R 4.0.2)                    
 callr         3.5.1    2020-10-13 [1] CRAN (R 4.0.2)                    
 cli           2.3.0    2021-01-31 [1] CRAN (R 4.0.2)                    
 colorout    * 1.2-2    2020-06-01 [2] Github (jalvesaq/colorout@726d681)
 crayon        1.4.1    2021-02-08 [1] CRAN (R 4.0.2)                    
 desc          1.2.0    2020-06-01 [2] Github (muschellij2/desc@b0c374f) 
 devtools      2.3.2    2020-09-18 [1] CRAN (R 4.0.2)                    
 digest        0.6.27   2020-10-24 [1] CRAN (R 4.0.2)                    
 ellipsis      0.3.1    2020-05-15 [2] CRAN (R 4.0.0)                    
 evaluate      0.14     2019-05-28 [2] CRAN (R 4.0.0)                    
 fastmap       1.1.0    2021-01-25 [1] CRAN (R 4.0.2)                    
 fs            1.5.0    2020-07-31 [2] CRAN (R 4.0.2)                    
 glue          1.4.2    2020-08-27 [1] CRAN (R 4.0.2)                    
 htmltools     0.5.1.1  2021-01-22 [1] CRAN (R 4.0.2)                    
 httr          1.4.2    2020-07-20 [2] CRAN (R 4.0.2)                    
 knitr         1.31     2021-01-27 [1] CRAN (R 4.0.2)                    
 lifecycle     1.0.0    2021-02-15 [1] CRAN (R 4.0.2)                    
 magrittr      2.0.1    2020-11-17 [1] CRAN (R 4.0.2)                    
 memoise       2.0.0    2021-01-26 [1] CRAN (R 4.0.2)                    
 pillar        1.4.7    2020-11-20 [1] CRAN (R 4.0.2)                    
 pkgbuild      1.2.0    2020-12-15 [1] CRAN (R 4.0.2)                    
 pkgconfig     2.0.3    2019-09-22 [2] CRAN (R 4.0.0)                    
 pkgload       1.1.0    2020-05-29 [2] CRAN (R 4.0.0)                    
 prettyunits   1.1.1    2020-01-24 [2] CRAN (R 4.0.0)                    
 processx      3.4.5    2020-11-30 [1] CRAN (R 4.0.2)                    
 ps            1.5.0    2020-12-05 [1] CRAN (R 4.0.2)                    
 purrr         0.3.4    2020-04-17 [2] CRAN (R 4.0.0)                    
 R6            2.5.0    2020-10-28 [1] CRAN (R 4.0.2)                    
 RCurl         1.98-1.2 2020-04-18 [2] CRAN (R 4.0.0)                    
 remotes       2.2.0    2020-07-21 [2] CRAN (R 4.0.2)                    
 rlang         0.4.10   2020-12-30 [1] CRAN (R 4.0.2)                    
 rmarkdown     2.6      2020-12-14 [1] CRAN (R 4.0.2)                    
 rprojroot     2.0.2    2020-11-15 [1] CRAN (R 4.0.2)                    
 rstudioapi    0.13     2020-11-12 [1] CRAN (R 4.0.2)                    
 Rxnat       * 1.0.14   2020-10-15 [1] Github (adigherman/Rxnat@14a60c1) 
 sessioninfo   1.1.1    2018-11-05 [2] CRAN (R 4.0.0)                    
 stringi       1.5.3    2020-09-09 [1] CRAN (R 4.0.2)                    
 stringr       1.4.0    2019-02-10 [2] CRAN (R 4.0.0)                    
 testthat      3.0.2    2021-02-14 [1] CRAN (R 4.0.2)                    
 tibble        3.0.6    2021-01-29 [1] CRAN (R 4.0.2)                    
 usethis       2.0.1    2021-02-10 [1] CRAN (R 4.0.2)                    
 vctrs         0.3.6    2020-12-17 [1] CRAN (R 4.0.2)                    
 withr         2.4.1    2021-01-26 [1] CRAN (R 4.0.2)                    
 xfun          0.21     2021-02-10 [1] CRAN (R 4.0.2)                    
 yaml          2.2.1    2020-02-01 [2] CRAN (R 4.0.0)                    

[1] /Users/johnmuschelli/Library/R/4.0/library
[2] /Library/Frameworks/R.framework/Versions/4.0/Resources/library
```

# References
