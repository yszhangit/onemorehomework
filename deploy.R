library(rsconnect)
library(openintro)

data("countyComplete")
dat <- countyComplete[,c("state","name","pop2000","pop2010",
                         "home_ownership","median_household_income","median_val_owner_occupied",
                         "white","black","asian","hispanic",
                         "foreign_born","foreign_spoken_at_home",
                         "poverty","mean_work_travel"
                         )]

# assuming NA response is zero
dat[is.na(dat)] <- 0

# get list of stats and add "all" at beginning
# states <- c("ALL",as.character(unique(dat$state)))

# percentage of population change
dat$popchgpct <- round((dat$pop2010-dat$pop2000)/dat$pop2000*100,2)

# percentage of income over house value
dat$income_housevalue_pct <- round(dat$median_household_income/dat$median_val_owner_occupied*100,2)

# combain other races
dat$other_race <- round(100 - dat$white - dat$black - dat$hispanic - dat$asian, 2)
# census error
dat[dat$other_race < 0, "other_race"] <- 0

# re-order columns
dat <- dat[c(1,2,3,4,16,5,6,7,17,8,9,10,11,18,12,13,14,15)]
# rename columns
colnames(dat) <- c("state","county","population_2000","population_2010","population_change",
                   "home_ownership_pct","median_household_income",
                   "median_house_value","income_to_house_value_pct",
                   "white_pct","black_pct","asian_pct","hispanic_pct","other_race_pct",
                   "foreign_born_pct","foreign_language_spoken_at_home_pct",
                   "mean_work_travel_distance","poverty"
)

saveRDS(dat, file = 'us_counties.rds')

rsconnect::setAccountInfo(name='yszhangit',
  token='466E6D5371CC20BBA371CE772B24F19A',
  secret=)


rsconnect::deployApp( "C:/Users/zhang/Desktop/R/onemorehomework" )
