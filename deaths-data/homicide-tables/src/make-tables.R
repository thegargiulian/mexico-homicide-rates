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
        mutate(cve_ent = str_pad(ent_ocurr, 2, "left", "0"),
               cve_mun = str_pad(mun_ocurr, 3, "left", "0"),
               year = anio_ocur,
               month = mes_ocurr) %>%
        select(cve_ent, cve_mun, causa_def, year, month)

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

homicide_deaths <- deaths_data %>%
    # filter out deaths that occurred outside of time period or are missing year information
    filter(between(year, 2000, 2020)) %>%
    # filter out deaths missing month information
    filter(month != 99) %>%
    # filter out deaths that occurred outside of Mexico or are missing state info
    filter(!(cve_ent %in% c("33", "34", "35", "99"))) %>%
    # filter out deaths missing muni information
    filter(cve_mun != "999") %>%
    # filter out deaths with non-homicide ICD codes
    filter(causa_def %in% homicide_codes$causa_def) %>%
    group_by(cve_ent, cve_mun, year, month) %>%
    summarize(homicides = n()) %>%
    ungroup() %>%
    mutate(ent_mun = paste0(cve_ent, cve_mun))

homicide_deaths %>%
    glimpse() %>%
    write_delim(args$output, delim = "|")

# done.
