#new Rscript to grab weather data from our data


#install.packages("lubridate")
#install.packages("ggplot2")
#install.packages("riem")
#install.packages("tidyverse")
library(tidyverse)
library(lubridate)
library(riem)


willi<-riem_measures("IJD", date_start = "2022-01-01",date_end = "2023-01-01") 
#label the weather data
willi

willi1 <- willi %>% select(valid,tmpf,relh,station) %>% na.omit() %>% 
  mutate(day=ymd_hms(valid)) %>% 
  mutate(day1=day(day),month1=month(day),year1=year(day)) %>%
  mutate(date1=ymd(paste(year1,month1,day1,sep="-"))) %>%
  group_by(date1) %>%
  summarise(temp=max(tmpf),hum=max(relh),station=station[1])

willi2 <- willi1 %>%  mutate(thi=temp-(0.55-(0.0055*hum))*(temp-58)) #double check thi formula  # nolint
#then calculate the heat load. Do that for every farm in your data
willi2
