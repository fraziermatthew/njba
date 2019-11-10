"""season.py: Generates random NJBA season data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

from datetime import timedelta

import calendar
import csv

'''
Steps to run this project:
    1. Create a virtual env and activate source 
        virtualenv -p python3 .
        ./bin/activate
    2. Install names PyPi Module - https://pypi.org/project/names/
        pip install names
    3. Run the project
        python3 generate-seasons.py
'''

numOfSeasons = 50

seasonType = ["Pre", "Regular", "Post"]
id = 1

cal = calendar.Calendar(firstweekday = calendar.SUNDAY)
year = 2019  # Start Year
# month = 10  # October
# month2 = 4  # April
# month3 = 6  # June

with open('data/seasons2.csv', mode = 'w') as season_file:
    season_writer = csv.writer(season_file, delimiter = ',', quotechar = '"', quoting = csv.QUOTE_MINIMAL)

    for j in range(numOfSeasons):
        for index in range(len(seasonType)):
            # id, start-date, end-date, start-year, end-year, seasonType

            # Create the season list
            season = []

            # monthcal = cal.monthdatescalendar(year,month)
            if (seasonType[index] == "Pre"):
                monthcal = cal.monthdatescalendar(year, 9)
            elif (seasonType[index] == "Regular"):
                monthcal = cal.monthdatescalendar(year, 10)
            else:
                monthcal = cal.monthdatescalendar(year + 1, 4)

                # ID
            season.append(id)

            if (seasonType[index] == "Pre"):
                # Pre Season
                # Start date is 4th Saturday of every September
                start_date = [day for week in monthcal for day in week if \
                              day.weekday() == calendar.SATURDAY][3]

                # Start date
                season.append(start_date)

                # End date is 3rd Monday of every October
                monthcal = cal.monthdatescalendar(year, 10)

                end_date = [day for week in monthcal for day in week if \
                            day.weekday() == calendar.TUESDAY][2]

                end_date = end_date - timedelta(days = 1)

                # End date
                season.append(end_date)

            if (seasonType[index] == "Regular"):
                # Regular Season
                # Start date is 3rd Tuesday of every October
                start_date = [day for week in monthcal for day in week if \
                              day.weekday() == calendar.TUESDAY][2]

                # Start date
                season.append(start_date)

                # End date is 2nd Wednesday of every April
                monthcal2 = cal.monthdatescalendar(year + 1, 4)
                end_date = [day for week in monthcal2 for day in week if \
                            day.weekday() == calendar.WEDNESDAY][1]

                # End date
                season.append(end_date)

            if (seasonType[index] == "Post"):
                # Post Season
                # Start date is 2nd Thursday of every April
                start_date = [day for week in monthcal2 for day in week if \
                              day.weekday() == calendar.WEDNESDAY][1]

                start_date = start_date + timedelta(days = 1)

                # Start date
                season.append(start_date)

                # End date is 3rd Tursday of every June
                monthcal = cal.monthdatescalendar(year + 1, 6)

                end_date = [day for week in monthcal for day in week if \
                            day.weekday() == calendar.THURSDAY][2]

                # End date
                season.append(end_date)

            # # Year Abbreviation
            # abbr = str(year + 1)
            # season.append(str(year) + "-" + str(year + 1))

            # seasonType
            season.append(seasonType[index])
            id += 1
            season_writer.writerow(season)

        year += 1
