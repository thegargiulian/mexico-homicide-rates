#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/code/census-data/interpolate/Makefile

HERE := $(shell git rev-parse --show-toplevel)

.PHONY: all clean

all: output/population-estimates.csv

clean:
	-rm output/*

output/population-estimates.csv: \
		src/interpolate.R \
		$(HERE)/code/census-data/import/output/census-2000.csv \
		$(HERE)/code/census-data/import/output/census-2010.csv \
		$(HERE)/code/census-data/import/output/census-2020.csv
	-mkdir output
	Rscript --vanilla $< \
			--census_2000=$(HERE)/code/census-data/import/output/census-2000.csv \
			--census_2010=$(HERE)/code/census-data/import/output/census-2010.csv \
			--census_2020=$(HERE)/code/census-data/import/output/census-2020.csv \
			--new_munis=output/new-munis.csv \
			--population_estimates=$@

# done.
