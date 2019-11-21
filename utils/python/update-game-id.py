"""game.py: Cleanse NJBA game data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

from random import *

import csv
import pandas as pd

# while number of seasons is less than 150
# For each item in pre
# Update the game id
#
# For each item in reg
# Update the game id
#
# For each item in post
# Update the game id

count = 1
gameid = 1

while count <= 148:
    game_pre = pd.read_csv('01pre/pre'+str(count)+'.csv')

    with open('01pre/new/pre'+str(count)+'.csv', mode='w') as output1_file:
        pre_writer = csv.writer(output1_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        for item in range(len(game_pre)):

            temp = []
            temp.append(gameid)
            temp = temp + list(game_pre.iloc[item, 1:])

            gameid += 1
            pre_writer.writerow(temp)

    game_reg = pd.read_csv('02reg/reg' + str(count+1) + '.csv')

    with open('02reg/new/reg'+str(count+1)+'.csv', mode='w') as output2_file:
        reg_writer = csv.writer(output2_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        for item in range(len(game_reg)):

            temp = []
            temp.append(gameid)
            temp = temp + list(game_reg.iloc[item, 1:])

            gameid += 1
            reg_writer.writerow(temp)

    game_post = pd.read_csv('03post/post' + str(count+2) + '.csv')

    with open('03post/new/post'+str(count+2)+'.csv', mode='w') as output3_file:
        post_writer = csv.writer(output3_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        for item in range(len(game_post)):

            temp = []
            temp.append(gameid)
            temp = temp + list(game_post.iloc[item, 1:])

            gameid += 1
            post_writer.writerow(temp)

    count += 3
