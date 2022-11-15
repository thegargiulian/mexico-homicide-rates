# TODO: add header

# ----- setup

pacman::p_load(argparse, here, readr, dplyr, purrr)

parser <- ArgumentParser()
parser$add_argument("--census_2000",
                    default = here::here("census-data/import-muni/output/census-2000.csv"))
parser$add_argument("--census_2010",
                    default = here::here("census-data/import-muni/output/census-2010.csv"))
parser$add_argument("--census_2020",
                    default = here::here("census-data/import-muni/output/census-2020.csv"))

args <- parser$parse_args()

# ----- main

census_2000 <- read_delim(args$census_2000, delim = "|") %>%
    select(total_pop, ent_mun) %>%
    rename(total_pop_2000 = total_pop)
census_2010 <- read_delim(args$census_2010, delim = "|") %>%
    select(total_pop, ent_mun) %>%
    rename(total_pop_2010 = total_pop)
census_2020 <- read_delim(args$census_2020, delim = "|") %>%
    select(total_pop, ent_mun) %>%
    rename(total_pop_2020 = total_pop)

census_data <- list(census_2000, census_2010, census_2020) %>%
    reduce(., full_join, by = "ent_mun") %>%
    select(ent_mun, everything())

# TODO: actually address these changes rather than ignoring them
census_data <- census_data %>%
    filter(!is.na(total_pop_2000) & !is.na(total_pop_2010) & !is.na(total_pop_2020))

# TODO: setup interpolation here to get monthly pops for each muni between census years


# done.
