#!/bin/env python3
# -*- coding: utf-8 -*-
#
# Authors:     MG
# Maintainers: MG
# ===========================================
# mexico-homicide-rates/code/deaths-data/import

import argparse
import pandas as pd
from simpledbf import Dbf5


def getargs():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input")
    parser.add_argument("--output")
    args = parser.parse_args()
    return args


if __name__ == '__main__':
    args = getargs()

    # read in .dbf file
    input_data_dbf = Dbf5(args.input)
    # convert to dataframe object
    input_data_df = input_data_dbf.to_dataframe()
    # write to csv for ease of future use
    input_data_df.to_csv(args.output, sep="|")

# done.
