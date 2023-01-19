#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/census-data/import-muni/src/import-inegi-2000.R

# ----- setup

if (!require(pacman)) {install.packages("pacman")}

pacman::p_load(argparse, dplyr, readr, assertr)

parser <- ArgumentParser()
parser$add_argument("--input", default = "input/cgpv2000_iter_00.csv")
# retrieved using https://www.inegi.org.mx/programas/ccpv/2000/#Datos_abiertos
# download data for Estados Unidos Mexicanos
parser$add_argument("--output")

args <- parser$parse_args()

# ----- main

inegi_data <- read_csv(args$input)

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
