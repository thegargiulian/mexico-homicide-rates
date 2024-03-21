#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/code/homicide-rates/src/muni-calculate.R

# ----- setup

if (!require(pacman)) {install.packages("pacman")}

pacman::p_load(argparse, here, dplyr, readr, tidyr, lubridate)

parser <- ArgumentParser()
parser$add_argument("--homicides_data",
                    default = here::here("code/deaths-data/homicide-counts/output/muni-month-homicides-2000-2022.csv"))
parser$add_argument("--population_estimates",
                    default = here::here("code/census-data/interpolate/output/population-estimates.csv"))
parser$add_argument("--output",
                    default = "output/mexico-muni-month-homicide-rates-2000-2022.csv")

args <- parser$parse_args()

# ----- constants

months_data <- tribble(~month, ~n_days,
                       1, 31,
                       2, 28,
                       3, 31,
                       4, 30,
                       5, 31,
                       6, 30,
                       7, 31,
                       8, 31,
                       9, 30,
                       10, 31,
                       11, 30,
                       12, 31)

# ----- main

homicides <- read_delim(args$homicides_data, delim = "|") %>%
    select(-cve_mun, -cve_ent)

population <- read_delim(args$population_estimates, delim = "|") %>%
    select(-month, -day, -est_date)

# start by creating a grid with all municipalities and months between January
# 2000 and December 2022
munis <- union(homicides$ent_mun, population$ent_mun)
months <- seq(ym("200001"), ym("202212"), by = "month")

homicide_rates <- crossing(munis, months) %>% # expand grid
    mutate(year = as.numeric(year(months)),
           month = as.numeric(month(months))) %>%
    select(-months, ent_mun = munis) %>%
    # join homicide data to grid
    left_join(homicides, by = c("ent_mun", "year", "month")) %>%
    # if no recorded homicides replace NA with 0
    mutate(homicides = replace_na(homicides, 0)) %>%
    # join mid-year population estimates to grid
    left_join(population, by = c("ent_mun", "year")) %>%
    # join months df, which has the info on the # of days in each month
    left_join(months_data, by = "month") %>%
    # calculate rate per 100,000 population
    mutate(homicide_rate = (homicides / ((pop_est / 365.25) * n_days)) * 100000) %>%
    select(-n_days)

homicide_rates %>%
    glimpse() %>%
    write_delim(args$output, delim = "|")

# done.
