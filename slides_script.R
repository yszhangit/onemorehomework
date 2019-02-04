# envaluate urbnmapr
'
#devtools::install_github("UrbanInstitute/urbnmapr")
library(urbnmapr)
library(dplyr)
#library(ggplot2)
library(tidyverse)

states %>%
  ggplot(aes(long, lat, group = group)) +
  geom_polygon(fill = "grey", color = "#ffffff", size = 0.25) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45)

# more examples at https://medium.com/@urban_institute/how-to-create-state-and-county-maps-easily-in-r-577d29300bb2

'

dat <- readRDS('us_counties.rds')
#states <- as.character(unique(dat$state))

dat <- dat[dat$population_2010 > 1000, ]

#va <- dat[dat$state == 'Virginia',
#          c("white","black","asian","hispanic","other_race",
#            "median_household_income","mean_work_travel_distance")]

# color is not very informational
#va <- va %>% mutate( race_color = 
#                 white * 15 + black * 255 + asian * 4095 + hispanic * 65535 + other_race * 1048576
#               )

g1 <- ggplot(dat, aes(x=median_household_income/1000, y=mean_work_travel_distance)) +
  geom_point(alpha = 0.25) +
  geom_smooth(method = "loess", se =F) +
  xlim(c(0, max(dat$median_household_income/1000))) +
  labs(x="Median Household Income(K)",
       y="Mean Work Tracel Distance")
g1

g2 <- ggplot(dat, aes(x=foreign_language_spoken_at_home_pct, y=median_household_income/1000)) +
  geom_point(alpha = 0.25) +
  geom_smooth(method = "auto", se =F) +
  labs(y="Median Household Income(K)",
       x="Foreign Language Spoken At Home %")
g2

g3 <- ggplot(dat, aes(x=population_change, y=median_household_income/1000)) +
  geom_point(alpha = 0.25) +
  ylim(c(0, max(dat$median_household_income/1000)))
g3
