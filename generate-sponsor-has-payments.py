"""generate-donors.py: Generates random NJBA donor data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

from random import *

import csv

payment = 339458
maxPayments = 340000


with open('data/sponsor-has-payments.csv', mode='w') as shp_file:
    shp_writer = csv.writer(shp_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    for paymentid in range(payment, maxPayments):
        shp = []

        # Sponsor ID
        sponsor = randint(1, 20)
        shp.append(sponsor)

        # Payment ID
        shp.append(paymentid)

        shp_writer.writerow(shp)