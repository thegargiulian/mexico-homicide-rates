[![doi](https://img.shields.io/badge/DOI-10.17605/OSF.IO/U8DC3-lightgrey.svg?style=for-the-badge)][doi]

[doi]: https://doi.org/10.0.68.197/OSF.IO/U8DC3

# Monthly municipal-level homicide rates in Mexico from January 2000 to December 2021

Data on crude monthly municipal-level homicide rates is available in `mexico-muni-month-homicide-rates-2000-2021.csv.gz`. Note that this file uses `|` as the separator and may need to be unzipped before your preferred statistical software can read it.

If you use `R` you can use `readr` package to load the file in without unzipping and specify the separator with `readr::read_delim("PATH_TO_FILE", delim = "|")` 

## Reproducing the results
The code to reproduce the homicide rate calculations is in the `code` subdirectory and divided into three groups of tasks: `census-data`, `deaths-data`, and `homicide-rates`. The `census-data` and `deaths-data` tasks assume that the requisite data is in a top-level directory called `data`.

To replicate the results, first run the `import` sub-task within the `census-data` task using the `Makefile` in the `census-data/import` directory. This task reads in data from the 2000, 2010, and 2020 censuses, extracts municipal-level population counts, and verifies that they sum to the total population. This task expects three census data files from INEGI in a sub-directory called `census` within the top-level `data` directory. The files are:

- cgpv2000_iter_00.csv, retreived from https://www.inegi.org.mx/programas/ccpv/2000/#Datos_abiertos (download data for "Estados Unidos Mexicanos")
- iter_00_cpv2010.csv, retreived from https://www.inegi.org.mx/programas/ccpv/2010/#Datos_abiertos (download data for "Estados Unidos Mexicanos")
- conjunto_de_datos_iter_00CSV20.csv, retreived from https://www.inegi.org.mx/programas/ccpv/2020/#Datos_abiertos (download data for "Estados Unidos Mexicanos")

Next run the `interpolate` sub-task within the `census-task` using the `Makefile` in the `census-data/interpolate` directory. This task uses the population counts from the `import` sub-task to linearly interpolate mid-year (1 July) population counts for each municipality from 2000-2021.

After running both sub-tasks in the `census-data` task, run the sub-tasks in the `deaths-data` directory. Again, this task begins with an `import` sub-task, which you can run using the `Makefile`. This task reads in death certificate files published in `.dbf` format by INEGI and writes their contents to `.csv` files. This task expects death certificate files from 2000-2021 in a sub-directory called `death-certificates` within the top-level `data` directory. These files can be downloaded from https://www.inegi.org.mx/programas/mortalidad/#Microdatos.

Next, run the `homicide-counts` sub-task using the `Makefile`. This task uses the death certificate files imported in the `deaths-data/import` task to generate counts of homicide deaths in each municipality in each month from January 2000-December 2021. The cause of death classification file, found in the `hand` subdirectory follows the cause of death classification scheme used by [Elo, Beltrán-Sánchez and Macinko (2014)](https://pubmed.ncbi.nlm.nih.gov/24554793/). Note that deaths that occurred outside of Mexico and deaths that were missing cause of death, country of occurrence, or municipality of occurrence were excluded from these calculations. We also opted to use data from the location where the death occurred rather than the location where the individual was from because this information was more complete for homicides. One day we might impute this information and recalculate the counts accordingly.

Finally, run the top-level `homicide-rates` task to calculate the montly municipal-level crude homicide rates for January 2000-December 2021.

If you use this data please use the BibTeX entry below or see the [OSF repository](https://osf.io/u8dc3/) for other citation formats:

```
@misc{Gargiulo_Aburto_Floridi_2023,
  title={Monthly municipal-level homicide rates in Mexico (January 2000–December 2019)},
  url={osf.io/u8dc3},
  DOI={10.17605/OSF.IO/U8DC3},
  publisher={OSF},
  author={Gargiulo, Maria and Aburto, José Manuel and Floridi, Ginevra},
  year={2023},
  month={Feb}
}
```
