"""game.py: Cleanse NJBA game data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

from random import *

import csv
import pandas as pd

count = 6
while count <= 150:
    game_reader = pd.read_csv('post'+str(count)+'.csv')

    with open('new/post'+str(count)+'.csv', mode='w') as output_file:
        c_writer = csv.writer(output_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        for item in range(len(game_reader)):
            if type(game_reader.iloc[item][4]) != float and game_reader.iloc[item][4] != '-':
                c_writer.writerow(list(game_reader.iloc[item, :]))
    count += 3
