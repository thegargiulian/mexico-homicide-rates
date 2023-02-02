#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/code/census-data/import/src/import-inegi.R

# ----- setup

if (!require(pacman)) {install.packages("pacman")}

pacman::p_load(here, argparse, dplyr, janitor, readr, assertr)

parser <- ArgumentParser()
parser$add_argument("--input")
parser$add_argument("--output")

args <- parser$parse_args()

# ----- main

inegi_data <- read_csv(args$input) %>%
    clean_names()

inegi_data_total <- inegi_data %>%
    filter(loc == "0000" & nom_ent == "Total nacional") %>%
    pull(pobtot)

inegi_muni_pop <- inegi_data %>%
    filter(loc == "0000" & nom_ent != "Total nacional" & mun != "000") %>%
    select(cve_ent = entidad, cve_mun = mun, total_pop = pobtot) %>%
    mutate(ent_mun = paste0(cve_ent, cve_mun)) %>%
    verify(sum(total_pop) == inegi_data_total)

glimpse(inegi_muni_pop) %>%
    write_delim(args$output, delim = "|")

# done.
