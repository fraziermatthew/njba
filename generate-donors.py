"""generate-donors.py: Generates random NJBA donor data."""

__author__ = "Matthew Frazier"
__copyright__ = "Copyright 2019, University of Delaware, CISC 637 Database Systems"
__email__ = "matthew@udel.edu"

from random import *

import csv

'''
Steps to run this project:
    1. Create a virtual env and activate source 
        virtualenv -p python3 .
        ./bin/activate
    2. Install Namebot PyPi Module - https://pypi.org/project/namebot/
        pip install sng
    3. Run the project
        python3 generate-sponsors.py
'''


# 339457 payments are from donors --> 95 * 40 combinations max
# 20 official sponsors
# 1,000,000 payments are from official sponsors
# All other payments are from shoppers
# Donors make 1 time payment
# Sponsors make recurring payment


bizPrefix = ['critical','unusual','alive','dangerous','historical',
            'known','embarrassed','accurate','helpful','used',
            'social','pleasant','basic','mountain','acceptable',
            'scared','distinct','substantial','white','federal',
            'tiny','curious','northern','successfully','black',
            'cute','dramatic','huge','massive','severe',
            'decent','guilty','strict','automatic','visible',
            'inner','relevant','reasonable','wonderful','anxious',
            'numerous','immediate','entire','lucky','nervous',
            'serious','administrative','similar','medical','mental',
            'impressive','practical','electronic','impossible','traditional',
            'united','popular','successful','suitable','important',
            'legal','rare','aware','global','humble',
            'exciting','angry','tall','cultural','large',
            'competitive','terrible','famous','fair','willing',
            'pregnant','environmental','recent','sudden','lonely',
            'former','emotional','unique','key','friendly',
            'educational','several','happy','remarkable','weak',
            'boring','sufficient','desperate','realistic','conscious',
            'useful','healthy','nice','responsible',
            'wooden','powerful','asleep','intelligent','southern',
            'available','significant','consistent','aggressive','easy',
            'able','odd','afraid','unhappy','pure',
            'suspicious','typical','various','political','civil',
            'hot','logical','obvious','actual','capable',
            'obviously','Minimal','old','careful','foreign',
            'midwestern','poor','efficient','comprehensive','sexual','latter',
            'Lovely','able','confident','psychological','additional',
            'expensive','informal','financial','strong']

bizMiddle = ['Health', 'Accountants', 'Restaurant', 'Dairy', 'Wood',
             'Advertising', 'Residential', 'Car Dealer', 'Wholesale', 'Storage',
             'Broadcaster', 'Coal Mining', 'Chemical', 'Cable', 'Electronics',
             'Airlines', 'Computer Software', 'Casino', 'Cruise Lines', 'Satellite TV',
             'Agricultural', 'Chiropractors', 'Clothing', 'Credit Union', 'Construction',
             'Aerospace', 'Internet', 'Union', 'College', 'Gambling',
             'Banking', 'Equipment', 'Attorney', 'Insurance', 'Builder',
             'Drug Manufacturer', 'Funeral', 'Fruit', 'Vegetable', 'Computer',
             'Dentist', 'Meat', 'Marine Transport', 'Payday', 'Software',
             'Foreign Policy', 'Tobacco', 'Trucking', 'Nitro', 'Coffee',
             'Doctor', 'Medical Supplies', 'Retired', 'Barbecue', 'Chicken',
             'Forestry', 'Mining', 'Waste Management', 'Auto', 'Sneaker',
             'Food Processing', 'Natural Gas', 'Roofing', 'Data', 'Science',
             'Farming', 'Mortgage', 'Loan', 'Teacher', 'Trust',
             'Finance', 'Motion Picture', 'Stock Broker', 'Information', 'Performing Arts',
             'Natural Resources', 'Nurse', 'Securities', 'Retail', 'Railroad',
             'Environment', 'Music', 'Democratic', 'Investment',
             'Electric', 'Video', 'Real Estate', 'Republican', 'Singers',
             'Education', 'Non-Profit', 'Home', 'Newspaper', 'Oil and Gas']

bizSuffix = ['LLC', 'Ltd', 'Inc.', 'LLP', 'Industries',
            'Institute', 'Corp.', 'Associates', 'Bureau', 'Holdings',
            'Tech', 'Properties', 'Creative', 'Labs', 'International',
            'Foods', 'USA', 'Productions', 'Brothers', 'Services',
            'Officials', 'Development', '& Sons', 'Industrial', 'Systems',
            'Worldwide', 'Solutions', '& Co.', 'Enterprises', 'Collective',
            'Direct', 'Digital', 'Partners', 'Group', 'Unlimited',
            'Online', 'Brands', 'Ventures', 'Leaders', 'Specialties',
            'Ent', 'Stations', 'Sports', 'Mission', 'Auto']

