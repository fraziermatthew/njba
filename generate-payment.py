"""generate-payment.py: Generates random NJBA payment data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

from random import *

import csv

#      1 - 339457  Donor
# 339458 - 339999  Sponsor
# 340000 - 5000000 Shopper

shopperMax = 5000000
index = 1

with open('data/payment.csv', mode='w') as payment_file:
    payment_writer = csv.writer(payment_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    while index < shopperMax:

        payment = []

        # ID
        payment.append(index)

        # Amount and Type
        if (index>= 1 and index <= 339457):
            # Donations between $1,000 and $10,000
            payment.append(str(randint(1,10))+'000.00')
            payment.append('Donor')


        if (index >= 339458 and index <= 339999):
            # Sponorships between $100,000 and $500,000
            payment.append(str(randint(1,5)) + '0000.00')
            payment.append('Sponsor')


        if (index > 339999):
            # Shoppers between $1 and $1,000
            payment.append('1.00') # Will update this with SQL later
            payment.append('Shopper')

        index += 1

        payment_writer.writerow(payment)