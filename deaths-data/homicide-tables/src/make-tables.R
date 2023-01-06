#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/deaths-data/homicide-tables/src/make-tables.R

# ----- setup

pacman::p_load(argparse, here, readr, dplyr, purrr, glue, janitor, stringr)

parser <- ArgumentParser()
parser$add_argument("--import_stub",
                    default = here::here("deaths-data/import/output"))
parser$add_argument("--cod_mapping",
                    default = "hand/cod-mapping.csv")
parser$add_argument("--output")

args <- parser$parse_args()

# ----- functions


# input is the file path of one year of death certificate data
read_file <- function(input_file) {

    def_data <- read_delim(input_file, delim = "|", guess_max = 5000) %>%
        janitor::clean_names() %>%
        mutate(ent_ocurr = str_pad(ent_ocurr, 3, "left", "0"),
               mun_ocurr = str_pad(mun_ocurr, 3, "left", "0")) %>%
        select(ent_ocurr, mun_ocurr, causa_def, anio_ocur, mes_ocurr)

    return(def_data)

}


# ----- main

cod_mapping <- read_delim(args$cod_mapping)
homicide_codes <- cod_mapping %>%
    filter(cod_group == "Homicides")

# collect all death certificate file paths
years <- 2000:2020
input_files <- glue("{args$import_stub}/DEFUN{years}.csv")

# read in and concatenate records from all files
deaths_data <- map_dfr(input_files, read_file)

# TODO: address: missing years? (currently filtering out) missing months? missing entidades? missing munis?
tmp <- deaths_data %>% filter(causa_def %in% homicide_codes$causa_def)
tmp %>% filter(ent_ocurr == 99 | mun_ocurr == 999 | mes_ocurr == 99 | anio_ocur == 9999)
# records with any missing values make up <2% of all records

homicide_deaths <- deaths_data %>%
    # filter out deaths that occurred outside of time period or are missing year information
    filter(between(anio_ocur, 2000, 2020)) %>%
    # filter out deaths that occurred outside of Mexico
    filter(!(ent_ocurr %in% c(33, 34, 35))) %>%
    # filter out deaths with non-homicide ICD codes
    filter(causa_def %in% homicide_codes$causa_def) %>%
    group_by(ent_ocurr, mun_ocurr, anio_ocur, mes_ocurr) %>%
    summarize(deaths = n()) %>%
    ungroup()

homicide_deaths %>%
    glimpse() %>%
    write_delim(args$output, delim = "|")

# done.
