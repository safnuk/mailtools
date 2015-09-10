#!/usr/bin/env python
""" xls2txt.py - Takes an excel spreadsheet and outputs it as plain text."""

import argparse
import pyexcel
import pyexcel.ext.text as text
from pyexcel.ext import xls
from pyexcel.ext import xlsx

parser = argparse.ArgumentParser(description="Print an Excel worksheet to stdout.")
parser.add_argument('filename', help="file to process")

args = parser.parse_args()
sheet = pyexcel.get_book(file_name=args.filename)
print(sheet)
