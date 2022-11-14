#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/census-data/import/src/import-ipums.R

# ----- setup

if (!require(pacman)) {install.packages("pacman")}

pacman::p_load(argparse, here, dplyr, readr, stringr)

parser <- ArgumentParser()
parser$add_argument("--input", default = "input/ipumsi_00010.csv")
parser$add_argument("--output")

args <- parser$parse_args()

# ----- main

# TODO: make this reproducible using IPUMS API tools
# see here https://blog.popdata.org/reproducible-research-r-markdown-ipumsr-ipums-api/
ipums_data <- read_csv(args$input)

ipums_muni_pop <- ipums_data %>%
    group_by(GEOLEV2) %>%
    summarize(total_pop = sum(PERWT),
              year = YEAR) %>%
    ungroup() %>%
    mutate(cve_ent = str_sub(GEOLEV2, 4, 6),
           cve_mun = str_sub(GEOLEV2, 7, 9)) %>%
    select(-GEOLEV2)

glimpse(ipums_muni_pop) %>%
    write_delim(args$output, delim = "|")

# done.
