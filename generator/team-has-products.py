"""team-has-products.py: Generates NJBA team/products mapping table."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

import csv

numOfTeams = 30
numOfProducts = 39
productid = 1
# 30 * 39 = 1170 products

with open('data/teams-has-products.csv', mode='w') as thp_file:
    thp_writer = csv.writer(thp_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    for team in range(numOfTeams):
        for product in range(numOfProducts):
            thp = []

            # Team ID
            thp.append(team + 1)

            # Product ID
            thp.append(productid)
            productid += 1

            # countP += 1
            thp_writer.writerow(thp)

