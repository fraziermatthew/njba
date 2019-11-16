"""generate-game-has-referee.py: Generates NJBA game/referee mapping table data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

from random import *

import csv
import pandas as pd

numOfSeasons = 150

countChief = 0
countRef   = 0
countUmp   = 0

maxChief = 1
maxRef   = 1
maxUmp   = 1
game = 1

sea_reader = pd.read_csv('data/referee-has-season-col.csv')
ref_reader = pd.read_csv('data/referees-col.csv',)
game_reader = pd.read_csv('data/games-col.csv')

with open('data/game-has-referee.csv', mode ='w') as ghr_file:
    ghr_writer = csv.writer(ghr_file, delimiter =',', quotechar ='"', quoting =csv.QUOTE_MINIMAL)

    # For every season id
    for line in range(numOfSeasons):
        # Generate 3 referees for each game

        # Find out how many games are in the season
        games = game_reader.loc[game_reader['sid'] == line + 1]

        for i in range(len(games)):
            # Get 3 refs per game
            refCount = 0

            # Find refs for season we are referring to
            refs = sea_reader.loc[sea_reader['sid'] == line + 1]

            while refCount < 3:

                # GameID, SeasonID, RefereeID
                ghr = []

                # Game ID
                ghr.append(game)

                # Season ID
                ghr.append(line + 1)

                refTracker = []

                while countChief < maxChief and countRef < maxRef and countUmp < maxUmp:
                    # Find a random referee
                    randRef = randint(1, len(refs) - 1)

                    # Generate a referee
                    ref = ref_reader.iloc[randRef][4]

                    # Check the referee title. Get a ref all titles for a given game
                    if ref in refTracker:
                        continue
                    elif ref not in refTracker and ref == "Crew Chief" and countChief < maxChief:
                        refTracker.append(ref)
                        ghr.append(ref_reader.iloc[randRef][0])
                        countChief += 1
                        ghr_writer.writerow(ghr)
                        refCount+= 1
                    elif ref not in refTracker and ref == "Referee" and countRef < maxRef:
                        refTracker.append(ref)
                        ghr.append(ref_reader.iloc[randRef][0])
                        countRef += 1
                        ghr_writer.writerow(ghr)
                        refCount += 1
                    elif ref not in refTracker and ref == "Umpire" and countUmp < maxUmp:
                        refTracker.append(ref)
                        ghr.append(ref_reader.iloc[randRef][0])
                        countUmp += 1
                        ghr_writer.writerow(ghr)
                        refCount += 1

                # Reset count
                countChief = 0
                countRef = 0
                countUmp = 0

            game += 1

