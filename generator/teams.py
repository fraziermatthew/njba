"""teams.py: Generates random NJBA teams data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

import csv

'''
Steps to run this project:
    1. Create a virtual env and activate source 
        virtualenv -p python3 .
        ./bin/activate
    2. Install names PyPi Module - https://pypi.org/project/names/
        pip install names
    3. Run the project
        python3 teams.py
'''


name = ['Pandas',   'Lions',     'Bears',      'Tigers',      'Swish',
        'Toads',    'Hoggers',   'Gorillas',   'Beasts',      'Otters',
        'Ballers',  'Dribblers', 'Predators',  'Hot Shots',   'Cheetahs',
        'Brawlers', 'Chargers',  'Gladiators', 'Rippers',     'Owls', 
        'Boxers',   'Crusaders', 'Panthers',   'Stars',       'Defenders', 
        'Crush',    'Elephants', 'Matadors',   'Chiuhuahuas', 'Penetrators']

location = ['Kansas City',  'Austin',       'Colorado Springs', 'Fayetteville', 'Raleigh', 
            'Madison',      'Jacksonville', 'Spartansburg',     'Las Vegas',    'Omaha',
            'Grand Rapids', 'Richmond',     'Seattle',          'Tucson',       'Honolulu',
            'Cincinnati',   'Indianapolis', 'Providence',       'Newark',       'Baltimore',
            'Boise',        'Maine',        'Birmingham',       'Long Beach',   'Yonkers',
            'Sarasota',     'St. Louis',    'El Paso',          'Albequerque',  'San Jose']

conference = ['Northern', 'Southern']

division = ['Metropolitan', 'East', 'Midwest', 'West', 'Pacfiic', 'Altlantic']

mascot = ['Stitch',      'Fearless The Cat', 'Clutch',           'Roary',   'Curly',
          'Spikez',      'Wrathhog',         'Stinger',          'Hunter',  'Poseidon The Otter',
          'Dunker',      'Dribbles',         'Slapshot',         'Junior', 'The Prowler',
          'Hercules',    'Ranger',           'Slug The Warrior', 'Lucky',   'Magician',
          'Bruiser',     'Champ',            'Venom',            'Snoops',  'Scraps',
          'Cosmo Ghost', 'Jumbo',            'Raider',           'Paws',    'Crusader']

with open('data/teams.csv', mode='w') as team_file:
    team_writer = csv.writer(team_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    # 30 teams created
    for index in range(len(name)):
        
        # Create the team list
        team = []

        # ID
        team.append(index + 1)
       
        # Name
        team.append(name[index])

        # Location
        team.append(location[index])

        # Conference
        team.append(conference[0]) if index < 15 \
            else team.append(conference[1])

        # Division
        if index in range (25,30): team.append(division[0])
        if index in range (20,25): team.append(division[1])
        if index in range (15,20): team.append(division[2])
        if index in range (10,15): team.append(division[3])
        if index in range (5,10): team.append(division[4])
        if index in range (0,5): team.append(division[5])

        # Mascot
        team.append(mascot[index])

        team_writer.writerow(team)
