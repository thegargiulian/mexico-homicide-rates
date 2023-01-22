#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/census-data/import-census/Makefile

HERE := $(shell git rev-parse --show-toplevel)

.PHONY: all clean

all: output/census-2000.csv output/census-2010.csv output/census-2020.csv

clean:
	-rm output/*

# data retrieved using https://www.inegi.org.mx/programas/ccpv/2000/#Datos_abiertos
# download data for Estados Unidos Mexicanos
output/census-2000.csv: \
		src/import-inegi.R \
		$(HERE)/data/census/cgpv2000_iter_00.csv
	-mkdir output
	Rscript --vanilla $< \
			--input=$(HERE)/data/census/cgpv2000_iter_00.csv \
			--output=$@

# data retrieved using https://www.inegi.org.mx/programas/ccpv/2010/#Datos_abiertos
# download data for Estados Unidos Mexicanos
output/census-2010.csv: \
		src/import-inegi.R \
		$(HERE)/data/census/iter_00_cpv2010.csv
	-mkdir output
	Rscript --vanilla $< \
			--input=$(HERE)/data/census/iter_00_cpv2010.csv \
			--output=$@

# retrieved using https://www.inegi.org.mx/programas/ccpv/2020/#Datos_abiertos
# download data for Estados Unidos Mexicanos
output/census-2020.csv: \
		src/import-inegi.R \
		$(HERE)/data/census/conjunto_de_datos_iter_00CSV20.csv
	-mkdir output
	Rscript --vanilla $< \
			--input=$(HERE)/data/census/conjunto_de_datos_iter_00CSV20.csv \
			--output=$@

# done.
