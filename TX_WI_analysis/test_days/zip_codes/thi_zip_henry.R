#Gauravs script to grab the average THI values

# -----------------------------
# THI Calculation Pipeline (Batched by Station-Day)
# For final_testdays.txt + uszips.csv on Linux
# -----------------------------

# -----------------------------
# STEP 0: Load required packages
# -----------------------------
install.packages("riem")
install.packages("dplyr")
install.packages("tidyverse")
install.packages("lubridate")
install.packages("ggmap")


library(riem)
library(dplyr)
library(readr)
library(geosphere)
library(lubridate)


