#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/code/deaths-data/homicide-counts/Makefile

HERE := $(shell git rev-parse --show-toplevel)
DEATHS := $(wildcard $(HERE)/code/deaths-data/import/output/DEFUN*.csv)

.PHONY: all clean

all: output/muni-month-homicides-2000-2021.csv

clean:
		-rm output/*

output/muni-month-homicides-2000-2021.csv: \
		src/calculate.R \
		$(DEATHS)
	-mkdir output
	Rscript --vanilla $< \
			--import_stub=$(HERE)/code/deaths-data/import/output \
			--output=$@

# done.
