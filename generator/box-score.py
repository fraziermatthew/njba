"""box-score.py: Generates random NJBA box score data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

import csv
from random import randint

import pandas as pd

'''
Team      ID
 1      1 - 14
 2     16 - 30
 3     31 - 45
 4     46 - 60
 5     61 - 75
 6     76 - 90
 7     91 - 105
 8    106 - 120
 9    121 - 135
10    136 - 140
11    151 - 165
12    166 - 180
13    181 - 195
14    196 - 210
15    211 - 225
16    226 - 240
17    241 - 255
18    256 - 270
19    271 - 285
20    286 - 300
21    301 - 315
22    316 - 330
23    331 - 345
24    346 - 360
25    361 - 375
26    376 - 390
27    391 - 405
28    406 - 420
29    421 - 435
30    436 - 450
'''

# Total players = 67500

# Stats for all seasons
# Pre, Reg, Post
# TO DO: Need to add post season stats with sql

def make_stats(pid: int, gid: int, team: int) -> list:
    """Random generator of stats for a player in a game

    :param pid:  (int) Player ID
    :param gid:  (int) Game ID
    :param team: (int) Team ID
    :return:     (lst) Player stats
    """
    player_stat = []

    player_stat.append(pid)                         # Player ID
    player_stat.append(gid)                         # Game ID

    min   = randint(0, 25)                          # Minutes Played
    fg    = randint(0, 3)                           # Field Goals Made
    fga   = int(fg + randint(0, 3))                 # Field Goals Attempted
    if fga == 0:
        fg_pct = 0
    else:
        fg_pct = round(((fg / fga) * 100), 1)       # Field Goal Percentage
    fg3   = randint(0, 3)                           # 3-Point Field Goals Made
    fg3a  = int(fg3 + randint(0, 3))                # 3-Point Field Goals Attempted
    if fg3a == 0:
        fg3_pct = 0
    else:
        fg3_pct = round(((fg3 / fg3a) * 100), 1)    # 3-Point Field Goal Percentage
    ft    = randint(0, 3)                           # Free Throws Field Goals Made
    fta   = int(ft + randint(0, 3))                 # Free Throws Field Goals Attempted
    if fta == 0:
        ft_pct = 0
    else:
        ft_pct = round(((ft / fta) * 100), 1)       # Free Throws Field Goal Percentage
    orb   = randint(0, 10)                          # Offensive Rebound
    drb   = randint(0, 10)                          # Offensive Rebound
    trb   = int(orb + drb)                          # Total Rebound
    ast   = randint(0, 12)                          # Assists
    blk   = randint(0, 12)                          # Blocks
    tov   = randint(0, 5)                           # Turnovers
    fouls = randint(0, 6)                           # Fouls
    pts   = int((ft) + (fg * 2) + (fg3 * 3))        # Points

    p = [min,fg,fga,fg_pct,fg3,fg3a,fg3_pct,ft,fta,ft_pct,orb,drb,trb,ast,blk,tov,fouls,pts,team]
    player_stat.extend(p)

    return player_stat


def make_dnp(pid: int, gid: int, team: int) -> list:
    """Player was labeled DNP (Did Not Play)

    :param pid:  (int) Player ID
    :param gid:  (int) Game ID
    :param team: (int) Team ID
    :return:     (lst) Player Stats
    """
    player_stat = []

    player_stat.append(pid)  # Player ID
    player_stat.append(gid)  # Game ID

    min     = 0 # Minutes Played
    fg      = 0 # Field Goals Made
    fga     = 0 # Field Goals Attempted
    fg_pct  = 0 # Field Goal Percentage
    fg3     = 0 # 3-Point Field Goals Made
    fg3a    = 0 # 3-Point Field Goals Attempted
    fg3_pct = 0 # 3-Point Field Goal Percentage
    ft      = 0 # Free Throws Field Goals Made
    fta     = 0 # Free Throws Field Goals Attempted
    ft_pct  = 0 # Free Throws Field Goal Percentage
    orb     = 0 # Offensive Rebound
    drb     = 0 # Offensive Rebound
    trb     = 0 # Total Rebound
    ast     = 0 # Assists
    blk     = 0 # Blocks
    tov     = 0 # Turnovers
    fouls   = 0 # Fouls
    pts     = 0 # Points

    p = [min, fg, fga, fg_pct, fg3, fg3a, fg3_pct, ft, fta, ft_pct, orb, drb, trb, ast, blk, tov, fouls, pts, team]
    player_stat.extend(p)

    return player_stat


pid = 1
season = 1
seasonCount = 3

numOfSeasons = 27
numOfTeams = 30
count = 1
sid = 1


with open('data/box_score.csv', mode = 'w') as stat_file:
    stat_writer = csv.writer(stat_file, delimiter = ',', quotechar = '"', quoting = csv.QUOTE_MINIMAL)

    # For each game in the pre and reg season
    while count <= numOfSeasons:

        season_output = pd.read_csv('data/game/season' + str(count) + '.csv', header = None)

        for index in range(len(season_output)):
            gameid = season_output.iloc[index][0]

            # Find out the home team id
            home = season_output.iloc[index][4]

            # Find out IDs for that player
            h_top = (home * 15) * season  # Find out max player ID
            h_low = h_top - 14  # Find out min player ID

            numPlayed = randint(8,12)
            num = 1
            playedTracker = []

            # For each player on the home team (Each team has 15 players)
            # z = 0
            while h_low <= h_top:
                # Create fake stats for that given game for that player
                stat = make_stats(h_low, gameid, home)

                h_low += 1
                stat_writer.writerow(stat)

            # Find out the away team id
            away = season_output.iloc[index][5]

            a_top = (away * 15) * season  # Find out max player ID
            a_low = a_top - 14  # Find out min player ID

            numPlayed = randint(8, 12)
            num = 1
            playedTracker = []

            # For each player on the away team (Each team has 15 players)
            while a_low <= a_top:
                # Create fake stats for that given game for that player
                stat = make_stats(a_low, gameid, away)

                a_low += 1
                stat_writer.writerow(stat)

        count += 1

        # Increment player roster every 3 years
        if count % 3 == 0:
            season += 1
