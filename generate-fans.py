"""generate-fans.py: Generates random NJBA fans data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

from random import *

import csv
import names

count = 1
emailDomain = ['yahoo', 'gmail', 'outlook', 'icloud', 'aol', 'mail', 'inbox', 'yandex', 'zoho', 'prontonmail']

with open('data/fans.csv', mode='w') as fan_file:
    fan_writer = csv.writer(fan_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    # 1,000,000 fans created
    while count <= 1000000:
        # Create the fan list
        fan = []

        # Add the ID
        fan.append(count)

        # Generage a random gender
        gender = randint(0,1)

        # Create a person's first name based on gender
        fan.append(names.get_first_name(gender='male')) if gender == 1 \
            else fan.append(names.get_first_name(gender='female'))

        # Create a person's last name
        fan.append(names.get_last_name())

        # Full Name
        fan.append(fan[1] + ' ' + fan[2])

        # Generate a random email domain
        randDomain = randint(0,9)
        fan.append(fan[1]+fan[2]+str(randint(1,500))+'@'+emailDomain[randDomain]+'.com')

        fan_writer.writerow(fan)
        count+=1