#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/census-data/import/Makefile

.PHONY: all clean

all: output/census-2000.csv output/census-2010.csv

clean:
	-rm output/*

output/census-2000.csv: \
		src/import-ipums.R \
		input/ipumsi_00010.csv
	-mkdir output
	Rscript --vanilla $< \
			--input=input/ipumsi_00010.csv \
			--output=$@

output/census-2010.csv: \
		src/import-ipums.R \
		input/ipumsi_00011.csv
	-mkdir output
	Rscript --vanilla $< \
			--input=input/ipumsi_00011.csv \
			--output=$@

# done.
