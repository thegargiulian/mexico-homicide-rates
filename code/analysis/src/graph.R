#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/code/analysis/code/graph.R

# ----- setup

if (!require(pacman)) {install.packages("pacman")}

pacman::p_load(argparse, here, dplyr, readr, ggplot2, forcats, scales)

parser <- ArgumentParser()
parser$add_argument("--input",
                    default = here::here("code/homicide-rates/output/mexico-state-month-homicide-rates-2000-2021-by-sex.csv"))

args <- parser$parse_args()

# ----- constants

# data from: https://data.worldbank.org/indicator/VC.IHR.PSRC.FE.P5
global_avg_f <- tibble::tribble(~year,   ~homicide_rate,
                                "2000",  2.6386962960574,
                                "2001", 2.67708828494756,
                                "2002", 2.62661848141461,
                                "2003", 2.55378811914471,
                                "2004", 2.53257584204906,
                                "2005", 2.41362974785202,
                                "2006", 2.32651703556606,
                                "2007", 2.30256472410456,
                                "2008", 2.24158634863803,
                                "2009", 2.40061279467747,
                                "2010", 2.36203015967589,
                                "2011", 2.32876597521762,
                                "2012", 2.30620784135384,
                                "2013", 2.24555388173607,
                                "2014", 2.20870187065172,
                                "2015", 2.13767806035832,
                                "2016", 2.15911297373852,
                                "2017", 2.11260876643931,
                                "2018", 2.08960163634562,
                                "2019", 2.04523702195301,
                                "2020", 2.01578630658251,
                                "2021",               NA) %>%
    mutate(sex = "FEMALE")

# data from: https://data.worldbank.org/indicator/VC.IHR.PSRC.FE.P5
global_avg_m <- tibble::tribble(~year,   ~homicide_rate,
                                "2000", 11.0110549839413,
                                "2001", 11.1499515203785,
                                "2002", 11.1233265099687,
                                "2003", 10.8431164321744,
                                "2004", 10.4153336593803,
                                "2005", 10.1140954039187,
                                "2006", 9.96870289189314,
                                "2007", 9.66226994950126,
                                "2008", 9.71630073232799,
                                "2009", 9.67129533255953,
                                "2010", 9.67448065144861,
                                "2011", 9.77532308051983,
                                "2012",  9.8559211622607,
                                "2013",  9.7547509568494,
                                "2014", 9.79131939602512,
                                "2015", 9.62308526381426,
                                "2016", 9.67285483422929,
                                "2017", 9.63740392459714,
                                "2018", 9.39793764708272,
                                "2019", 9.02414372986408,
                                "2020", 9.13447039015946,
                                "2021",               NA) %>%
    mutate(sex = "MALE")

global_averages <- bind_rows(global_avg_f, global_avg_m) %>%
    mutate(cve_ent = "World",
           year = as.numeric(year))

# ----- main

homicide_rates <- read_delim(args$input, delim = "|") %>%
    mutate(cve_ent = case_when(cve_ent == "01" ~ "AGU",
                               cve_ent == "02" ~ "BCN",
                               cve_ent == "03" ~ "BCS",
                               cve_ent == "04" ~ "CAM",
                               cve_ent == "05" ~ "COA",
                               cve_ent == "06" ~ "COL",
                               cve_ent == "07" ~ "CHP",
                               cve_ent == "08" ~ "CHH",
                               cve_ent == "09" ~ "CMX",
                               cve_ent == "10" ~ "DUR",
                               cve_ent == "11" ~ "GUA",
                               cve_ent == "12" ~ "GRO",
                               cve_ent == "13" ~ "HID",
                               cve_ent == "14" ~ "JAL",
                               cve_ent == "15" ~ "MEX",
                               cve_ent == "16" ~ "MIC",
                               cve_ent == "17" ~ "MOR",
                               cve_ent == "18" ~ "NAY",
                               cve_ent == "19" ~ "NLE",
                               cve_ent == "20" ~ "OAX",
                               cve_ent == "21" ~ "PUE",
                               cve_ent == "22" ~ "QUE",
                               cve_ent == "23" ~ "ROO",
                               cve_ent == "24" ~ "SLP",
                               cve_ent == "25" ~ "SIN",
                               cve_ent == "26" ~ "SON",
                               cve_ent == "27" ~ "TAB",
                               cve_ent == "28" ~ "TAM",
                               cve_ent == "29" ~ "TLA",
                               cve_ent == "30" ~ "VER",
                               cve_ent == "31" ~ "YUC",
                               cve_ent == "32" ~ "ZAC"))

homicide_data <- homicide_rates %>%
    bind_rows(global_averages) %>%
    mutate(cve_ent = factor(cve_ent)) %>%
    mutate(cve_ent = fct_relevel(cve_ent, "World", after = Inf)) %>%
    mutate(color = case_when(cve_ent == "BCN" ~ scales::hue_pal()(5)[1],
                             cve_ent == "MIC" ~ scales::hue_pal()(5)[2],
                             cve_ent == "MOR" ~ scales::hue_pal()(5)[3],
                             cve_ent == "SON" ~ scales::hue_pal()(5)[4],
                             cve_ent == "ZAC" ~ scales::hue_pal()(5)[5],
                             cve_ent == "World" ~ "black",
                             TRUE ~ "grey75"),
           linetype = if_else(cve_ent == "World", "dashed", "solid"))

linegraph <- homicide_data %>%
    ggplot(aes(x = year, y = homicide_rate)) +
    geom_line(aes(color = color, group = cve_ent), linewidth = 0.6) +
    facet_wrap(~sex, scales = "free") +
    theme_minimal() +
    scale_color_identity(name = "State",
                         breaks = c("#F8766D", "#A3A500", "#00BF7D", "#00B0F6", "#E76BF3", "grey75", "black"),
                         labels = c("BCN", "MIC", "MOR", "SON", "ZAC", "Other states", "World avg."),
                         guide = "legend") +
    xlab("") +
    ylab("Homicide rate per 100,000 population") +
    guides(color = guide_legend("State"))

# done.
