<?php include "../inc/dbinfo.inc"; ?>
<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">

    <!--Import Bootstrap -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

    <!-- Import CSS-->
    <link href="./css/style.css" rel="stylesheet" type="text/css" media="screen"/>
    <link rel="stylesheet" href="css/search.css">
    <link rel="stylesheet" href="css/back-to-top.css">

    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.9.0/css/all.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.9.0/css/v4-shims.css">

    <!-- Import Fonts-->
    <link href='https://fonts.googleapis.com/css?family=Roboto:300' rel='stylesheet' type='text/css'>
    <link href="https://fonts.googleapis.com/css?family=Lato&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Anton&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Raleway&display=swap" rel="stylesheet">

    <!-- Gallery -->
    <link rel="stylesheet" href="css/gallery.theme.css">
    <link rel="stylesheet" href="css/gallery.min.css">

</head>

<body>
<?php

/* Connect to MySQL and select the database. */
$connection = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD);

if (mysqli_connect_errno()) echo "Failed to connect to MySQL: " . mysqli_connect_error();

$database = mysqli_select_db($connection, DB_DATABASE);

/* Ensure that the EMPLOYEES table exists. */
VerifyDBConnection($connection, DB_DATABASE);

?>
<!--BEGIN NAVIGATION-->
<header>
    <div class="navigation">
        <nav class="navbar navbar-expand-lg navbar-light" id="navbarNavLeft"><!-- bg-primary-->
            <a class="navbar-brand" href="index.html">NJBA</a>

            <div class="collapse navbar-collapse">
                <ul class="nav navbar-nav mr-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="scores.php">SCORES</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="standings.php">STANDINGS</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="schedule.php">SCHEDULE</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="stats.php" style="color:yellow !important;"><b>STATS</b></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="players.php">PLAYERS</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="teams.php">TEAMS</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">VIDEO</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">NEWS</a>
                    </li>
                </ul>
            </div>
            <div class="collapse navbar-collapse" id="navbarNavRight">
                <ul class="nav navbar-nav ml-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#">TICKETS</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="underconstruction.php">SHOP</a>
                    </li>
                </ul>
                <div class="search">
                    <div>
                        <input type="text" placeholder="Search" required>
                    </div>
                </div>
            </div>
        </nav>
    </div>
</header>
<!--END NAVIGATION-->

<!--BEGIN CONTENT-->
<div class="container ad">
    <div class="flexbox">
        <div class="banner_ad728x90">ADVERTISEMENT PLACEHOLDER</div>
    </div>
</div>

<div class="container" id="content">
    <div class="flexbox">
        <div class="row" style="padding-top: 20px;" >
            <div class="col-lg-12" style="padding-right: 5px; padding-left: 20px;">

                <div id="middle-section" class="flexbox center-news" style="margin-top: 0;">

