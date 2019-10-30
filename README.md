
# NBJA Database <img src="https://flcfit.com/wp-content/uploads/2018/04/Mens-league-logo.png" align="right" width="25%" height="25%"></img>
**Matthew Frazier**<br>
University of Delaware<br>
CISC 637 Database Systems<br>
Fall 2019

### Overview
This project proposes a database for a fictional basketball league, the National Junior Basketball Association (NJBA).

#### Documentation
Details on the concept of the NJBA league is in the /docs folder:
* Presentation.pdf
  - Powerpoint bullet presentation of the NJBA that outlines its core competencies.
* Proposal.pdf
  - A paper that surveys the industry standard and proposes the need for the league.
* User-Stories.pdf
  - Focused user stories that outline the vision of the UI for the NJBA application.

#### Database Design
![Physical Model](models/physical-model.png)

#### Requirements
1. **MySQL:** [Download and install MySQL server here](https://dev.mysql.com/downloads/)
2. **Python 3:** [Download and install Python 3 here](https://www.python.org/downloads/)

#### Dependencis
**PyPi libraries:**
  - [Names](https://pypi.org/project/names/)
  - [Pandas](https://pypi.org/project/pandas/)
> pip install names<br>
> pip install pandas<br>
>
  
        
### Running the Project
Create a python virtual environment
> virtualenv -p python3 .

Launch the Python virutal environment
> source ./bin/activate

<br>

#### Addtional Information
**Payment Mapping**<br>
Donors  = 1      through 339457<br>
Sponsor = 339458 through 399999<br>
Shopper = 340000 through 5000000<br>
