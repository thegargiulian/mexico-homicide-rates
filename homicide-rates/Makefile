#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/homicide-rates/Makefile

HERE := $(shell git rev-parse --show-toplevel)

.PHONY: all clean

all: output/muni-month-homicide-rates.csv

clean:
		-rm output/*

output/muni-month-homicide-rates.csv: \
		src/calculate-rates.R \
		$(HERE)/deaths-data/homicide-tables/output/muni-month-homicides-2000-2020.csv \
		$(HERE)/census-data/interpolate/output/population-estimates.csv
	-mkdir output
	Rscript --vanilla $< \
			--homicides_data=$(HERE)/deaths-data/homicide-tables/output/muni-month-homicides-2000-2020.csv \
			--population_estimates=$(HERE)/census-data/interpolate/output/population-estimates.csv \
			--output=$@

# done.