<!--                    <div><input type="radio" name="run" value="team" checked> Team &nbsp&nbsp&nbsp-->
<!--                         <input type="radio" name="run" value="player"> Player</div>-->
<!--                    <br>-->

                    <?php

                    // Our select statement. This will retrieve the data that we want.
                    $sql = mysqli_query($connection,"select DISTINCT idseason, 
                                                            CONCAT(type, ' ', YEAR(start_date), ' - ', 
                                                                YEAR(end_date)) as season 
                                                            from leaderboard l join season s 
                                                                on l.season_idseason = s.idseason");
                    ?>

                    <form action="#" method="get">
                        <select name="select_id">
                            <?php foreach($sql as $item): ?>
                                <option value="<?= $item['idseason']; ?>"><?= $item['season']; ?></option>
                            <?php endforeach; ?>
                        </select>
                        &nbsp;&nbsp;
                        <input id="submit" type="submit" name="submit" value="Filter" />
                    </form>

                    <br>

                    <!-- Display table data. -->
                    <table border="1"  class="stats">
                        <tr bgcolor="#cd5c5c" color="#fff">
                            <td>Player</td>
                            <td>PTS</td>
                            <td>MIN</td>
                            <td>FGM</td>
                            <td>FGA</td>
                            <td>FG%</td>
                            <td>FG3</td>
                            <td>FG3A</td>
                            <td>FT</td>
                            <td>FTA</td>
                            <td>FT%</td>
                            <td>ORD</td>
                            <td>DRB%</td>
                            <td>TRB</td>
                            <td>AST</td>
                            <td>BLK</td>
                            <td>TOV</td>
                            <td>FLS</td>
                        </tr>

                        <?php

                        if(isset($_GET['submit'])){
                            $temp = $_GET['select_id'];  // Storing Selected Value In Variable
                        }

                        if(isset($_POST['radio'])){
                            $temp2 = $_POST['run'];  // Storing Selected Value In Variable
                        }
                        $result = mysqli_query($connection,
                            "select full_name, points, mins, fgm, fga, 
                                    fg_pct, fg3, fg3a, fg3_pct, ft, fta, ft_pct, orb, drb, 
                                    trb, assists, blocks, turnovers, fouls 
                                    from player_avg 
                                    where season_idseason = '".$temp."' order by points desc limit 100");

                        while($query_data = mysqli_fetch_row($result)) {
                            echo "<tr>";
                            echo "<td>",$query_data[0], "</td>",
                            "<td>",$query_data[1], "</td>",
                            "<td>",$query_data[2], "</td>",
                            "<td>",$query_data[3], "</td>",
                            "<td>",$query_data[4], "</td>",
                            "<td>",$query_data[5], "</td>",
                            "<td>",$query_data[6],"</td>",
                            "<td>",$query_data[7], "</td>",
                            "<td>",$query_data[8], "</td>",
                            "<td>",$query_data[9], "</td>",
                            "<td>",$query_data[10], "</td>",
                            "<td>",$query_data[11], "</td>",
                            "<td>",$query_data[12], "</td>",
                            "<td>",$query_data[13], "</td>",
                            "<td>",$query_data[14], "</td>",
                            "<td>",$query_data[15], "</td>",
                            "<td>",$query_data[16],"</td>",
                            "<td>",$query_data[17], "</td>";
                            echo "</tr>";
                        }
                        ?>

                    </table>

                    <!-- Clean up. -->
                    <?php

                    mysqli_free_result($result);
                    mysqli_close($connection);

                    ?>

                </div>
            </div>
        </div>
    </div>
</div>
<!--END CONTENT-->

<!--BEGIN FOOTER-->
<footer>
    <!--<hr>-->

    <!--BEGIN BOTTOM NAVIGATION-->



    <div class="row" id="bottom-navigation">
        <div class="col-lg-2">

        </div>
        <div class="navbar col-lg-2">
            <h1>NJBA</h1>
        </div>
        <div class="col-lg-2">
            <ul class="nav navbar-nav ml-auto">
                <li class="nav-item title">
                    LEAGUE INFO
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="standings.php">Standings</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="stats.php">Stats</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="schedule.php">Schedule</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">News</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="players.php">Players</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="teams.php">Teams</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="coaches.php">Coaches</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="scores.php">Scores</a>
                </li>
            </ul>
        </div>
        <div class="col-lg-2">
            <ul class="nav navbar-nav ml-auto">
                <li class="nav-item title">
                    CONNECT
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Youtube</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Twitter</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Facebook</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Instagram</a>
                </li>
            </ul>
        </div>
        <div class="col-lg-2">
            <ul class="nav navbar-nav ml-auto">
                <li class="nav-item title">
                    NJBA INFO
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="underconstruction.php">Store</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">2019 Combine</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="about.php">About the NJBA</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">FAQ</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Videos</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Feedback? Submit Here</a>
                </li>
            </ul>
        </div>
        <div class="col-lg-2">

        </div>
    </div>
    <!--END BOTTOM NAVIGATION-->

    <hr>

    <!--BEGIN COPYRIGHT-->
    <div class="container" id="footer">
        <p>
            Copyright 2019 NJBA Media | Matthew Frazier. All rights reserved. No portion of NJBA.com may be duplicated, redistributed or manipulated in any form. By accessing any information beyond this page, you agree to abide by the NJBA.com
        </p>
    </div>
    <!--END COPYRIGHT-->

</footer>
<!--END FOOTER-->


</body>

</html>



<?php

/* Check whether the table exists and, if not, create it. */
function VerifyDBConnection($connection, $dbName) {
    if(!TableExists("EMPLOYEES", $connection, $dbName))
    {
        $query = "CREATE TABLE EMPLOYEES (
         ID int(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
         NAME VARCHAR(45),
         ADDRESS VARCHAR(90)
       )";

        if(!mysqli_query($connection, $query)) echo("<p>Error creating table.</p>");
    }
}

/* Check for the existence of a table. */
function TableExists($tableName, $connection, $dbName) {
    $t = mysqli_real_escape_string($connection, $tableName);
    $d = mysqli_real_escape_string($connection, $dbName);

    $checktable = mysqli_query($connection,
        "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME = '$t' AND TABLE_SCHEMA = '$d'");

    if(mysqli_num_rows($checktable) > 0) return true;

    return false;
}
?>