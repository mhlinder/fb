
## * `in_T` is number of time points to include
## * The variable `x` is `out$intraday`

in_T <- 30

rootdir <- "~/research/fitbit"
datadir <- file.path(rootdir, "data")

library(magrittr)
library(dplyr)

files <-
    list.files(datadir, full.names = TRUE) %>%
    sort(decreasing = TRUE)
infile <- files[1]

innames <- load(infile)

## Main variable we operate on
x <- out$intraday
days <-
    names(x) %>%
    sort(decreasing = TRUE)
n_days <- length(days)

T <- ifelse(in_T <= n_days, in_T, n_days)

hr <- d$`heart-rate`

bpm <-
    sapply(x, function(x)
        x$`heart-rate` %>%
        filter(confidence != -1) %>%
        use_series(bpm) %>%
        mean)

for (dn in ) {
    d <- x[[dn]]
    bpm[dn,] <-
        hr %>%
        filter(confidence != -1) %>%
        use_series(bpm) %>%
        mean
}

