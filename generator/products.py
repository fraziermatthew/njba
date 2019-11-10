"""products.py: Generates random NJBA product data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

import csv

# 30 teams
# Each team has their own version of all products

# One sizes ('ALL') = 'Snapback Cap', 'Basketball', 'Fitted Cap'
# All sizes ('XS', 'S', 'M', 'L', 'XL') = 'T-Shirt', 'Sweatpants', 'Sweatshirt', 'Jersey', 'Shorts', 'Socks', 'Hoodie', 'Coat'

# Snapback Cap = 25.99
# Basketball = 49.99
# Fitted Cap = 32.99
# T-Shirt = 39.99
# Sweatpants = 64.99
# Sweatshirt = 54.99
# Jersey = 79.99
# Shorts = 44.99
# Socks = 9.99
# Hoodie = 59.99
# Coat = 99.99

id         = 1
teamid     = 1
numOfTeams = 30

one_size = ['Snapback Cap', 'Basketball', 'Socks', 'Fitted Cap']
one_size_price = ['25.99', '49.99', '9.99', '32.99']
all_size = ['T-Shirt', 'Sweatpants', 'Sweatshirt', 'Jersey', 'Shorts', 'Hoodie', 'Coat']
all_size_price = ['39.99', '64.99', '54.99', '79.99', '44.99', '59.99', '99.99']
size = ['XS', 'S', 'M', 'L', 'XL']

with open('data/products.csv', mode='w') as product_file:
    product_writer = csv.writer(product_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    # id, price, product type, size
    # All Teams
    for teamid in range(numOfTeams):

        # All Size Items
        for item in range(len(all_size)):
            for entity in range(len(size)):
                product = []

                # ID
                product.append(id)

                # Product price
                product.append(all_size_price[item])

                # Product type
                product.append(all_size[item])

                # Product size
                product.append(size[entity])

                id += 1
                product_writer.writerow(product)

        # One Size Items
        for item in range(len(one_size)):
            product = []

            # ID
            product.append(id)

            # Product price
            product.append(one_size_price[item])

            # Product type
            product.append(one_size[item])

            # Product size
            product.append('ALL')

            id += 1
            product_writer.writerow(product)

