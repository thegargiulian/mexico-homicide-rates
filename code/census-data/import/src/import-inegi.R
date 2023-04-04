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

if (all(c("pmascul", "pfemeni") %in% names(inegi_data))) {
    
    inegi_data <- inegi_data %>%
        rename(pobmas = pmascul, pobfem = pfemeni)
    
}

inegi_data_total <- inegi_data %>%
    filter(loc == "0000" & nom_ent == "Total nacional") %>%
    pull(pobtot)

inegi_state_pop <- inegi_data %>%
    filter(loc == "0000" & nom_ent != "Total nacional" & mun == "000") %>%
    select(cve_ent = entidad, cve_mun = mun,
           total_pop = pobtot, total_f = pobfem, total_m = pobmas) %>%
    mutate(ent_mun = paste0(cve_ent, cve_mun),
           total_f = as.numeric(total_f),
           total_m = as.numeric(total_m)) %>%
    verify(sum(total_pop) == inegi_data_total)

glimpse(inegi_state_pop) %>%
    write_delim(args$output, delim = "|")

# done.
