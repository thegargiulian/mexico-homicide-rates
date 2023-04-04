#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/code/homicide-rates/Makefile

HERE := $(shell git rev-parse --show-toplevel)

.PHONY: all clean

all: output/mexico-state-month-homicide-rates-2000-2021-by-sex.csv

clean:
		-rm output/*

output/mexico-state-month-homicide-rates-2000-2021-by-sex.csv: \
		src/state-calculate.R \
		$(HERE)/code/deaths-data/homicide-counts/output/muni-month-homicides-2000-2021.csv \
		$(HERE)/code/census-data/interpolate/output/population-estimates.csv
	-mkdir output
	Rscript --vanilla $< \
			--homicides_data=$(HERE)/code/deaths-data/homicide-counts/output/muni-month-homicides-2000-2021.csv \
			--population_estimates=$(HERE)/code/census-data/interpolate/output/population-estimates.csv \
			--output=$@

# done.
