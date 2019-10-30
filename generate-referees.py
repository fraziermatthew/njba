"""generate-referees.py: Generates random NJBA referee data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

from random import *

import csv
import names

'''
Steps to run this project:
    1. Create a virtual env and activate source 
        virtualenv -p python3 .
        ./bin/activate
    2. Install names PyPi Module - https://pypi.org/project/names/
        pip install names
    3. Run the project
        python3 generate-referees.py
'''

count = 1
title = ['Crew Chief', 'Referee', 'Umpire']

with open('data/referees.csv', mode='w') as referee_file:
    referee_writer = csv.writer(referee_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    # 20,000 referees created
    while count <= 20000:

        # Create the referee list
        referee = []

        # ID
        referee.append(count)

        # Generage a random gender
        gender = randint(0,1)

        # First name
        referee.append(names.get_first_name(gender='male')) if gender == 1 \
            else referee.append(names.get_first_name(gender='female'))

        # Last name
        referee.append(names.get_last_name())

        # Full Name
        referee.append(referee[1] + ' ' + referee[2])

        # Title
        randTitle = randint(0,2)
        referee.append(title[randTitle])

        referee_writer.writerow(referee)
        count+=1