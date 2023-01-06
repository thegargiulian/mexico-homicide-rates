#
# Authors:     MG
# Maintainers: MG
# =========================================
# mexico-homicide-rates/deaths-data/import/Makefile

HERE := $(shell git rev-parse --show-toplevel)
DEATHS := $(wildcard $(HERE)/data/death-certificates/DEFUN*.dbf)
tmp := $(subst $(HERE)/data/death-certificates/DEFUN,output/DEFUN20,$(DEATHS))
OUTPUT := $(patsubst %.dbf,%.csv,$(tmp))

.PHONY: all clean

all: $(OUTPUT)

clean:
	-rm output/*

output/DEFUN20%.csv: \
		src/import-dbf.py \
		$(DEATHS)
	-mkdir output
	python3 $< \
			--input=$(HERE)/data/death-certificates/DEFUN$*.dbf \
			--output=$@

# done.
