
library(magrittr)
library(dplyr)

library(rstan)

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

## rootdir <- "/home/mlinder/research/fitbit"
rootdir <- "/Users/henry/Dropbox/Programming/active/fitbit"
load(file.path(rootdir, "data/2016-10-30.Rdata"))

steps <- out$daily$steps

indata <- list(T = nrow(steps)-1,
               x0 = steps$steps[1],
               x = steps$steps[-1])

fit <- stan(file = file.path(rootdir, "ar1.stan"),
            data = indata,
            iter = 5000,
            chains = 1)

plot(indata$x)
lines(indata$x)

plot(get_posterior_mean(fit, pars = "mu"))
lines(get_posterior_mean(fit, pars = "mu"))

