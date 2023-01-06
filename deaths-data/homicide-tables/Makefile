#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/deaths-data/homicide-tables/Makefile

HERE := $(shell git rev-parse --show-toplevel)
DEATHS := $(wildcard $(HERE)/deaths-data/import/output/DEFUN*.csv)

.PHONY: all clean

all: output/muni-month-homicides-2000-2020.csv

clean:
		-rm output/*

output/muni-month-homicides-2000-2020.csv: \
		src/make-tables.R \
		$(DEATHS)
	-mkdir output
	Rscript --vanilla $< \
			--import_stub=$(HERE)/deaths-data/import/output \
			--output=$@

# done.
