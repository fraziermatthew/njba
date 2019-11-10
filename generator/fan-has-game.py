"""fan-has-game.py: Generates NJBA fan/game mapping table data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

from random import *

import csv

minAttendance = 16000
maxAttendance = 20000
gameid = 5001
maxGames = 130786
# 82 + 8 + 16

with open('data/fan_has_game2.csv', mode='w') as fhg_file:
    fhg_writer = csv.writer(fhg_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    with open('data/attendance2.csv', mode = 'w') as attendance_file:
        attendance_writer = csv.writer(attendance_file, delimiter = ',', quotechar = '"', quoting = csv.QUOTE_MINIMAL)

        while gameid <= maxGames:

            # Generate number of attendance
            attendance = randint(minAttendance, maxAttendance)
            attTracker = []

            # Keep track of attendance
            att = []
            att.append(gameid)
            att.append(attendance)
            attendance_writer.writerow(att)

            for fan in range(attendance):
                # Randomly select the fans for each game
                fhg = []

                while True:
                    # Generate a fan
                    fanid = randint(1, 10000000)

                    # Check the tracker to see if the fan is already attending
                    if fanid in attTracker:
                        continue
                    else:
                        attTracker.append(fanid)
                        fhg.append(fanid)
                        break

                fhg.append(gameid)

                fhg_writer.writerow(fhg)

            gameid += 1

