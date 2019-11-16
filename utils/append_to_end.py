"""split_file.py: Separates data into small subsets for MySQL Workbench."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

import csv
import pandas as pd
import sys


'''
The arg parameter is the name of the file that will be broken into small subsets.
'''

count = 1
argList = sys.argv
index = 1
#
# with open('data/temp1.csv', mode = 'r') as read_file:
#
with open('data/temp1-new.csv', mode = 'w') as append_file:
    append_writer = csv.writer(append_file, delimiter = ',', quotechar = '"', quoting = csv.QUOTE_MINIMAL)

    with open("data/output.csv") as f:
        reader = csv.reader(f)
        for row in reader:
            x= str(row)
            x += ");"
            x = x.replace("['", "")
            x = x.replace("']);",");")
            y = []
            y.append(x)
            # print(y)
            append_writer.writerow(y)
#
#         # count <= numFiles or
#         for index in range(len(read_file)):
#             temp = []
#             # temp = list(append.loc[index, :]+");")
#             # read_file
#             print(read_file)
#             # append_writer.writerow(temp)


