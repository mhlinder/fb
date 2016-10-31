
library(magrittr)
library(dplyr)

basedir <- "/home/mlinder/research/fitbit"
load(file.path(basedir, "data/2016-10-30.Rdata"))

out$activity <-
  out$activity %>%
  tbl_df