streetPrefix =  ['1ST', '2ND', '3RD', '4TH', '5TH', '6TH', '7TH', '8TH', '9TH', '10TH',
                '11TH', '12TH', '13TH', '14TH', '15TH', '16TH', '17TH', '18TH', '19TH', '20TH',
                '21ST', '22ND', '23RD', '24TH', '25TH', '26TH', '27TH', '28TH', '29TH', '30TH',
                '31ST', '32ND', '33RD', '34TH', '35TH', '36TH', '37TH', '38TH', '39TH', '40TH',
                '41ST', '42ND', '43RD', '44TH', '45TH', '46TH', '47TH', '48TH', '49TH', '50TH',
                'A', 'ABBEY', 'ACACIA', 'ACACIA', 'ACADIA', 'ACEVEDO', 'ACME', 'ACORN', 'ACTON', 'ADA',
                'ADAIR','ADAM','ADDISON','ADELE','ADMIRAL','ADOLPH SUTRO','AERIAL','AGNON','AGUA','AHERN','AL SCOMA','ALABAMA',
                'ALADDIN','ALAMEDA','ALANA','ALBATROSS','ALBERTA','ALBION','ALDER','ALEMANY','ALEMANY BLVD OFF','ALERT',
                'ALHAMBRA','ALICE B TOKLAS','ALLEN','ALLISON','ALLSTON','ALMA','ALMADEN','ALOHA','ALPHA','ALPINE',
                'ALTA','ALTA MAR','ALTA VISTA','ALTON','ALVARADO','ALVISO','ALVORD','AMADOR','AMATISTA','AMATURY',
                'AMAZON', 'AMBER', 'AMBROSE BIERCE', 'AMES', 'AMETHYST', 'AMHERST', 'AMITY', 'ANDERSON', 'ANDOVER', 'ANDREW',
                'ANGELOS','ANGLO','ANKENY','ANNAPOLIS','ANNIE','ANSON','ANTHONY','ANTONIO','ANZA','ANZA','ANZAVISTA',
                'APOLLO','APPAREL','APPLETON','APPLETON','APTOS','AQUAVISTA','ARAGO','ARBALLO','ARBOL','ARBOR',
                'ARCH','ARCO','ARDATH','ARDENWOOD','ARELIOUS WALKER','ARELLANO','ARGENT','ARGONAUT','ARGUELLO','ARKANSAS',
                'ARLETA','ARLINGTON','ARMISTEAD','ARMORY','ARMSTRONG','ARNOLD','ARROYO','ARTHUR','ASH','ASHBURTON',
                'ASHBURY','ASHTON','ASHWOOD','ASPEN','ATALAYA','ATHENS','ATOLL','ATTRIDGE','AUBURN','AUGUST',
                'AUGUSTA','AUSTIN','AUTO','AUTOMOBILE','AVALON','AVENUE OF THE PALMS','AVERY','AVILA','AVOCA','AVOCET',
                'AVON','AZTEC','BACHE','BACON','BADEN','BADGER','BAKER','BALANCE','BALBOA',
                'BALCETA','BALDWIN','BALHI','BALMY','BALTIMORE','BANBURY','BANCROFT','BANK','BANKS','BANNAN',
                'BANNEKER','BANNOCK','BARCELONA','BARNARD','BARNEVELD','BARRY','BARTLETT','BARTOL','BASS',
                'BATTERY','BATTERY BLANEY','BATTERY CAULFIELD','BATTERY CHAMBERLIN','BATTERY CRANSTON',
                'BATTERY CROSBY','BATTERY DYNAMITE','BATTERY EAST','BATTERY SAFFORD','BATTERY WAGNER',
                'BAXTER','BAY','BAY SHORE','BAY SHORE BLVD OFF','BAY SHORE BLVD ON','BAY VIEW','BAYSIDE','BAYSIDE VILLAGE','BAYVIEW','BAYVIEW PARK',
                'BAYWOOD','BEACH','BEACHMONT','BEACON','BEALE','BEATRICE','BEAUMONT','BEAVER','BECKETT','BEDFORD',
                'BEEMAN','BEHR','BEIDEMAN','BELCHER','BELDEN','BELGRAVE','BELL','BELLA VISTA','BELLAIR','BELLE',
                'BELLES','BELLEVUE','BELMONT','BELVEDERE','BEMIS','BENGAL','BENNINGTON','BENTON','BEPLER','BERCUT ACCESS',
                'BERGEN','BERKELEY','BERKSHIRE','BERNAL HEIGHTS','BERNARD','BERNICE','BERNICE RODGERS','BERRY','BERRY EXTENSION','BERTHA',
                'BERTIE MINOR','BERTITA','BERWICK','BESSIE','BEULAH','BEVERLY','BIGELOW','BIGLER','BIRCH','BIRCHWOOD',
                'BIRD','BIRMINGHAM','BISHOP','BITTING','BLACK','BLACKSTONE','BLAIR','BLAIRWOOD','BLAKE','BLANCHE',
                'BLANDY','BLANKEN','BLATCHFORD','BLISS','BLISS','BLUXOME','BLYTHDALE','BOALT','BOARDMAN','BOB KAUFMAN',
                'BOCANA','BONIFACIO','BONITA','BONNIE BRAE','BONVIEW','BORICA','BOSWORTH','BOUTWELL','BOWDOIN','BOWLEY','BOWLEY',
                'BOWLING GREEN','BOWMAN','BOYD','BOYLSTON','BOYNTON','BRADFORD','BRADY','BRANNAN','BRANT',
                'BRAZIL','BREEN','BRENTWOOD','BRET HARTE','BREWSTER','BRICE','BRIDGEVIEW','BRIGHT','BRIGHTON','BRITTON',
                'BROAD','BROADMOOR','BROADWAY','BRODERICK','BROMLEY','BROMPTON','BRONTE','BROOK',
                'BROOKDALE','BROOKHAVEN','BROOKLYN','BROOKS','BROSNAN','BROTHERHOOD','BROWN','BRUCE','BRUMISS','BRUNSWICK',
                'BRUSH','BRUSSELS','BRYANT','BUCARELI','BUCHANAN','BUCKINGHAM','BUENA VISTA',
                'BURGOYNE','BURKE','BURLWOOD','BURNETT','BURNS','BURNSIDE','BURR','BURRITT','BURROWS',
                'BUSH','BUTTE','BYRON','BYXBEE','C','CABRILLO','CADELL','CAINE','CAIRE','CALEDONIA',
                'CALGARY','CALHOUN','CALIFORNIA','CALVERT','CAMBON','CAMBRIDGE','CAMELLIA','CAMEO','CAMERON',
                'CAMP','CAMPBELL','CAMPTON','CAMPUS','CANBY','CANDLESTICK COVE','CANDLESTICK POINT SRA','CANYON','CAPISTRANO','CAPITOL','CAPP','CAPRA',
                'CARD','CARDENAS','CARGO','CARL','CARMEL','CARMELITA','CARNELIAN','CAROLINA','CARPENTER','CARR',
                'CARRIE','CARRIZAL','CARROLL','CARSON','CARTER','CARVER','CASA','CASCADE','CASE','CASELLI','CASHMERE',
                'CASITAS','CASSANDRA','CASTELO','CASTENADA','CASTILLO','CASTLE','CASTLE MANOR','CASTRO','CATALINA','CATHERINE',
                'CAYUGA','CCSF PARKING LOT','CECILIA','CEDAR','CEDRO','CENTRAL','CENTRAL MAGAZINE','CENTURY','CERES','CERRITOS',
                'CERVANTES','CESAR CHAVEZ','CESAR CHAVEZ ON','CHABOT','CHAIN OF LAKES','CHANCERY','CHANNEL','CHANNEL','CHAPMAN',
                'CHARLES','CHARLES J BRENHAM','CHARLTON','CHARTER OAK','CHASE','CHATHAM','CHATTANOOGA','CHAVES',
                'CHENERY','CHERRY','CHESLEY','CHESTER','CHESTNUT','CHICAGO','CHILD','CHILTON',
                'CHINA BASIN','CHINOOK','CHRISTMAS TREE POINT','CHRISTOPHER','CHULA','CHUMASERO','CHURCH','CHURCH ACCESS','CHURCH PARKING LOT',
                'CIELITO','CIRCULAR','CITYVIEW','CLAIRVIEW','CLARA','CLAREMONT','CLARENCE','CLARENDON',
                'CLARION','CLARKE','CLARKE','CLARKSON','CLAUDE','CLAY','CLAYTON','CLEARFIELD','CLEARVIEW',
                'CLEARY','CLEMENT','CLEMENTINA','CLEO RAND','CLEVELAND','CLIFFORD','CLINTON','CLIPPER',
                'CLIPPER COVE','CLOUD','CLOVER','CLYDE','COCHRANE','CODMAN','COHEN','COLBY',
                'COLE','COLEMAN','COLERIDGE','COLIN','COLIN P KELLY JR','COLLEEN','COLLEGE','COLLINGWOOD','COLLINS',
                'COLON','COLONIAL','COLTON','COLUMBIA SQUARE','COLUMBUS','COLUSA','COMERFORD','COMMER','COMMERCIAL','COMMONWEALTH','COMPTON',
                'CONCORD','CONCOURSE','CONGDON','CONGO','CONKLING','CONNECTICUT','CONRAD','CONSERVATORY','CONSERVATORY','CONSERVATORY ACCESS',
                'CONSTANSO','CONTINUUM','CONVERSE','COOK','COOPER','COPPER','CORA','CORAL','CORAL','CORALINO',
                'CORBETT','CORBIN','CORDELIA','CORDOVA','CORNWALL','CORONA','CORONADO','CORTES','CORTLAND',
                'CORWIN','COSGROVE','COSMO','COSO','COSTA','COTTAGE','COTTER','COUNTRY CLUB','COVENTRY','COVENTRY','COWELL',
                'COWLES','CRAGMONT','CRAGS','CRAIG','CRANE','CRANLEIGH','CRAUT','CRESCENT',
                'CRESCIO','CRESPI','CRESTA VISTA','CRESTLAKE','CRESTLINE','CRESTMONT',
                'CRESTWELL','CRISP','CRISSY FIELD','CROAKER','CROOK',
                'CROSS','CROSSOVER','CROWN','CROWN','CRYSTAL','CUBA','CUESTA','CULEBRA',
                'CUMBERLAND','CUNNINGHAM','CURTIS','CUSHMAN','CUSTER','CUSTOM HOUSE',
                'CUTLER','CUVIER','CYPRESS','CYRIL MAGNIN','CYRUS','D',
                'DAGGETT','DAKOTA','DALEWOOD','DANIEL BURNHAM','DANTON','DANVERS','DARIEN','DARRELL','DARTMOUTH',
                'DASHIELL HAMMETT','DAVENPORT','DAVIDSON','DAVIS','DAVIS','DAWNVIEW','DAWSON',
                'DAY','DE BOOM','DE FOREST','DE HARO','DE LONG','DE MONTFORT','DE SOTO','DE WOLF',
                'DEARBORN','DECATUR','DECKER','DEDMAN','DEEMS','DEHON','DEL MONTE','DEL SUR','DEL VALE','DELANCEY',
                'DELANO','DELAWARE','DELGADO','DELLBROOK','DELMAR','DELTA','DEMING','DENSLOWE','DERBY',
                'DESMOND','DETROIT','DEVONSHIRE','DEWEY','DEWITT','DIAMOND','DIAMOND COVE','DIAMOND HEIGHTS','DIANA','DIAZ','DICHA',
                'DICHIERA','DICKINSON','DIGBY','DIRK DIRKSEN',
                'DIVISADERO','DIVISION','DIXIE','DOCK','DODGE','DOLORES','DOLORES','DOLPHIN',
                'DON CHEE','DONAHUE','DONNER','DORADO','DORANTES','DORCAS','DORCHESTER','DORE',
                'DORIC','DORLAND','DORMAN','DORMITORY','DOUBLE ROCK','DOUGLASS','DOVE','DOW','DOWNEY',
                'DR CARLTON B GOODLETT','DR TOM WADDELL','DRAKE','DRUMM','DRUMMOND','DUBLIN','DUBOCE','DUDLEY','DUKES','DUNCAN',
                'DUNCOMBE','DUNNES','DUNSHEE','DUNSMUIR','DUTCH WINDMILL ACCESS','DWIGHT','E','EAGLE',
                'EARL','EASEMENT','EAST','EAST BEACH','EAST CRYSTAL COVE','EAST FORT MILEY','EASTMAN','EASTWOOD','EATON','ECKER',
                'EDDY','EDGAR','EDGARDO','EDGEHILL','EDGEWOOD','EDIE','EDINBURGH','EDITH','EDNA','EDWARD',
                'EGBERT','EL CAMINO DEL MAR','EL DORADO','EL MIRASOL','EL PLAZUELA','EL POLIN','EL SERENO','EL VERANO','ELDRIDGE',
                'ELGIN','ELIM','ELIZABETH','ELK','ELLERT','ELLINGTON','ELLIOT','ELLIS','ELLSWORTH',
                'ELM','ELMHURST','ELMIRA','ELMWOOD','ELSIE','ELWOOD','EMERALD','EMERALD COVE','EMERSON','EMERY',
                'EMIL','EMMA','EMMETT','ENCANTO','ENCINAL','ENCLINE','ENGLISH','ENTERPRISE','ENTRADA',
                'ERIE','ERKSON','ERVINE','ESCOLTA','ESCONDIDO','ESMERALDA','ESPANOLA','ESQUINA','ESSEX',
                'ESTERO','EUCALYPTUS','EUCLID','EUGENIA','EUREKA','EVANS','EVE','EVELYN','EVERGLADE',
                'EVERSON','EWER','EWING','EXCELSIOR','EXCHANGE','EXECUTIVE PARK','EXETER','EXPOSITION','FAIR','FAIR OAKS','FAIRBANKS',
                'FAIRFAX','FAIRFIELD','FAIRMOUNT','FAITH','FALLON','FALMOUTH','FANNING','FARALLONES',
                'FARGO','FARNSWORTH','FARNUM','FARRAGUT','FARVIEW','FAUNTLEROY','FAXON',
                'FEDERAL','FELIX','FELL','FELL ACCESS','FELLA','FELTON','FENTON','FERN','FERNANDEZ','FERNWOOD',
                'FIELDING','FIFTH','FILBERT','FILLMORE','FINLEY','FIRST','FIRST','FISHER','FISHER','FISHER','FITCH','FITZGERALD',
                'FLINT','FLOOD','FLORA','FLORENCE','FLORENTINE','FLORIDA','FLOUNDER','FLOURNOY','FLOWER','FOERSTER','FOLSOM','FONT','FONTINELLA',
                'FOOTE','FORD','FOREST','FOREST HILL','FOREST KNOLLS','FOREST SIDE','FOREST VIEW','FORSYTH','FORT FUNSTON','FORTUNA',
                'FOUNTAIN','FOWLER','FRANCE','FRANCIS','FRANCISCO','FRANCONIA','FRANK NORRIS','FRANKLIN','FRATESSA','FREDELA','FREDERICK','FREDSON',
                'FREELON','FREEMAN','FREMONT','FRENCH','FRESNEL','FRESNO','FRIDA KAHLO','FRIEDELL','FRIENDSHIP','FRONT','FUENTE',
                'FULTON','FUNSTON','FUNSTON','GABILAN','GAISER','GALEWOOD','GALILEE','GALINDO',
                'GALLAGHER','GALVEZ','GAMBIER','GARCES','GARCIA','GARDEN','GARDEN','GARDENER','GARDENSIDE','GARFIELD','GARLINGTON','GARNETT','GARRISON',
                'GATES','GATEVIEW','GATEVIEW','GATEVIEW 1','GATEVIEW 2','GATEVIEW 3','GATUN','GAVEN','GAVIOTA','GEARY','GEARY','GELLERT',
                'GENE FRIEND','GENEBERN','GENERAL KENNEDY','GENEVA','GENNESSEE','GENOA','GEORGE','GEORGIA','GERKE',
                'GERMANIA','GETZ','GGP ACCESS ROAD','GIANTS','GIBB','GIBBON','GIBBON','GIBSON','GILBERT','GILLETTE','GILMAN','GILROY','GIRARD',
                'GIRARD','GLADEVIEW','GLADIOLUS','GLADSTONE','GLADYS','GLEN','GLENBROOK','GLENDALE','GLENHAVEN','GLENVIEW','GLOBE','GLORIA','GLOVER','GODEUS',
                'GOETHE','GOETTINGEN','GOLD','GOLD MINE','GOLDBERG','GOLDEN','GOLDEN GATE','GOLDING','GOLETA','GOLF COURSE ACCESS','GONZALEZ',
                'GORDON','GORGAS','GORHAM','GOUGH','GOULD','GRACE','GRAFTON','GRAHAM','GRANADA','GRAND VIEW','GRANT','GRANVILLE','GRATTAN','GRAYSTONE',
                'GREAT','GREELY','GREEN','GREENOUGH','GREENVIEW','GREENWICH','GREENWOOD','GRENARD','GRIFFITH','GRIJALVA','GROTE','GROVE','GUERRERO','GUTTENBERG','GUY',
                'H','HABITAT','HAGIWARA TEA GARDEN','HAHN','HAIGHT','HALE','HALIBUT','HALLAM','HALLECK','HALYBURTON','HAMERTON','HAMILTON',
                'HAMLIN','HAMPSHIRE','HANCOCK','HANGAH','HANOVER','HARBOR','HARDIE','HARDIE','HARDING','HARE','HARKNESS',
                'HARLAN','HARLEM','HARLOW','HARNEY','HAROLD','HARPER','HARRIET','HARRIET','HARRINGTON','HARRIS','HARRISON','HARRISON','HARRY','HARTFORD',
                'HARVARD','HASTINGS','HATTIE','HAVELOCK','HAVENS','HAVENSIDE','HAWES','HAWKINS','HAWTHORNE','HAYES',
                'HAYS','HAYWARD','HAZELWOOD','HEAD','HEALY','HEARST','HEATHER','HELEN','HELENA','HEMLOCK','HEMWAY',
                'HENRY','HENRY ADAMS','HERITAGE','HERMANN','HERNANDEZ','HERON','HESTER','HEYMAN','HICKORY','HICKS','HIDALGO','HIGH',
                'HIGHLAND','HIGUERA','HILIRITAS','HILL','HILL','HILL POINT','HILLCREST','HILLCREST','HILLSIDE','HILLVIEW','HILLWAY',
                'HILTON','HIMMELMANN','HITCHCOCK','HITCHCOCK','HOBART','HODGES','HOFF','HOFFMAN','HOFFMAN','HOLLADAY','HOLLAND','HOLLIS',
                'HOLLISTER','HOLLOWAY','HOLLY PARK','HOLLYWOOD','HOLYOKE','HOMER','HOMESTEAD','HOMEWOOD','HOOKER','HOOPER',
                'HOPKINS','HORACE','HORNE','HOTALING','HOUSTON','HOWARD','HOWARD','HOWARD','HOWTH','HUBBELL','HUDSON',
                'HUGO','HULBERT','HUMBOLDT','HUNT','HUNTER','HUNTER','HUNTERS POINT','HUNTERS POINT','HUNTINGTON','HURON','HUSSEY','HUTCHINS',
                'HYDE','I','I-280 N OFF','I-280 N ON','I-280 NORTHBOUND','I-280 S OFF','I-280 S ON','I-280 SOUTHBOUND','I-280 TO HWY 101','I-80 E OFF','I-80 E ON',
                'I-80 EASTBOUND','I-80 TO HWY 101','I-80 W OFF','I-80 W ON','I-80 WESTBOUND','ICEHOUSE','IDORA','IGNACIO','ILLINOIS',
                'ILS','IMPERIAL','INA','INCA','INCINERATOR','INDIA','INDIANA','INDUSTRIAL',
                'INDUSTRIAL ST OFF','INDUSTRIAL ST ON','INFANTRY','INGALLS','INGERSON','INGLESIDE','INNES','INNES',
                'INVERNESS','IOWA','IRIS','IRON','IRONWOOD','IRVING','IRWIN','ISADORA DUNCAN','ISIS','ISLAIS','ISOLA',
                'ISSLEIB','ITALY','IVY','J','JACK BALESTRERI','JACK KEROUAC','JACK LONDON','JACK MICHELINE','JACKSON','JADE','JAKEY',
                'JAMES','JAMESTOWN','JANSEN','JARBOE','JASON','JASPER','JAUSS','JAVA','JEAN','JEFFERSON',
                'JENNIFER','JENNINGS','JENNINGS','JEROME','JERROLD','JERSEY','JESSIE','JESSIE EAST','JESSIE WEST','JEWETT','JOHN','JOHN F KENNEDY',
                'JOHN F SHELLEY','JOHN MAHER','JOHN MUIR','JOHNSTONE','JOICE','JONES','JOOST','JORDAN','JOSE SARRIA','JOSEPHA',
                'JOSIAH','JOY','JUAN BAUTISTA','JUANITA','JUDAH','JUDSON','JULES','JULIA','JULIAN','JULIUS',
                'JUNIOR','JUNIPER','JUNIPERO SERRA','JUNIPERO SERRA BLVD OFF','JUNIPERO SERRA BLVD ON','JURI','JUSTIN','KALMANOVITZ','KAMILLE','KANSAS','KAPLAN',
                'KAREN','KATE','KEARNY','KEARNY','KEITH','KELLOCH','KEMPTON','KENDALL','KENNEDY','KENNETH REXROTH','KENNY',
                'KENSINGTON','KENT','KENWOOD','KEPPLER','KERN','KEY','KEYES','KEYES','KEYSTONE','KEZAR','KIMBALL',
                'KING','KINGSTON','KINZEY','KIRKHAM','KIRKWOOD','KISKA','KISSLING','KITTREDGE','KNOCKASH','KNOLLVIEW','KNOTT','KOBBE',
                'KOHLER','KORET','KRAMER','KRAUSGRILL','KRONQUIST','LA AVANZADA','LA BICA','LA FERRERA','LA GRANDE','LA PLAYA','LA SALLE','LAFAYETTE',
                'LAGUNA','LAGUNA HONDA','LAGUNITAS','LAIDLEY','LAKE','LAKE FOREST','LAKE MERCED','LAKESHORE','LAKESHORE','LAKEVIEW','LAKEWOOD',
                'LAMARTINE','LAMSON','LANCASTER','LANDERS','LANE','LANGDON','LANGTON','LANSDALE','LANSING','LAPHAM','LAPIDGE',
                'LAPU-LAPU','LARCH','LARKIN','LAS VILLAS','LASKIE','LASSEN','LATHROP','LATONA','LAURA','LAUREL',
                'LAUREN','LAUSSAT','LAWRENCE','LAWTON','LE CONTE','LE CONTE','LEAVENWORTH','LEDYARD','LEE','LEESE',
                'LEGION','LEGION OF HONOR','LEIDESDORFF','LELAND','LENDRUM','LENOX','LEO','LEONA','LEROY',
                'LESSING','LESTER','LETTERMAN','LETTERMAN HOSPITAL ACCESS','LETTUCE','LEVANT','LEXINGTON','LIBERTY','LICK','LIEBIG','LIGGETT','LILAC',
                'LILLIAN','LILY','LINARES','LINCOLN','LINCOLN','LINCOLN','LINDA','LINDA VISTA','LINDEN',
                'LINDSAY','LIPPARD','LISBON','LITTLEFIELD','LIVINGSTON','LLOYD','LOBOS','LOCKSLEY',
                'LOCKWOOD','LOCUST','LOEHR','LOIS','LOMA VISTA','LOMBARD','LOMITA','LONDON','LONE MOUNTAIN','LONG','LONG BRIDGE',
                'LONGVIEW','LOOMIS','LOPEZ','LORAINE','LORI','LOS PALMOS','LOTTIE BENNETT','LOUISBURG','LOUISIANA','LOWELL','LOWER',
                'LOWER FORT MASON','LOYOLA','LUCERNE','LUCKY','LUCY','LUDLOW','LULU','LUNADO','LUNADO','LUNDEEN','LUNDYS',
                'LUPINE','LURLINE','LURMONT','LUSK','LYDIA','LYELL','LYNCH','LYNDHURST','LYON','LYSETTE',
                'MABEL','MABINI','MABREY','MACALLA','MACALLA','MACARTHUR','MACEDONIA','MACONDRAY','MADDUX','MADERA','MADISON',
                'MADRID','MADRONE','MAGELLAN','MAGNOLIA','MAHAN','MAIDEN','MAIN','MAIN','MAJESTIC','MALDEN','MALLORCA',
                'MALTA','MALVINA','MANCHESTER','MANDALAY','MANGELS','MANOR','MANSEAU','MANSELL','MANSFIELD','MANZANITA','MAPLE','MARCELA',
                'MARCY','MARENGO','MARGARET','MARGRAVE','MARIETTA','MARIN','MARINA','MARINA GREEN','MARINE','MARINER','MARION',
                'MARIPOSA','MARIST','MARK','MARK TWAIN','MARKET','MARLIN','MARNE','MARS','MARSHALL','MARSILY','MARSTON','MARTHA',
                'MARTIN','MARTIN LUTHER KING JR','MARTINEZ','MARVEL','MARVIEW','MARY','MARY TERESA','MARYLAND','MASON',
                'MASON','MASONIC','MASSACHUSETTS','MASSASOIT','MATEO','MATTHEW','MAULDIN','MAXWELL','MAYFAIR','MAYFLOWER','MAYNARD','MAYWOOD',
                'MCALLISTER','MCCANN','MCCARTHY','MCCOPPIN','MCCORMICK','MCDONALD','MCDOWELL','MCKINLEY','MCKINNON','MCLAREN','MCLAREN LODGE ACCESS',
                'MCLEA','MCNAIR','MCRAE','MCRAE','MEACHAM','MEADE','MEADOWBROOK','MEDA','MEDAU','MEDICAL CENTER','MEGAN',
                'MELBA','MELRA','MELROSE','MENDELL','MENDOSA','MENOHER','MERCATO','MERCED','MERCEDES','MERCHANT','MERCHANT',
                'MERCURY','MERLIN','MERRIAM','MERRIE','MERRILL','MERRIMAC','MERRITT','MERSEY','MESA','MESA',
                'METSON','MICHIGAN','MIDCREST','MIDDLE POINT','MIDDLE WEST','MIDDLEFIELD','MIDWAY','MIGUEL','MILAN','MILES','MILES',
                'MILEY','MILL','MILLER','MILLER','MILLWRIGHT COTTAGE ACCESS','MILTON','MILTON I ROSS','MINERVA','MINNA','MINNESOTA','MINT',
                'MINT','MIRABEL','MIRALOMA','MIRAMAR','MIRANDO','MISSION','MISSION BAY','MISSION ROCK',
                'MISSISSIPPI','MISSOURI','MISTRAL','MIZPAH','MODOC','MOFFITT','MOJAVE','MOLIMO',
                'MONCADA','MONETA','MONETA','MONO','MONTAGUE','MONTALVO','MONTANA',
                'MONTCALM','MONTCLAIR','MONTE VISTA','MONTECITO','MONTEREY','MONTEZUMA','MONTGOMERY','MONTICELLO','MONUMENT','MOORE',
                'MOORE','MORAGA','MORAGA','MORELAND','MORGAN','MORNINGSIDE','MORRELL','MORRELL','MORRIS','MORSE','MORTON','MOSCOW',
                'MOSS','MOULTON','MOULTRIE','MOUNT','MOUNT VERNON','MOUNTAIN SPRING','MOUNTVIEW','MUIR','MUIR','MULFORD',
                'MULLEN','MUNICH','MURRAY','MURRAY','MUSEUM','MUSIC CONCOURSE','MUSIC CONCOURSE ACCESS','MYRA','MYRTLE','NADELL',
                'NAGLEE','NAHUA','NANCY PELOSI','NANTUCKET','NAPIER','NAPLES','NAPOLEON','NATICK','NATOMA','NAUMAN','NAUTILUS',
                'NAVAJO','NAVY','NAYLOR','NEBRASKA','NELLIE','NELSON','NELSON RISING','NEPTUNE','NEVADA','NEW MONTGOMERY','NEWBURG','NEWCOMB',
                'NEWELL','NEWHALL','NEWMAN','NEWTON','NEY','NIAGARA','NIANTIC','NIBBI','NICHOLS','NIDO','NIMITZ',
                'NIMITZ','NIMITZ','NOB HILL','NOBLES','NOE','NORDHOFF','NORFOLK','NORIEGA','NORMANDIE','NORTH','NORTH GATE','NORTH HUGHES',
                'NORTH POINT','NORTH VAN HORN','NORTH VIEW','NORTHGATE','NORTHPOINT','NORTHRIDGE','NORTHWOOD','NORTON','NORWICH','NOTTINGHAM',
                'NUEVA','OAK','OAK ACCESS','OAK GROVE','OAK PARK','OAKDALE','OAKHURST','OAKWOOD','OCEAN','OCEANVIEW','OCTAVIA',
                'ODD FELLOWS','OFARRELL','OGDEN','OHLONE','OLD CHINATOWN','OLD MASON','OLIVE','OLIVER','OLMSTEAD','OLNEY','OLORAN',
                'OLYMPIA','OLYMPIC COUNTRY CLUB','OMAR','ONEIDA','ONIQUE','ONONDAGA','OPAL','OPALO','OPHIR','ORA',
                'ORANGE','ORBEN','ORD','ORD','ORDWAY','OREILLY','ORIOLE','ORIZABA','ORSI','ORTEGA',
                'ORTEGA','OSAGE','OSCAR','OSCEOLA','OSGOOD','OSHAUGHNESSY','OTEGA','OTIS','OTSEGO',
                'OTTAWA','OTTER COVE','OVERLOOK','OWEN','OWENS','OXFORD','OZBOURN','PACHECO','PACIFIC',
                'PAGE','PAGODA','PALACE','PALM','PALM','PALMETTO','PALO ALTO','PALOMA','PALOS',
                'PALOU','PANAMA','PANORAMA','PARADISE','PARAISO','PARAMOUNT','PARIS','PARK',
                'PARK','PARK HILL','PARK PRESIDIO','PARK PRESIDIO BYPASS','PARKER',
                'PARKHURST','PARKRIDGE','PARNASSUS','PARQUE','PARSONS','PASADENA','PATTEN',
                'PATTERSON','PATTON','PATTON','PAUL','PAULDING','PAYSON','PEABODY','PEARL','PEEK',
                'PELICAN COVE','PELTON','PEMBERTON','PENA','PENINSULA','PENNINGTON','PENNSYLVANIA','PENNY','PERALTA','PERASTO',
                'PEREGO','PERIMETER','PERINE','PERRY','PERSHING','PERSIA','PERU','PETER YORKE','PETERS','PETRARCH',
                'PFEIFFER','PHELPS','PHOENIX','PICO','PIEDMONT','PIERCE','PIERPOINT','PILGRIM','PINAR','PINE','PINEHURST','PINK','PINO',
                'PINTO','PIOCHE','PIPER','PIXLEY','PIZARRO','PLAZA','PLEASANT','PLUM','PLYMOUTH','POINT LOBOS',
                'POLARIS','POLK','POLLARD','POLLOCK','POMONA','POND','PONTIAC','POPE','POPE','POPE',
                'POPLAR','POPPY','PORTAL','PORTAL','PORTER','PORTOLA','PORTOLA','POST','POTOMAC','POTRERO',
                'POWELL','POWERS','POWHATTAN','PRADO','PRAGUE','PRATT','PRECITA','PRENTISS','PRESCOTT','PRESIDIO','PRETOR','PRIEST',
                'PRINCETON','PROGRESS','PROSPECT','PROSPER','PUBLIC','PUEBLO','PULASKI','PUTNAM','QUANE','QUARRY',
                'QUARTZ','QUEBEC','QUESADA','QUICKSTEP','QUINCY','QUINT','QUINTARA','R','RACCOON',
                'RACINE','RADIO','RAE','RALEIGH','RALSTON','RALSTON','RAMONA','RAMSEL',
                'RAMSELL','RANDALL','RANDOLPH','RANKIN','RAUSCH','RAVENWOOD','RAWLES','RAYBURN','RAYCLIFF','RAYMOND','REARDON','REBECCA',
                'RECYCLE','RECYCLING CENTER ACCESS','RED LEAF','RED ROCK','REDDY','REDFIELD','REDONDO','REDWOOD','REED',
                'REEVES','REGENT','RENO','REPOSA','RESERVOIR','RESTANI','RESTANI','RETIRO','REUEL','REVERE','REX','REY','RHINE','RHODE ISLAND','RICE',
                'RICHARD HENRY DANA','RICHARDS','RICHARDSON','RICHLAND','RICHTER','RICKARD','RICO','RIDGE','RIDGE','RIDGEWOOD',
                'RILEY','RINCON','RINGOLD','RIO','RIO VERDE','RIPLEY','RITCH','RIVAS','RIVERA','RIVERTON','RIVOLI','RIZAL',
                'ROACH','ROANOKE','ROBBLEE','ROBERT C LEVY','ROBERT KIRK','ROBINHOOD','ROBINSON',
                'ROBINSON','ROCK','ROCKAWAY','ROCKDALE','ROCKLAND','ROCKRIDGE','ROCKWOOD',
                'ROD','RODGERS','RODRIGUEZ','ROEMER','ROLPH','ROMAIN','ROME','ROMOLO','RONDEL','ROOSEVELT','ROSA PARKS','ROSCOE','ROSE',
                'ROSELLA','ROSELYN','ROSEMARY','ROSEMONT','ROSENKRANZ','ROSEWOOD','ROSIE LEE','ROSS',
                'ROSSI','ROSSMOOR','ROTTECK','ROUSSEAU','ROYAL','RUCKMAN',
                'RUDDEN','RUGER','RUSS','RUSSELL','RUSSIA','RUSSIAN HILL','RUTH','RUTLAND','RUTLEDGE','SABIN','SACRAMENTO','SADDLEBACK',
                'SADOWA','SAFIRA','SAGAMORE','SAINT CHARLES','SAINT CROIX','SAINT ELMO','SAINT FRANCIS','SAINT FRANCIS','SAINT GEORGE',
                'SAINT GERMAIN','SAINT JOSEPHS','SAINT LOUIS','SAINT MARYS','SAL',
                'SALA','SALINAS','SALMON','SAM JORDANS','SAMOSET','SAMPSON','SAN ALESO','SAN ANDREAS','SAN ANSELMO','SAN ANTONIO',
                'SAN BENITO','SAN BRUNO','SAN BRUNO AV OFF','SAN BRUNO AV ON','SAN BUENAVENTURA','SAN CARLOS','SAN DIEGO',
                'SAN FELIPE','SAN FERNANDO','SAN FRANCISCO GOLF CLUB','SAN GABRIEL','SAN JACINTO','SAN JOSE',
                'SAN JOSE AV OFF','SAN JOSE AV ON','SAN JUAN','SAN LEANDRO','SAN LORENZO','SAN LUIS','SAN MARCOS','SAN MIGUEL','SAN PABLO',
                'SAN RAFAEL','SAN RAMON','SANCHES','SANCHEZ','SANDPIPER COVE','SANSOME','SANTA ANA','SANTA BARBARA','SANTA CLARA',
                'SANTA CRUZ','SANTA FE','SANTA MARINA','SANTA MONICA','SANTA PAULA','SANTA RITA','SANTA ROSA',
                'SANTA YNEZ','SANTA YSABEL','SANTIAGO','SANTOS','SARGENT','SAROYAN','SATURN',
                'SAUL','SAWYER','SCENIC','SCHOFIELD','SCHOFIELD','SCHOOL','SCHWERIN','SCIENCE','SCOTIA',
                'SCOTLAND','SCOTT','SCOT','SEA VIEW',
                'SEACLIFF','SEAL COVE','SEAL ROCK','SEARS','SEAWELL','SECOND','SECURITY PACIFIC','SELBY','SELMA','SEMINOLE',
                'SENECA','SEQUOIA','SERGEANT JOHN V YOUNG','SERRANO',
                'SERVICE','SEVERN','SEVILLE','SEWARD','SEYMOUR','SFGH ACCESS','SHAFTER','SHAFTER','SHAFTER','SHAKESPEARE','SHANNON','SHARON','SHARP',
                'SHAW','SHAWNEE','SHELDON','SHEPHARD','SHERIDAN','SHERIDAN','SHERMAN','SHERMAN','SHERWOOD',
                'SHIELDS','SHIP','SHIPLEY','SHORE VIEW','SHORT','SHOTWELL','SHOUP','SHRADER','SIBERT','SIBERT',
                'SIBLEY','SICKLES','SIERRA','SIGNAL','SILLIMAN','SILVER','SILVERVIEW','SIMONDS',
                'SIXTH','SKYLINE','SKYVIEW','SLOAN','SLOAT','SMITH','SOLA','SOMERSET','SONOMA','SONORA','SOTELO','SOULE','SOUTH','SOUTH GATE',
                'SOUTH HILL','SOUTH HUGHES','SOUTH PARK','SOUTH VAN HORN','SOUTH VAN NESS','SOUTHARD',
                'SOUTHERN HEIGHTS','SOUTHWOOD','SPARROW','SPARTA','SPEAR','SPEAR',
                'SPENCER','SPOFFORD','SPRECKELS LAKE','SPRING','SPRINGFIELD','SPROULE','SPRUCE','STANDISH',
                'STANFORD','STANFORD HEIGHTS','STANLEY','STANTON','STAPLES','STARK',
                'STARR KING','STARVIEW','STATE','STATES','STEINER','STERLING','STERN GROVE','STERNBERG','STEUART','STEUBEN',
                'STEVELOE','STEVENSON','STILL','STILLINGS','STILLMAN','STILWELL','STOCKTON','STONE','STONECREST','STONEMAN',
                'STONERIDGE','STONEYBROOK','STONEYFORD','STOREY','STORRIE','STOW LAKE','STRATFORD','STRIPED BASS','STURGEON',
                'SUMMIT','SUMMIT','SUMNER','SUMNER','SUNBEAM','SUNGLOW','SUNNYDALE','SUNNYSIDE','SUNRISE',
                'SUNSET','SUNSET BLVD OFF','SUNSET BLVD ON','SUNVIEW','SURREY','SUSSEX','SUTRO HEIGHTS','SUTTER',
                'SWEENY','SWISS','SYCAMORE','SYDNEY','SYLVAN','TABER','TACOMA','TALBERT','TALBERT','TAMALPAIS',
                'TAMPA','TANDANG SORA','TAPIA','TARA','TARAVAL','TAYLOR','TAYLOR',
                'TEDDY','TEHAMA','TELEGRAPH','TELEGRAPH HILL',
                'TEMESCAL','TEMPLE','TENNESSEE','TENNY','TERESITA','TERRA VISTA','TERRACE','TERRACE','TERRY A FRANCOIS','TEVIS',
                'TEXAS','THE EMBARCADERO','THERESA','THOMAS','THOMAS','THOMAS MELLON',
                'THOMAS MORE','THOR','THORNBURG','THORNE','THORNTON','THORP',
                'THRIFT','TIFFANY','TILLMAN','TIMOTHY PFLUEGER','TINGLEY','TIOGA','TOCOLOMA','TODD','TOLAND',
                'TOLEDO','TOLL PLAZA TUNNEL','TOMASO','TOMPKINS','TONQUIN','TOPAZ',
                'TOPEKA','TORNEY','TORRENS','TOUCHARD','TOWERSIDE','TOWNSEND',
                'TOYON','TRADER VIC','TRAINOR','TRANSBAY HUMP','TRANSBAY LOOP','TRANSVERSE',
                'TREASURE ISLAND','TREASURY','TREAT','TRENTON','TRINITY',
                'TROY','TRUBY','TRUETT','TRUMBULL','TUBBS','TUCKER','TULANE','TULARE','TULIP','TUNNEL','TURK',
                'TURK MURPHY','TURNER','TURQUOISE','TUSCANY','TWIN PEAKS','ULLOA','UNDERWOOD','UNION',
                'UNITED NATIONS','UNIVERSITY','UPLAND','UPPER','UPPER SERVICE','UPTON',
                'UPTON','URANUS','URBANO','UTAH','VALDEZ','VALE',
                'VALENCIA','VALERTON','VALLEJO','VALLETTA','VALLEY','VALMAR',
                'VALPARAISO','VAN BUREN','VAN DYKE','VAN KEUREN','VAN NESS',
                'VANDEWATER','VARA','VARELA','VARENNES','VARNEY','VASQUEZ','VASSAR','VEGA','VELASCO','VENARD','VENTURA',
                'VENUS','VER MEHR','VERDI','VERDUN','VERMONT','VERNA','VERNON','VESTA','VETERANS','VIA BUFANO','VIA FERLINGHETTI',
                'VICENTE','VICKSBURG','VICTORIA','VIDAL','VIENNA','VILLA','VINE','VINTON','VIRGIL','VIRGINIA','VISITACION','VISTA',
                'VISTA','VISTA VERDE','VISTA VIEW','VON SCHMIDT','VULCAN','WABASH','WAGNER','WAITHMAN','WALBRIDGE','WALDO',
                'WALKER','WALKWAY','WALL','WALLACE','WALLEN','WALLER','WALNUT','WALTER','WALTER U LUM',
                'WALTHAM','WANDA','WARD','WARE','WARNER','WARREN','WARRIORS','WASHBURN','WASHINGTON','WATCHMAN','WATER',
                'WATERFRONT','WATERLOO','WATERVILLE','WATT','WATTSON','WAVERLY','WAWONA','WAYLAND','WAYNE','WEBB',
                'WEBSTER','WEDEMEYER','WELDON','WELSH','WENTWORTH','WEST','WEST BROADWAY',
                'WEST CLAY','WEST CRYSTAL COVE','WEST HALLECK',
                'WEST PACIFIC','WEST POINT','WEST PORTAL','WEST VIEW','WESTBROOK','WESTERN SHORE','WESTGATE',
                'WESTMOORLAND','WESTON','WESTSIDE','WESTWOOD','WETMORE',
                'WHEAT','WHEELER','WHIPPLE','WHIPPLE','WHITE','WHITECLIFF','WHITFIELD','WHITING','WHITING',
                'WHITNEY','WHITNEY YOUNG','WHITTIER','WIESE','WILDE','WILDER','WILDWOOD','WILLARD',
                'WILLARD','WILLIAMS','WILLIAR','WILLIE B KENNEDY','WILLOW','WILLS','WILMOT',
                'WILSON','WINDING','WINDSOR','WINFIELD','WINN','WINSTON','WINTER','WINTHROP','WISCONSIN','WISSER',
                'WOOD','WOODACRE','WOODHAVEN','WOODLAND','WOODSIDE','WOODWARD','WOOL','WOOL','WOOLSEY',
                'WORCESTER','WORDEN','WORTH','WRIGHT','WYMAN','WYTON','YACHT',
                'YALE','YELLOW CAB ACCESS ROAD','YERBA BUENA','YORBA','YORK','YOSEMITE','YOUNG','YUKON',
                'ZAMPA','ZANOWITZ','ZENO','ZIRCON','ZOE','ZOO']

