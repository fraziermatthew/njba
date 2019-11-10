"""referee-has-season.py: Generates NJBA referee/season mapping table data."""

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
        python3 generate-referee-has-seasons.py
'''

# 50 Pre Seasons
# 50 Regular Seasons
# 50 Post Seasons
# 6598 Crew Chief
# 6694 Referees
# 6708 Umpires

numOfSeasons = 50
seasonId = 1

totalCount = 150

countChief = 0
countRef   = 0
countUmp   = 0

seasonChief = 1
seasonRef   = 1
seasonUmp   = 1

# (includes pre, reg, and post season for any given year)
maxChief = 131 # 6598 / 50 
maxRef = 133 # 6694 / 50 
maxUmp = 134 # 6708 / 50 

referee_reader = pd.read_csv('data/referees.csv')

with open('data/referee-has-season.csv', mode='w') as output_file:
    referee_has_season_writer = csv.writer(output_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    
    for line in range(20000-1):

        # Find what the element is
        temp = referee_reader.iloc[line][4]

        refereehasseason = []
            
        if temp == "Crew Chief" and countChief < maxChief and seasonChief < 150:
            refereehasseason.append(seasonChief)
            refereehasseason.append(referee_reader.iloc[line][0])
            countChief += 1
            referee_has_season_writer.writerow(refereehasseason)
            refereehasseason[0] = seasonChief + 1
            referee_has_season_writer.writerow(refereehasseason)
            refereehasseason[0] = seasonChief + 2
            referee_has_season_writer.writerow(refereehasseason)
        elif temp == "Crew Chief" and countChief < maxChief and seasonChief >= 150: # Give all extra to last season
            refereehasseason.append(148)
            refereehasseason.append(referee_reader.iloc[line][0])
            referee_has_season_writer.writerow(refereehasseason)
            refereehasseason[0] = 149
            referee_has_season_writer.writerow(refereehasseason)
            refereehasseason[0] = 150
            referee_has_season_writer.writerow(refereehasseason)
            

        if temp == "Referee" and countRef < maxRef and seasonRef < 150:
            refereehasseason.append(seasonRef)
            refereehasseason.append(referee_reader.iloc[line][0])
            countRef += 1
            referee_has_season_writer.writerow(refereehasseason)
            refereehasseason[0] = seasonRef + 1
            referee_has_season_writer.writerow(refereehasseason)
            refereehasseason[0] = seasonRef + 2
            referee_has_season_writer.writerow(refereehasseason)
        elif temp == "Referee" and countRef < maxRef and seasonRef >= 150: # Give all extra to last season
            refereehasseason.append(148)
            refereehasseason.append(referee_reader.iloc[line][0])
            referee_has_season_writer.writerow(refereehasseason)
            refereehasseason[0] = 149
            referee_has_season_writer.writerow(refereehasseason)
            refereehasseason[0] = 150
            referee_has_season_writer.writerow(refereehasseason)
        

        if temp == "Umpire" and countUmp < maxUmp and seasonUmp < 150:
            refereehasseason.append(seasonUmp)
            refereehasseason.append(referee_reader.iloc[line][0])
            countUmp += 1
            referee_has_season_writer.writerow(refereehasseason)
            refereehasseason[0] = seasonUmp + 1
            referee_has_season_writer.writerow(refereehasseason)
            refereehasseason[0] = seasonUmp + 2
            referee_has_season_writer.writerow(refereehasseason)
        elif temp == "Umpire" and countUmp < maxUmp and seasonUmp >= 150: # Give all extra to last season
            refereehasseason.append(148)
            refereehasseason.append(referee_reader.iloc[line][0])
            referee_has_season_writer.writerow(refereehasseason)
            refereehasseason[0] = 149
            referee_has_season_writer.writerow(refereehasseason)
            refereehasseason[0] = 150
            referee_has_season_writer.writerow(refereehasseason)    
        
        if countChief >= maxChief: # Reset the count
            countChief = 0
            seasonChief += 3
        elif countRef >= maxRef: # Reset the count
            countRef = 0
            seasonRef += 3
        elif countUmp >= maxUmp: # Reset the count
            countUmp = 0
            seasonUmp += 3
        
    
    
