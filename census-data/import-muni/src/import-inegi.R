#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/census-data/import-muni/src/import-inegi.R

# ----- setup

if (!require(pacman)) {install.packages("pacman")}

pacman::p_load(argparse, dplyr, readr, stringr, tidyr, magrittr, assertr)

parser <- ArgumentParser()
parser$add_argument("--input", default = "input/INEGI_exporta_13_11_2022_13_30_50.csv")
# retrieved using https://www.inegi.org.mx/sistemas/Olap/Proyectos/bd/censos/cpv2020/pt.asp
parser$add_argument("--output")

args <- parser$parse_args()

# ----- main

inegi_data <- read_csv(args$input, skip = 7, locale = readr::locale(encoding = "latin1")) %>%
    set_names(c("mun_code", "mun_name", "total_pop", "hombres", "mujeres")) %>%
    mutate(cve_ent = str_pad(str_sub(mun_code, 1, 2), 3, "left", "0"),
           cve_mun = str_sub(mun_code, 4, 6)) %>%
    select(-mun_code) %>%
    mutate(ent_mun = paste0(cve_ent, cve_mun))

n_original <- nrow(inegi_data)

inegi_data <- inegi_data %>%
    filter(!is.na(total_pop)) %>% # filter out garbage line at end of file
    verify(nrow(.) == n_original - 1)

# make sure that file has all muni data it should have
inegi_data_total <- inegi_data %>%
    filter(is.na(cve_mun)) %>%
    pull(total_pop)

# filter out state level columns
inegi_muni_pop <- inegi_data  %>%
    filter(nchar(cve_mun) == 3)

inegi_muni_pop %>%
    summarize(sum = sum(total_pop)) %>%
    verify(sum == inegi_data_total)

glimpse(inegi_muni_pop) %>%
    write_delim(args$output, delim = "|")

# done.
