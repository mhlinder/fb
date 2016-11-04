
library(magrittr)
library(dplyr)

library(lubridate)

library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

## rootdir <- "/home/mlinder/research/fitbit"
rootdir <- "/Users/henry/Dropbox/Programming/active/fitbit"
load(file.path(rootdir, "data/2016-11-01.Rdata"))

steps <-
    out$daily$steps %>%
    mutate(dow = as.factor(wday(steps$time)))

indata <- list(N = nrow(steps),
               y = steps$steps,
               k = length(levels(steps$dow)),
               X = model.matrix(~ dow, data = steps))

fit2 <- stan(file = file.path(rootdir, "2016-11-01-anova.stan"),
             data = indata,
             chains = 1, iter = 5000)


## Posterior probability that tau (effect size for day of week,
## relative to Sunday) is larger than 0. Under the null hypothesis
## H0: tau[2]=...=tau[k]=0, this should be .5
draws <- extract(fit2)
(draws$tau[,-1] > 0) %>% colMeans

## But does it contradict an ANOVA?
lm(steps ~ dow, steps) %>%
    summary
