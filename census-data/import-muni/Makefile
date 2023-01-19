#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/census-data/import/Makefile

.PHONY: all clean

all: output/census-2000.csv output/census-2010.csv output/census-2020.csv

clean:
	-rm output/*

output/census-2000.csv: \
		src/import-inegi-2000.R \
		input/cgpv2000_iter_00.csv
	-mkdir output
	Rscript --vanilla $< \
			--input=\input/cgpv2000_iter_00.csv \
			--output=$@

output/census-2010.csv: \
		src/import-inegi-2010.R \
		input/iter_00_cpv2010.csv
	-mkdir output
	Rscript --vanilla $< \
			--input=input/iter_00_cpv2010.csv \
			--output=$@

output/census-2020.csv: \
		src/import-inegi-2020.R \
		input/INEGI_exporta_13_11_2022_13_30_50.csv
	-mkdir output
	Rscript --vanilla $< \
			--input=input/INEGI_exporta_13_11_2022_13_30_50.csv \
			--output=$@

# using IPUMS data instead
# output/census-2000.csv: \
# 		src/import-ipums.R \
# 		input/ipumsi_00010.csv
# 	-mkdir output
# 	Rscript --vanilla $< \
# 			--input=input/ipumsi_00010.csv \
# 			--output=$@

# output/census-2010.csv: \
# 		src/import-ipums.R \
# 		input/ipumsi_00011.csv
# 	-mkdir output
# 	Rscript --vanilla $< \
# 			--input=input/ipumsi_00011.csv \
# 			--output=$@

# done.
