
library(magrittr)
library(dplyr)

library(readr)
library(lubridate)

library(googlesheets)

expenses <- gs_title("expenses")

df_raw <-
    expenses %>%
    gs_read(skip = 3,
            col_types = "cncc",
            col_names = c("Date", "Value", "What", "X4")) %>%
    select(-X4)

df <-
    df_raw %>%
    filter(grepl("gas", What, ignore.case = TRUE)) %>%
    mutate(Date = parse_date_time(Date, "%m/%d/%Y",
                                  tz = "America/New_York",
                                  exact = TRUE)) %>%
    arrange(Date)

n <- nrow(df)
start <- df$Date[1]
end <- df$Date[n]

years <- year(dates)
if (year(start) == year(end)) {
    year_string <- year(start)
} else {
    year_string <- sprintf("%s-%s", year(start), year(end))
}

dev.off()
plot(x = df$Date, xlab = sprintf("Date (%s)", year_string),
     y = df$Value, ylab = "Purchase price ($)",
     type = "p", ylim = c(0, 50))
## Separate time periods
lines(df$Date[1:6], df$Value[1:6], type = "c")
lines(df$Date[-(1:6)], df$Value[-(1:6)], type = "c")
## Summer vertical lines
abline(v = df$Date[6], lty = 2)
abline(v = df$Date[7], lty = 2)

