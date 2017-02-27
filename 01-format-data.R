
## * `in_T` is number of time points to include
## * The variable `x` is `out$intraday`

in_T <- 159

## rootdir <- "~/research/fitbit"
rootdir <- "~/Dropbox/Programming/active/fitbit"
datadir <- file.path(rootdir, "data")

library(magrittr)
library(dplyr)

ma <- function(x, p, wts = NULL) {
    n <- length(x)
    width <- 2*p + 1

    if (n < width)
        stop("Cannot calculate moving average for the specified window.")

    if (is.null(wts))
        wts <- rep(1/width, width)

    if (length(wts) != width)
        stop("The specified weights do not match the window width.")

    stats::filter(x, wts)
}

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

bpm <-
    sapply(x, function(x)
        x$`heart-rate` %>%
        filter(confidence != -1) %>%
        use_series(bpm) %>%
        mean)

plot(1:T, bpm, type = "n")
lines(bpm, col = "black")
lines(ma(bpm, 3), col = "red", lwd = 2)

