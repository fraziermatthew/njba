"""generate-player.py: Generates random NJBA player data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

from random import *

import csv
import names

position = ['PG', 'SG', 'SF', 'PF', 'C']

# School generator
religious = ['The', 'St. Paul','St. Mary', 'St. Peter', 'St. Vincent',
             'St. James', 'St. Charles', 'St. Matthew', 'St. John']

schoolPrefix = [ 'Upper', 'Lower', 'Southern', 'Northeastern', 'Northwestern',
                'Southeastern', 'Southwestern', 'Mideastern', 'Central', 'Southern',
                'Eastern', 'West', 'Northern', 'Midwestern']

schoolName = ['Linwood', 'Croydon',
              'Glendale', 'Glenbrook', 'Glencrest', 'Unionville', 'Liberty',
              'Highpoint','Mountain View','Martin Luther King','Linbrook','Marlville',
              'Marlboro','Hillside','Lakeview','Lakeside','White Mountain',
              'Liberty Valley','Oxford','Coronado','Millburn','Arlington',
              'Philadelphia','Chicago','Miami','Memphis','Charlotte',
              'Kaplan','Redwood','Kappa','Epsilon','Sigma',
              'Delta','Zeta','Alpha','Omega','Iota',
              'Roslyn','Richmond','San Francisco','Millburn','Bash',
              'Houston','Foothill','Hillview','Maple Park','College Park',
              'Deer River','Cypress','Bear Mountain','Oceanside','Palm Valley',
              'Grand Mountain','Oakleaf','Horizon','Granite Bay','Freedom']

schoolSuffix = ['Charter School', 'Technical School', 'Prep University',
                'High School', 'Senior High School', 'Junior College',
                'Academy', 'International Academy', 'Episcopal School',
                'Cathedral School', 'Leadership School']

schoolPost = ['for Boys']


# 50 seasons
# 15 players per team
# 30 teams
# 3 years per player
# 3 players per position per team
numOfSeasons = 1
numOfTeams = 30
count = 1
id = 1

positionCount = 3

with open('data/players.csv', mode='w') as player_file:
    player_writer = csv.writer(player_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    jerseyTracker = []
    # PlayerID, First Name, Last Name, Full Name, Position, Jersey, School, Team, SeasonID

    for count in range(numOfSeasons):

        for teamid in range(numOfTeams):

            jerseyTracker = []

            for pos in range(len(position)):

                for i in range(positionCount):

                    # Each team has 3 players from each position
                    player = []

                    # Player ID
                    player.append(id)

                    # First name
                    player.append(names.get_first_name(gender = 'male'))

                    # Last name
                    player.append(names.get_last_name())

                    # Full Name
                    player.append(player[1] + ' ' + player[2])

                    # Position
                    player.append(position[pos])

                    # Jersey
                    while True:

                        # Generate a jersey position
                        jersey = randint(1, 59)

                        if jersey in jerseyTracker:
                            continue
                        else:
                            jerseyTracker.append(jersey)
                            player.append(jersey)
                            break

                    # School
                    rel = ''
                    schoolPre = ''
                    schoolPos = ''

                    rTest = randint(0, 6)

                    if rTest == 1:
                        rel = religious[randint(0, len(religious) -  1)]

                    preTest = randint(0, 5)

                    if preTest == 1:
                        preTest = schoolPrefix[randint(0, len(schoolPrefix) -  1)]

                    postTest = randint(0, 8)

                    if postTest == 1:
                        schoolPos = schoolPost[randint(0, len(schoolPost) -  1)]

                    schoolSuf = schoolSuffix[randint(0, len(schoolSuffix) - 1)]
                    schoolNam = schoolName[randint(0, len(schoolName) - 1)]

                    school = rel + " " + schoolPre + " " + schoolNam + " " + schoolSuf + " " + schoolPos
                    school = school.replace("  ", " ")
                    school = school.rstrip()
                    school = school.lstrip()

                    player.append(school)

                    # Team ID
                    player.append(teamid + 1)

                    # Season ID
                    player.append(count + 1)

                    id += 1

                    player_writer.writerow(player)

