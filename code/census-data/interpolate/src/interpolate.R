#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/code/census-data/interpolate/src/interpolate.R

# ----- setup

pacman::p_load(argparse, here, readr, dplyr, purrr, lubridate)

parser <- ArgumentParser()
parser$add_argument("--census_2000",
                    default = here::here("code/census-data/import-muni/output/census-2000.csv"))
parser$add_argument("--census_2010",
                    default = here::here("code/census-data/import-muni/output/census-2010.csv"))
parser$add_argument("--census_2020",
                    default = here::here("code/census-data/import-muni/output/census-2020.csv"))
parser$add_argument("--new_munis",
                    default = "output/new-munis.csv")
parser$add_argument("--population_estimates",
                    default = "output/population-estimates.csv")

args <- parser$parse_args()

# ----- functions


interpolation_wrapper <- function(ent) {

    census_2000 <- decimal_date(ymd(20000214))
    census_2010 <- decimal_date(ymd(20100612))
    census_2020 <- decimal_date(ymd(20200318))

    # use 1 July as mid-year date
    mid_years_1 <- seq(ymd(20000701), ymd(20090701), by = "year")
    mid_years_2 <- seq(ymd(20100701), ymd(20220701), by = "year") # apply same slope through 2022

    estimates_1 <- map_dfr(.x = mid_years_1,
                           ~interpolate_population(pop_1 = ent$total_pop_2000,
                                                   pop_2 = ent$total_pop_2010,
                                                   census_1 = census_2000,
                                                   census_2 = census_2010,
                                                   est_date = .x))
    estimates_2 <- map_dfr(.x = mid_years_2,
                           ~interpolate_population(pop_1 = ent$total_pop_2010,
                                                   pop_2 = ent$total_pop_2020,
                                                   census_1 = census_2010,
                                                   census_2 = census_2020,
                                                   est_date = .x))

    bind_rows(estimates_1, estimates_2) %>%
        mutate(ent_mun = ent$ent_mun)

}


interpolate_population <- function(pop_1, pop_2, census_1, census_2, est_date) {

    est_date <- decimal_date(est_date)
    pop_est <- pop_1 + ((est_date - census_1) / census_2) * (pop_2 - pop_1)

    return(tibble(pop_est = pop_est, est_date = est_date))

}


# ----- main

# load and join data
census_2000 <- read_delim(args$census_2000, delim = "|") %>%
    mutate(total_pop_2000 = total_pop) %>%
    select(total_pop_2000, ent_mun)
census_2010 <- read_delim(args$census_2010, delim = "|") %>%
    mutate(total_pop_2010 = total_pop) %>%
    select(total_pop_2010, ent_mun)
census_2020 <- read_delim(args$census_2020, delim = "|") %>%
    mutate(total_pop_2020 = total_pop) %>%
    select(total_pop_2020, ent_mun)

census_data <- list(census_2000, census_2010, census_2020) %>%
    reduce(., full_join, by = "ent_mun") %>%
    select(ent_mun, everything())

# writing munis that don't have population data for all 3 census years to file
census_data %>%
    filter(is.na(total_pop_2000) | is.na(total_pop_2010) | is.na(total_pop_2020)) %>%
    write_delim(args$new_munis, delim = "|")

census_data <- census_data %>%
    filter(!is.na(total_pop_2000) & !is.na(total_pop_2010) & !is.na(total_pop_2020))

# interpolate to get mid-years population estimates for the intercensal period
population_estimates <- census_data %>%
    rowwise() %>%
    group_split() %>%
    map_dfr(interpolation_wrapper) %>%
    mutate(month = month(date_decimal(est_date)),
           year = year(date_decimal(est_date)),
           day = day(date_decimal(est_date)))

population_estimates %>%
    glimpse() %>%
    write_delim(args$population_estimates, delim = "|")

# done.
