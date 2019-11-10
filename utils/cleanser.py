"""game.py: Cleanse NJBA game data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

from random import *
from datetime import datetime

import csv
import pandas as pd

count = 5
while count <= 149:
    game_reader = pd.read_csv('part3.'+str(count)+'.csv')

    s = game_reader.iloc[0][0]
    s = str(datetime.strptime(s, '%m/%d/%y'))
    # s = str(date_object)
    if s[0:2] == "19":
        s = "20" + f[2:]

        with open('new/part3.'+str(count)+'.csv', mode='w') as output_file:
            c_writer = csv.writer(output_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        for item in range(len(game_reader)):
            game_reader.loc[item][2].replace("19","20")
            c_writer.writerow(list(game_reader.iloc[item, :]))
            # temp = []
            # temp.append(1)
            # temp.append(count)
            # s = game_reader.iloc[item][0]
            # date_object = datetime.strptime(s, '%m/%d/%y')
            # f = str(date_object)
            # if f[0:2] == "19":
            # f = "20" + f[2:]
            # temp.append(f[:10])
            # tempFinal = temp + list(game_reader.iloc[item, 1:])
            #
            # c_writer.writerow(tempFinal)
    count += 3
