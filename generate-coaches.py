"""generate-fans.py: Generates random NJBA coaches data."""

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
        python3 generate-coaches.py
'''


numOfSeasons = 50
numOfTeams = 30

title = ['Head', 'Assistant', 'Shooting', 'Defensive', 'Offensive']
id = 1

with open('data/coaches.csv', mode='w') as coach_file:
    coach_writer = csv.writer(coach_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    # 50 seasons
    # 5 coaches per team
    # 30 teams
    for season in range(numOfSeasons):    
        for team in range(numOfTeams):   
            for index in range(len(title)):
                # Create the coach list
                coach = []

                # ID
                coach.append(id)

                # Team ID
                coach.append(team + 1)

                # Generate a random gender
                gender = randint(0,1)

                # First name
                coach.append(names.get_first_name(gender='male')) if gender == 1 \
                    else coach.append(names.get_first_name(gender='female'))

                # Last name
                coach.append(names.get_last_name())

                # Full Name
                coach.append(coach[2] + ' ' + coach[3])

                # Title
                coach.append(title[index])
                id += 1

                coach_writer.writerow(coach)
            