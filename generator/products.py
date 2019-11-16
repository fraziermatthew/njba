"""products.py: Generates random NJBA product data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

from random import randint

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
all_size = ['T-shirt', 'Sweatpants', 'Sweatshirt', 'Jersey', 'Shorts', 'Hoodie', 'Coat']
all_size_price = ['39.99', '64.99', '54.99', '79.99', '44.99', '59.99', '99.99']
size = ['XS', 'S', 'M', 'L', 'XL']
department = ['Men','Woman','Children']
colors = ['Home', 'Alternate Home', 'Away', 'Alternate Away']
shirt_type = ['Crew neck', 'V-neck']
clothing_type=['Handmade', 'Import']
description = ['Machine wash cold with like colors. Gentle cycle. Tumble dry low.', 'Dry clean only.',
             'Only non-chlorine bleach when needed. Cool iron if needed.']
made = ['Made in USA.', 'Made in China.', 'Made in Vietnam.', 'Made in Italy.']
details = ['100% cotton.', '90% cotton. 10% polyester.', '90% cotton. 10% rayon.',
           '50% mesh. 40% cotton. 10% polyester.', '75% knit. 10% spandex. 15% mesh.',
           '80% cotton. 20% polyester.', '80% cotton. 20% rayon.']

# -- SKU,

with open('data/products4.csv', mode='w') as product_file:
    product_writer = csv.writer(product_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    # id, price, product type, size
    # All Teams
    for teamid in range(numOfTeams):

        # All Departments
        for index in range(len(department)):

            for color in range(len(colors)):

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

                        # Product category
                        product.append(department[index])

                        # Product color
                        product.append(colors[color])

                        # Product Description
                        clothing = []
                        descRand = randint(0, 2)
                        clothRand = randint(0, 1)
                        if all_size[item] == 'T-shirt':
                            clothing.append(shirt_type[1] + ' ' + all_size[item] + '. ' +
                                          description[descRand]) \
                                if clothRand == 1 \
                                else clothing.append(shirt_type[0] + ' ' + all_size[item] + '. ' +
                                          description[descRand])
                        else:
                            clothing.append(clothing_type[1] + ' ' + all_size[item] + '. ' +
                                          description[descRand]) \
                                if clothRand == 1 \
                                else clothing.append(clothing_type[0] + ' ' + all_size[item] + '. ' +
                                                   description[descRand])
                        product.append(clothing[0])

                        # Product Details
                        madeRand = randint(0, 3)
                        detailsRand = randint(0, 6)
                        detail = []
                        detail.append(details[detailsRand] + " " + made[madeRand])
                        product.append(detail[0])

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

                    # Product category
                    product.append(department[index])

                    # Product color
                    product.append(colors[color])

                    id += 1
                    product_writer.writerow(product)
