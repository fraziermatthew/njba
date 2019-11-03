"""game.py: Cleanse NJBA game data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

from random import *

import csv
import pandas as pd

count = 1
gameid = 0
maxSeasons = 1
# maxSeasons = 150
# maxGames = 130786

att = pd.read_csv('data/attendance.csv', header=None)

# While number of seasons is less than 150
while count <= maxSeasons:

    # For each item in pre
    # Append the game attendance

    game_pre = pd.read_csv('data/game/01pre/pre'+str(count)+'.csv', header=None)

    with open('data/game/01pre/new/pre'+str(count)+'.csv', mode='w') as output1_file:
        pre_writer = csv.writer(output1_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        for item in range(len(game_pre)):

            temp = list(game_pre.iloc[item, :])
            attendance = att.iloc[gameid][1]

            temp.append(attendance)

            pre_writer.writerow(temp)
            gameid += 1

    # For each item in reg
    # Update the game id

    game_reg = pd.read_csv('data/game/02reg/reg' + str(count+1) + '.csv', header=None)
    #
    with open('data/game/02reg/new/reg'+str(count+1)+'.csv', mode='w') as output2_file:
        reg_writer = csv.writer(output2_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        for item in range(len(game_reg)):

            temp = list(game_reg.iloc[item, :])
            attendance = att.iloc[gameid][1]

            temp.append(attendance)

            reg_writer.writerow(temp)
            gameid += 1

    # For each item in post
    # Update the game id

    game_post = pd.read_csv('data/game/03post/post' + str(count+2) + '.csv', header=None)

    with open('data/game/03post/new/post'+str(count+2)+'.csv', mode='w') as output3_file:
        post_writer = csv.writer(output3_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        for item in range(len(game_post)):

            temp = list(game_post.iloc[item, :])
            attendance = att.iloc[gameid][1]

            temp.append(attendance)

            post_writer.writerow(temp)
            gameid += 1

    count += 3
