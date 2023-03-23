#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/code/homicide-rates/src/muni-calculate.R

# ----- setup

if (!require(pacman)) {install.packages("pacman")}

pacman::p_load(argparse, here, dplyr, readr, tidyr, lubridate, assertr, stringr)

parser <- ArgumentParser()
parser$add_argument("--homicides_data",
                    default = here::here("code/deaths-data/homicide-counts/output/muni-month-homicides-2000-2021.csv"))
parser$add_argument("--population_estimates",
                    default = here::here("code/census-data/interpolate/output/population-estimates.csv"))
parser$add_argument("--output",
                    default = "output/mexico-state-month-homicide-rates-2000-2021.csv")

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

homicides <- read_delim(args$homicides_data, delim = "|")

total_homicides <- sum(homicides$homicides)

homicides <- homicides %>%
    group_by(cve_ent, year, month) %>%
    summarize(homicides = sum(homicides)) %>%
    verify(sum(homicides) == total_homicides) %>%
    ungroup()

population <- read_delim(args$population_estimates, delim = "|") %>%
    mutate(cve_ent = str_sub(ent_mun, 1, 2)) %>%
    select(-ent_mun, -month, -day, -est_date)

total_population <- sum(population$pop_est)

population <- population %>%
    group_by(year, cve_ent) %>%
    summarize(pop_est = sum(pop_est)) %>%
    verify(sum(pop_est) == total_population) %>%
    ungroup()

# start by creating a grid with all states and months between January
# 2000 and December 2021
states <- union(homicides$cve_ent, population$cve_ent)
months <- seq(ym("200001"), ym("202112"), by = "month")

homicide_rates <- crossing(states, months) %>% # expand grid
    mutate(year = as.numeric(year(months)),
           month = as.numeric(month(months))) %>%
    select(-months, cve_ent = states) %>%
    # join homicide data to grid
    left_join(homicides, by = c("cve_ent", "year", "month")) %>%
    # if no recorded homicides replace NA with 0
    mutate(homicides = replace_na(homicides, 0)) %>%
    # join mid-year population estimates to grid
    left_join(population, by = c("cve_ent", "year")) %>%
    # join months df, which has the info on the # of days in each month
    left_join(months_data, by = "month") %>%
    # calculate rate per 100,000 population
    mutate(homicide_rate = (homicides / ((pop_est / 365.25) * n_days)) * 100000) %>%
    select(-n_days)

homicide_rates %>%
    glimpse() %>%
    write_delim(args$output, delim = "|")

# done.
