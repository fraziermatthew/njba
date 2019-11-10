"""season-has-coach.py: Generates NJBA season/coach mapping table data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

import csv
import pandas as pd

'''
Steps to run this project:
    1. Create a virtual env and activate source
        virtualenv -p python3 .
        source ./bin/activate
    2. Install names Pandas Module - https://pandas.pydata.org/pandas-docs/stable/install.html
        pip install pandas
    3. Run the project
        python3 season-has-coach.py
'''

# 150 Seasons (but 50 seasons overall)
# 7500 coaches overall
# 250 Coaches per team
# 50 per category
# 5 categories (Head, Assistant, Offensive, Defensive, Shooting)

# New coaching staff every 3 years

numTeams   = 30
seasonId   = 1
count      = 0
numSeasons = 81

coach_reader = pd.read_csv('data/coaches.csv', header = None)

with open('data/season-has-coach.csv', mode = 'w') as shc_file:
    shc_writer = csv.writer(shc_file, delimiter = ',', quotechar = '"', quoting = csv.QUOTE_MINIMAL)

    while seasonId <= numSeasons:
        for coach in range(numTeams * 5):

            # Season ID, Coach ID, Coach Team ID
            shc = []

            shc.append(seasonId)                            # Season ID
            shc.append(coach_reader.iloc[coach + count][0]) # Coach ID
            shc.append(coach_reader.iloc[coach + count][1]) # Coach Team ID

            shc_writer.writerow(shc)

        if seasonId % 9 == 0:
            count += 150

        seasonId += 1
