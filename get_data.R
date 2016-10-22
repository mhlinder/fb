
library(magrittr)
library(dplyr)

library(fitbitScraper)

dirpath <- "/home/mlinder/research/fitbit"

start <- "2016-09-22"
start_date <- as.Date(start, "%Y-%m-%d")
today_date <- Sys.Date()
today <- format(today_date, "%Y-%m-%d")


## Provides user, pass
source("secret.R")

l <- login(user, pass)

out <- list()

print("Fetching activity data...")
out$activity <- get_activity_data(l, today)

print("Fetching daily data...")
out$daily <- list()
for (v in c("steps", "distance", "floors", "minutesVery", "caloriesBurnedVsIntake", "getTimeInHeartRateZonesPerDay")) {
    print(sprintf("  - Fetching %s", v))
    out$daily[[v]] <- get_daily_data(l, v, start, today)
}

print("Fetching intraday data...")
out$intraday <- list()
daylist <- as.character(seq(start_date, today_date, 1))
for (d in daylist) {
    print(sprintf("  - %s", d))

    tmp <- list()
    for (v in c("steps", "distance", "floors", "active-minutes", "calories-burned", "heart-rate")) {
        print(sprintf("      - Fetching %s", v))
        tmp[[v]] <- get_intraday_data(l, v, d)
    }

    out$intraday[[d]] <- tmp
}

print("Fetching sleep data...")
out$sleep <- get_sleep_data(l, start, today)

print("Fetching weight data...")
out$weight <- get_weight_data(l, start, today)

save(out, file = file.path(dirpath, sprintf("data/%s.Rdata", today)))