streetSuffix = ['Aly', 'Ave', 'Blv', 'Cir', 'Ct',
                'Dr', 'Expy', 'Hl', 'Hwy', 'Ln',
                'Loop', 'Park', 'Path', 'Pl', 'Plz',
                'Ramp', 'Rd', 'Row', 'St', 'Ter',
                'Tun', 'Walk', 'Way', 'Stwy']

countDonor = 1
nameTracker = []

def gen_name(p, m, s):
    name = bizPrefix[p].title() + " " + bizMiddle[m] + " " + bizSuffix[s]
    return name

with open('data/donors.csv', mode = 'w') as donor_file:
    donor_writer = csv.writer(donor_file, delimiter = ',', quotechar = '"', quoting = csv.QUOTE_MINIMAL)

    # id, paymentid, companyname, street address, phone number

    while countDonor <= 339000:
        # Create the donor list
        donor = []

        # Donor ID
        donor.append(countDonor)

        # Payment ID
        donor.append(countDonor)

        # Company name
        while True:
            # Generate a random business name
            bizPre = randint(0, 90)
            bizMid = randint(0, 90)
            bizSuf = randint(0, 40)
            # print(bizPre)

            name = gen_name(bizPre,bizMid, bizSuf)

            if name in nameTracker:
                continue
            else:
                nameTracker.append(name)
                donor.append(name)
                break

        # Generage a random business address
        addNum = randint(1, 1000)
        addPre = randint(1, 2250)
        addSuf = randint(1, 20)

        # Address
        donor.append(str(addNum) + " " + streetPrefix[addPre].title() + " " + streetSuffix[addSuf])

        # Phone
        phoneArea = randint(100, 1000)
        phonePre = randint(100, 1000)
        phoneSuf = randint(1000, 10000)

        donor.append("1-"+str(phoneArea)+'-'+str(phonePre)+'-'+str(phoneSuf))

        countDonor += 1
        donor_writer.writerow(donor)
