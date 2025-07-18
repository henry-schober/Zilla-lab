#Gauravs script to grab the average THI values

# -----------------------------
# THI Calculation Pipeline (Batched by Station-Day)
# For final_testdays.txt + uszips.csv on Linux
# -----------------------------

# -----------------------------
# STEP 0: Load required packages
# -----------------------------
packages <- c("dplyr", "readr", "geosphere", "lubridate", "riem", "purrr")
installed <- rownames(installed.packages())
to_install <- packages[!packages %in% installed]
if (length(to_install)) install.packages(to_install)
lapply(packages, library, character.only = TRUE)
install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}
install_if_missing("riem")
install_if_missing("dplyr")
install_if_missing("readr")
install_if_missing("geosphere")
install_if_missing("lubridate")

library(riem)
library(dplyr)
library(readr)
library(geosphere)
library(lubridate)


# -----------------------------
# STEP 1: Load final test day data
# -----------------------------
testday_data <- read.table("mgm_zips_all", header = FALSE,
                           col.names = c("HERD_CODE", "ZIP_CODE", "HERD_TESTDAY", "TESTDAY"),
                           colClasses = c("character", "character", "character"))

# Clean ZIP codes
#testday_data <- testday_data %>%
#  mutate(ZIP_CODE = substr(ZIP_CODE, 1, 5),
#         ZIP_CODE = sprintf("%05s", ZIP_CODE))

# -----------------------------
# STEP 2: Load ZIP to lat/lon data (e.g., uszips.csv)
# -----------------------------
library(readr)
library(dplyr)

zip_latlon_raw <- read_delim("uszips.csv", delim = "\t", show_col_types = FALSE)

if ("zip" %in% names(zip_latlon_raw)) {
  zip_latlon <- zip_latlon_raw %>%
    rename(ZIP_CODE = zip) %>%
    select(ZIP_CODE, lat, lng) %>%
    filter(!is.na(lat), !is.na(lng)) %>%
    mutate(lat = as.numeric(lat), lng = as.numeric(lng))
} else {
  stop("ZIP column not found in uszips.csv")
}

zip_latlon_unique <- zip_latlon %>%
  distinct(ZIP_CODE, .keep_all = TRUE)

# Join lat/lon to test day data

testday_coords <- testday_data %>%
  inner_join(zip_latlon_unique, by = "ZIP_CODE")


# -----------------------------
# STEP 3: Load ASOS weather stations
# -----------------------------
stations <- bind_rows(
  riem_stations("WI_ASOS"),
  riem_stations("TX_ASOS")
) %>%
  filter(!is.na(latitude), !is.na(longitude)) %>%
  select(station_id = id, latitude, longitude)

# -----------------------------
# STEP 4: Find nearest station for each testday location
# -----------------------------
assign_nearest_station <- function(lat, lon) {
  distances <- geosphere::distHaversine(c(lon, lat), stations[, c("longitude", "latitude")])
  stations$station_id[which.min(distances)]
}

testday_coords <- testday_coords %>%
  mutate(station = purrr::map2_chr(lat, lng, assign_nearest_station))
testday_coords <- testday_coords %>%
  mutate(TESTDAY = as.Date(TESTDAY, format = "%Y%m%d"))


# -----------------------------
# STEP 5: Get unique station-day pairs
# -----------------------------
station_day_pairs <- testday_coords %>%
  distinct(station, TESTDAY) %>%
  mutate(TESTDAY = as.character(TESTDAY))

# STEP 6: Function to download weather + calculate THI
# -----------------------------
get_thi_for_station_day <- function(station_id, date) {
  cat("🔍 Fetching:", station_id, "on", as.character(date), "\n")

  tryCatch({
    weather <- riem_measures(
      station = station_id,
      date_start = date,
      date_end = date
    )

    if (nrow(weather) == 0 || !all(c("tmpf", "relh") %in% colnames(weather))) {
      cat("⚠️ No usable data for", station_id, date, "\n")
      return(NULL)
    }

    thi_summary <- weather %>%
      filter(!is.na(tmpf), !is.na(relh)) %>%
      mutate(date = as.Date(valid)) %>%
      group_by(date) %>%
      summarise(
        avg_temp = mean(tmpf, na.rm = TRUE),
        avg_humidity = mean(relh, na.rm = TRUE),
        avg_thi = avg_temp - ((0.55 - 0.0055 * avg_humidity) * (avg_temp - 58)),
        .groups = "drop"
      ) %>%
      mutate(
        station = station_id,
        TESTDAY = as.character(date)
      ) %>%
      select(station, TESTDAY, avg_temp, avg_humidity, avg_thi)

    return(thi_summary)
  }, error = function(e) {
    cat("❌ Error for", station_id, date, ":", conditionMessage(e), "\n")
    return(NULL)
  })
}

safe_thi <- purrr::possibly(get_thi_for_station_day, otherwise = NULL)

# -----------------------------
# STEP 7: Download weather for all station-day pairs
# -----------------------------
station_weather <- purrr::pmap_dfr(
  list(station_day_pairs$station, station_day_pairs$TESTDAY),
  safe_thi
)

station_weather <- station_weather %>%
  mutate(TESTDAY = as.Date(TESTDAY))


# -----------------------------
# STEP 8: Merge weather data back into testday records
# -----------------------------
final_result <- testday_coords %>%
  left_join(station_weather, by = c("station", "TESTDAY"))

# -----------------------------
# STEP 9: Save results
# -----------------------------
write_csv(final_result, "final_testdays_with_thi.csv")
cat("\n✅ Done! Results saved to final_testdays_with_thi_csv\n")
