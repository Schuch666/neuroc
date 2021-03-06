## ----setup, include=FALSE-----------------------------------------------------
library(neurohcp)
library(dplyr)
knitr::opts_chunk$set(echo = TRUE, cache = FALSE, comment = "")
if (!is.na(Sys.getenv("HCP_AWS_ACCESS_KEY_ID", unset = NA))) {
  Sys.setenv(AWS_ACCESS_KEY_ID = Sys.getenv("HCP_AWS_ACCESS_KEY_ID"))
  Sys.setenv(AWS_SECRET_ACCESS_KEY = Sys.getenv("HCP_AWS_SECRET_ACCESS_KEY"))
}


## ---- eval = FALSE------------------------------------------------------------
## source("http://neuroconductor.org/neurocLite.R")
## neuro_install("neurohcp", release = "stable")


## ----blist_show, eval = FALSE-------------------------------------------------
## neurohcp::bucketlist(sign = FALSE)


## ----blist_go, echo = FALSE---------------------------------------------------
neurohcp::bucketlist(verbose = FALSE, sign = FALSE)


## ---- eval = TRUE-------------------------------------------------------------
ids_with_dwi = hcp_900_scanning_info %>% 
  filter(scan_type %in% "dMRI") %>% 
  select(id) %>% 
  unique
head(ids_with_dwi)


## ---- eval = FALSE, echo = TRUE-----------------------------------------------
## r = download_hcp_dir("HCP/100307/T1w/Diffusion", verbose = FALSE)
## print(basename(r$output_files))

## ---- eval = TRUE, echo = FALSE-----------------------------------------------
r = list(output_files = c("bvals", "bvecs", "data.nii.gz", "grad_dev.nii.gz", "nodif_brain_mask.nii.gz")
)
r$output_files


## ---- eval = FALSE------------------------------------------------------------
## ids_with_dwi = ids_with_dwi %>%
##   mutate(id_dir = paste0("HCP/", id, "/T1w/Diffusion"))


## ----dl_file------------------------------------------------------------------
ret = download_hcp_file("HCP/100307/T1w/Diffusion/bvals", verbose = FALSE)


## -----------------------------------------------------------------------------
devtools::session_info()

