"""split_file.py: Separates data into small subsets for MySQL Workbench."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

import csv
import pandas as pd
import math
import sys


'''
The arg parameter is the name of the file that will be broken into small subsets.
'''

count = 1
argList = sys.argv
index = 1

split = pd.read_csv('data/' + argList[1] + '.csv', header = None)#.astype(int)
numFiles = math.ceil(len(split) / 5000)

# count <= numFiles or
while index != len(split):
    with open('data/sample/' + str(argList[1]) + '/' + str(argList[1]) + str(count) + '.csv', mode = 'w') as split_file:
        split_writer = csv.writer(split_file, delimiter = ',', quotechar = '"', quoting = csv.QUOTE_MINIMAL)

        while True:
            temp = []
            temp = list(split.loc[index, :])

            split_writer.writerow(temp)
            index += 1
            if index % 5000 == 0 or index == len(split):
                break
        count += 1
