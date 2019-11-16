"""generate-products-has-payments.py: Generates NJBA product/payment mapping table data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

from random import *

import csv

# 1170 products to choose from
# 30 teams * 39 different products

paymentID = 340000
maxPID = 1000000
count = 0

with open('data/product-has-payment-c.csv', mode = 'w') as php_file:
    product_has_season_payment = csv.writer(php_file, delimiter = ',', quotechar = '"', quoting = csv.QUOTE_MINIMAL)

    while paymentID < maxPID:

        # Number of items per transaction
        numOfItems = randint(1,6)

        while count < numOfItems:
            php = []
            productID = randint(1,14040)

            # Product ID
            php.append(productID)

            # Payment ID
            php.append(paymentID)
            count += 1

            product_has_season_payment.writerow(php)

        # Increase the Payment ID
        paymentID += 1

        # Reset the count
        count = 0