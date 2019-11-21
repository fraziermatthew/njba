"""game.py: Cleanse NJBA game data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

import csv
from datetime import datetime

import pandas as pd

count = 3
while count <= 3:
    game_reader = pd.read_csv('post'+str(count)+'.csv')

    # title = game_reader.loc[2][2]
    # s = game_reader.iloc[2][2]
    # s = str(datetime.strptime(s, '%m/%d/%y'))
    # s = str(date_object)
    # if s[0:2] == "19":
    with open('new/post'+str(count)+'.csv', mode='w') as output_file:
        c_writer = csv.writer(output_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        for item in range(len(game_reader)):
            # game_reader[title] = game_reader.loc[item][2].replace("19","20")
            # c_writer.writerow(list(game_reader.iloc[item, :]))
            temp = []
            temp.append(1)
            temp.append(count)
            s = game_reader.iloc[item][0]
            if s[-3] != '/':
                s = str(datetime.strptime(s, '%m/%d/%Y'))
            else:
                s = str(datetime.strptime(s, '%m/%d/%y'))
            # f = str(date_object)
            if s[0:2] == "19":
                s = "20" + s[2:]
            temp.append(s[:10])
            tempFinal = temp + list(game_reader.iloc[item, 1:2])
            tempFinal.append(int(game_reader.iloc[item, 2]))
            tempFinal.append(int(game_reader.iloc[item, 3]))
            tempFinal.append((game_reader.iloc[item, 4]))

            c_writer.writerow(tempFinal)
    count += 3
