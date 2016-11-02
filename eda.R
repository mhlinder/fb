
library(magrittr)
library(dplyr)

library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

## rootdir <- "/home/mlinder/research/fitbit"
rootdir <- "/Users/henry/Dropbox/Programming/active/fitbit"
load(file.path(rootdir, "data/2016-10-30.Rdata"))

steps <- out$daily$steps
T <- nrow(steps)

fit1 <- arima(steps$steps, c(1, 0, 0))

indata <- list(T = nrow(steps)-1,
               x0 = steps$steps[1],
               x = steps$steps[-1])

fit2 <- stan(file = file.path(rootdir, "ar1.stan"),
             data = indata,
             iter = 5000,
             chains = 1)

plot(indata$x, type = "b", main = "An AR(1) is not a good model for this data")
steps$fitted <- NA
alpha <- get_posterior_mean(fit2, pars = "alpha")
phi <- get_posterior_mean(fit2, pars = "phi")
for (t in 2:T) {
    steps$fitted[t] <- alpha + phi*steps$steps[t-1]
}
points(steps$fitted[-1])
lines(steps$fitted[-1])

