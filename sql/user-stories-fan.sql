-- =====================================================
-- Author:      Matthew Frazier
-- Create date: 11/1/19
-- Description: Fan User Story SQL doc.
--              SQL statment for each user story in MVP.
-- =====================================================

-- A function is used for brevity. MySQL does not allow for parameters in SELECT queries.
-- Start Date
DROP FUNCTION IF EXISTS start_date;

DELIMITER //
CREATE FUNCTION start_date ()
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    RETURN '2019-08-01';
END //
DELIMITER ;


-- End Date
DROP FUNCTION IF EXISTS end_date;

DELIMITER //
CREATE FUNCTION end_date ()
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    RETURN '2069-06-13';
END //
DELIMITER ;

# 2
# As a Fan, I want to view box scores
# so that I quickly see the results of a previous game
-- Quick Team Summary
SELECT DISTINCT idgame,team_name,
       SUM(pts) AS team_points
FROM game g JOIN box_score b
    ON idgame = game_idgame
JOIN team
    ON team_idteam = idteam
WHERE date BETWEEN start_date() AND end_date()
GROUP BY 1,2
ORDER BY 2 ASC;


# 3
# As a Fan, I want to VIEW totals (standings)
# so that easily know each team’s ranking

# 3 Sub-tasks
# 1. Need to create a totals view that records wins AND losses
#       e.g. Totals VIEW attributes -> seasonid, teamid, wins, loses, win%, conference, division, home, road
# 2. Need to create a standings view that summarizes each team based ON totals view
# 3. Need to rank teams in standings

# Sub-task 1 - Create Totals View
DROP VIEW IF EXISTS totals;

CREATE VIEW totals AS
(
SELECT DISTINCT t1.idgame,
                t1.season_idseason,
                t1.home_team_id,
                t1.away_team_id,
                CASE
                    WHEN t1.team_points > t2.team_points
                        THEN t1.idteam
                    WHEN t1.team_points < t2.team_points
                        THEN t2.idteam
                    END AS win_team_id,
                CASE
                    WHEN t1.team_points < t2.team_points
                        THEN t1.idteam
                    WHEN t1.team_points > t2.team_points
                        THEN t2.idteam
                    END AS loss_team_id

FROM (
         SELECT idgame,
                team_name,
                idteam,
                home_team_id,
                away_team_id,
                season_idseason,
                SUM(pts) AS team_points
         FROM game g
                  JOIN box_score b
                       ON g.idgame = b.game_idgame
                  JOIN team t ON b.team_idteam = t.idteam
         GROUP BY 1, 2
         ORDER BY 1 ASC
     ) as t1
         INNER JOIN
     (
         SELECT idgame,
                team_name,
                idteam,
                home_team_id,
                away_team_id,
                season_idseason,
                SUM(pts) AS team_points
         FROM game g
                  JOIN box_score b
                       ON g.idgame = b.game_idgame
                  JOIN team t
                       ON b.team_idteam = t.idteam

         GROUP BY 1, 2
         ORDER BY 1 ASC
     ) as t2
     ON t1.idgame = t2.idgame
WHERE t1.team_name <> t2.team_name
HAVING win_team_id IS NOT NULL
   AND loss_team_id IS NOT NULL
    );


# Sub-task 2 - Create standings View
DROP VIEW IF EXISTS loss;

CREATE VIEW loss AS (
        select season_idseason,
           loss_team_id,
           count(loss_team_id) as loss
    from totals
    where
          (home_team_id = loss_team_id
             or away_team_id = loss_team_id)
    group by 1,2
    order by 1,2
);

DROP VIEW IF EXISTS win;

CREATE VIEW win AS (
    select season_idseason,
           win_team_id,
           count(win_team_id) as win
    from totals
    where (home_team_id = win_team_id
        or away_team_id = win_team_id)
    group by 1, 2
    order by 1, 2
);

select * from team;

DROP VIEW IF EXISTS standings;

CREATE VIEW standings AS (
    SELECT season_idseason,
           idteam,
           SUM(game_win) AS wins,
           SUM(game_loss) AS loses,
            ROUND((SUM(game_win)/SUM(game_win + game_loss)) * 100, 1)
               AS win_pct,
            CONCAT(CAST(SUM(conf_win) AS CHAR(2)), ' - ',
                CAST(SUM(cONf_loss) AS CHAR(2)) ) AS conf_record,
            CONCAT(CAST(SUM(div_win) AS CHAR(2)), ' - ',
                CAST(SUM(div_loss) AS CHAR(2)) ) AS div_record,
            CONCAT(CAST(SUM(home_win) AS CHAR(2)), ' - ',
                CAST(SUM(home_loss) AS CHAR(2)) ) AS home_record,
            CONCAT(CAST(SUM(away_win) AS CHAR(2)), ' - ',
                CAST(SUM(away_loss) AS CHAR(2)) ) AS away_record
        FROM (
          SELECT season_idseason,
                 idteam,
                 conference,
                 division,
                 s.win_team_id,
                 s.loss_team_id,
           CASE WHEN s.win_team_id = t.idteam THEN 1
               ELSE 0 END AS game_win,
           CASE WHEN s.loss_team_id = t.idteam THEN 1
               ELSE 0 END AS game_loss,
            -- Conference Record
            CASE WHEN (s.win_team_id = t.idteam) AND
                    conference = (
                        SELECT t.conference
                        FROM team t
                        WHERE s.loss_team_id = t.idteam
                    )
                THEN 1
            ELSE 0 END AS conf_win,
            CASE WHEN (s.loss_team_id = t.idteam) AND
                    conference = (
                        SELECT t.conference
                        FROM team t
                        WHERE s.win_team_id = t.idteam
                    )
                THEN 1
            ELSE 0 END AS cONf_loss,
             -- Division Record
            CASE WHEN (s.win_team_id = t.idteam) AND
                      division = (
                          SELECT t.division
                          FROM team t
                          WHERE s.loss_team_id = t.idteam
                      )
                THEN 1
            ELSE 0 END AS div_win,
            CASE WHEN (s.loss_team_id = t.idteam) AND
                      division = (
                          SELECT t.division
                          FROM team t
                          WHERE s.win_team_id = t.idteam
                      )
                THEN 1
            ELSE 0 END AS div_loss,
             -- Home Record
            CASE WHEN (s.win_team_id = t.idteam) AND home_team_id = win_team_id
                THEN 1
            ELSE 0 END AS home_win,
            CASE WHEN (s.loss_team_id = t.idteam) AND home_team_id = loss_team_id
                THEN 1
            ELSE 0 END AS home_loss,
            -- Away Record
            CASE WHEN (s.win_team_id = t.idteam) AND away_team_id = win_team_id
                THEN 1
            ELSE 0 END AS away_win,
            CASE WHEN (s.loss_team_id = t.idteam)  AND away_team_id = loss_team_id
                THEN 1
            ELSE 0 END AS away_loss
        FROM totals s
        JOIN team t
    ) AS standings
    GROUP BY idteam

);


# Sub-task 3 - Rank the standings
SELECT s.season_idseason,
       t.team_name,
       s.win_pct,
       @curRank := @curRank + 1 AS ranks
FROM
    standings s JOIN team t ON s.idteam = t.idteam, (SELECT @curRank := 0) r
# WHERE s.idseason = 2
ORDER BY win_pct DESC;


# 4
# As a Fan, I want to view the league schedule
# so that I can know when my favorite team is playing its next game
DROP VIEW IF EXISTS schedule;

CREATE VIEW schedule AS
(
    SELECT date,
           (
               SELECT team_name
               FROM team
               WHERE idteam = home_team_id
            ) AS home,
           (
               SELECT team_name
               FROM team
               WHERE idteam = away_team_id
            ) AS away
    FROM game g
);


# 5
# As a Fan, I want to be able to buy tickets
# so that I can attend a local game

DROP FUNCTION IF EXISTS fan_buys_ticket;

DELIMITER //

CREATE FUNCTION fan_buys_ticket (
    gameID       INT(10) UNSIGNED,
    first_name   VARCHAR(45),
    last_name    VARCHAR(45),
    email_name   VARCHAR(45),
    email_host   VARCHAR(45),
    email_domain VARCHAR(45)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    # If this is a new fan
    IF (
        SELECT NOT EXISTS(
            SELECT *
            FROM fan f
            WHERE f.first_name   = first_name AND
                  f.last_name    = last_name  AND
                  f.email_name   = email_name AND
                  f.email_host   = email_host AND
                  f.email_domain = email_domain
    ))
    THEN
        # Add the new fan to the fan table
        SET @fan_id := (SELECT MAX(idfan) + 1 FROM fan);

        INSERT INTO fan (idfan,
                         first_name,
                         last_name,
                         full_name,
                         email_name,
                         email_host,
                         email_domain)
             SELECT @fan_id,
                    first_name,
                    last_name,
                    CONCAT(first_name,' ',last_name) AS full_name,
                    email_name,
                    email_host,
                    email_domain
               FROM fan;
    ELSE
    # If this is an old fan, find the fan id
        SET @fan_id := (
            SELECT idfan
            FROM fan f
            WHERE f.first_name   = first_name AND
                  f.last_name    = last_name  AND
                  f.email_name   = email_name AND
                  f.email_host   = email_host AND
                  f.email_domain = email_domain
        );
    END IF;

    # Simulate fan purchasing ticket, add fan to fan_has_game table
    INSERT INTO fan_has_game(fan_idfan, game_idgame)
         SELECT @fan_id, gameid
           FROM fan_has_game;

    RETURN 'Fan Added';
END //
DELIMITER ;


# 8
# As a Fan, I want to view player stats
# so that I can see a player‘s averages over various time periods
# (e.g. month-to-month stats, season averages, etc.)

# 2 Sub-tasks
# 1. Need to create a totals view that records number of games played by a team in a given period
#       e.g. games_played VIEW attributes -> date, teamid, played_game
# 2. Need to create a standings view that summarizes each team based ON totals view

-- Season
DROP FUNCTION IF EXISTS season;

DELIMITER //
CREATE FUNCTION season ()
RETURNS TINYINT(1)
DETERMINISTIC
BEGIN
    RETURN 1;
END //
DELIMITER ;


-- Player Averages
DROP VIEW IF EXISTS player_avg;

CREATE VIEW player_avg AS
(
    SELECT t.team_name,
           p.full_name,
           AVG(mins) AS mins,
           AVG(fgm)  AS fgm,
           AVG(fga)  AS fga,
           CASE
               WHEN
                   fga <> 0
                   THEN
                   ROUND((AVG(fgm) / AVG(fga)) * 100, 1)
               ELSE 0
               END   AS fg_pct,
           AVG(fg3)  AS fg3,
           AVG(fg3a) AS fg3a,
           CASE
               WHEN
                   fg3a <> 0
                   THEN
                   ROUND((AVG(fg3) / AVG(fg3a)) * 100, 1)
               ELSE 0
               END   AS fg3_pct,
           AVG(ft)   AS ft,
           AVG(fta)   AS fta,
           CASE
               WHEN
                   fta <> 0
                   THEN
                   ROUND((AVG(ft) / AVG(fta)) * 100, 1)
               ELSE 0
               END    AS ft_pct,
           AVG(orb)   AS orb,
           AVG(drb)   AS drb,
           AVG(trb)   AS trb,
           AVG(ASt)   AS assists,
           AVG(blk)   AS blocks,
           AVG(tov)   AS turnovers,
           AVG(fouls) AS fouls,
           AVG(pts)   AS points
    FROM game g
             JOIN box_score b
                  ON g.idgame = b.game_idgame
             JOIN player p
                  ON b.player_idplayer = p.idplayer
             JOIN team t
                  ON b.team_idteam = t.idteam
#              JOIN games_played gp
#                   ON t.team_name = gp.team_name
    WHERE g.date BETWEEN start_date() AND end_date()
    GROUP BY 1, 2
    ORDER BY 1, 2 ASC
);


-- Player Sum (Raw Scores)
DROP VIEW IF EXISTS player_raw;

CREATE VIEW player_raw AS
(
    SELECT t.team_name,
           p.full_name,
           SUM(mins)  AS mins,
           SUM(fgm)   AS fgm,
           SUM(fga)   AS fga,
           CASE
               WHEN
                   fga <> 0
                   THEN
                   ROUND((SUM(fgm) / SUM(fga)) * 100, 1)
               ELSE 0
               END    AS fg_pct,
           SUM(fg3)   AS fg3,
           SUM(fg3a)  AS fg3a,
           CASE
               WHEN
                   fg3a <> 0
                   THEN
                   ROUND((SUM(fg3) / SUM(fg3a)) * 100, 1)
               ELSE 0
               END    AS fg3_pct,
           SUM(ft)    AS ft,
           SUM(fta)   AS fta,
           CASE
               WHEN
                   fta <> 0
                   THEN
                   ROUND((SUM(ft) / SUM(fta)) * 100, 1)
               ELSE 0
               END    AS ft_pct,
           SUM(orb)   AS orb,
           SUM(drb)   AS drb,
           SUM(trb)   AS trb,
           SUM(ASt)   AS assists,
           SUM(blk)   AS blocks,
           SUM(tov)   AS turnovers,
           SUM(fouls) AS fouls,
           SUM(pts)   AS points
    FROM game g
             JOIN box_score b
                  ON g.idgame = b.game_idgame
             JOIN player p
                  ON b.player_idplayer = p.idplayer
             JOIN team t
                  ON b.team_idteam = t.idteam
             JOIN games_played gp
                  ON t.team_name = gp.team_name
    WHERE g.date BETWEEN start_date() AND end_date()
    GROUP BY 1, 2
    ORDER BY 1, 2 ASC
);

-- Games Played Totals
DROP VIEW IF EXISTS games_played;
CREATE VIEW games_played AS
(
    SELECT team_name, sum(games_played) games_played
    FROM
    (
        SELECT count(*) AS games_played, team_name
        FROM schedule s
                 JOIN team
                     ON team_name = home
        WHERE date BETWEEN start_date() AND end_date()
        GROUP BY team_name

        UNION ALL

        SELECT count(*) AS games_played, team_name
        FROM schedule s
                 JOIN team ON team_name = away
        WHERE date BETWEEN start_date() AND end_date()
        GROUP BY team_name
    ) AS game_total
    GROUP BY team_name
);


# 9
# As a Fan, I want to view team stats
# so that I can see a team’s averages over various time periods
# (e.g. month-to-month stats, season averages, etc.)
-- Team Averages
DROP VIEW IF EXISTS team_avg;

CREATE VIEW team_avg AS
(
    SELECT t.team_name,
           ROUND(SUM(mins / gp.games_played), 0)                   AS mins,
           ROUND(SUM(fgm) / gp.games_played, 0)                    AS team_fgm,
           ROUND(SUM(fga) / gp.games_played, 0)                    AS team_fga,
           ROUND((ROUND(SUM(fgm) / gp.games_played, 0) /
                  ROUND(SUM(fga) / gp.games_played, 0)) * 100, 1)  AS team_fg_pct,
           ROUND(SUM(fg3) / gp.games_played, 0)                    AS team_fg3,
           ROUND(SUM(fg3a) / gp.games_played, 0)                   AS team_fg3a,
           ROUND((ROUND(SUM(fg3) / gp.games_played, 0) /
                  ROUND(SUM(fg3a) / gp.games_played, 0)) * 100, 1) AS team_fg3_pct,
           ROUND(SUM(ft) / gp.games_played, 0)                     AS team_ft,
           ROUND(SUM(fta) / gp.games_played, 0)                    AS team_fta,
           ROUND((ROUND(SUM(ft) / gp.games_played, 0) /
                  ROUND(SUM(fta) / gp.games_played, 0)) * 100, 1)  AS team_ft_pct,
           ROUND(SUM(orb) / gp.games_played, 0)                    AS team_orb,
           ROUND(SUM(drb) / gp.games_played, 0)                    AS team_drb,
           ROUND(SUM(trb) / gp.games_played, 0)                    AS team_trb,
           ROUND(SUM(ast) / gp.games_played, 0)                    AS team_assists,
           ROUND(SUM(blk) / gp.games_played, 0)                    AS team_blocks,
           ROUND(SUM(tov) / gp.games_played, 0)                    AS team_turnovers,
           ROUND(SUM(fouls) / gp.games_played, 0)                  AS team_fouls,
           ROUND(SUM(pts) / gp.games_played, 0)                    AS team_points
    FROM game g
             JOIN box_score b
                  ON idgame = game_idgame
             JOIN team t
                  ON team_idteam = idteam
             JOIN games_played gp
                  ON t.team_name = gp.team_name
    WHERE g.date BETWEEN start_date() AND end_date()
    GROUP BY 1
    ORDER BY 1 ASC
);

-- Team Totals (Raw Scores)
DROP VIEW IF EXISTS team_raw;

CREATE VIEW team_raw AS
(
    SELECT t.team_name,
           ROUND(SUM(mins), 0)                    AS mins,
           SUM(fgm)                               AS team_fgm,
           SUM(fga)                               AS team_fga,
           ROUND((SUM(fgm) / SUM(fga)) * 100, 1)  AS team_fg_pct,
           SUM(fg3)                               AS team_fg3,
           SUM(fg3a)                              AS team_fg3a,
           ROUND((SUM(fg3) / SUM(fg3a)) * 100, 1) AS team_fg3_pct,
           SUM(ft)                                AS team_ft,
           SUM(fta)                               AS team_fta,
           ROUND((SUM(ft) / SUM(fta)) * 100, 1)   AS team_ft_pct,
           SUM(orb)                               AS team_orb,
           SUM(drb)                               AS team_drb,
           SUM(trb)                               AS team_trb,
           SUM(ASt)                               AS team_assists,
           SUM(blk)                               AS team_blocks,
           SUM(tov)                               AS team_turnovers,
           SUM(fouls)                             AS team_fouls,
           SUM(pts)                               AS team_points
    FROM game g
             JOIN box_score b
                  ON idgame = game_idgame
             JOIN team t
                  ON team_idteam = idteam
             JOIN games_played gp
                  ON t.team_name = gp.team_name
    WHERE g.date BETWEEN start_date() AND end_date()
    GROUP BY 1
    ORDER BY 1 ASC
);


# 10
# As a Fan, I want to view an alphabetical player list
# so that I can have the ability to find players easily
SELECT CONCAT(last_name, ', ',first_name) AS name,
       team_name,
       position,
       jersey
FROM player p
JOIN team t
ON p.team_idteam = t.idteam
ORDER BY last_name, first_name;


# 11
# As a Fan, I want to view an alphabetical team list
# so that I can have the ability to find teams easily
SELECT team_name
FROM team t
ORDER BY team_name ASC;


# 12
# As a Fan, I want to search the player stats
# so that I can find stats only about players that I am interested in

-- Player Name Filter
DROP FUNCTION IF EXISTS player_name;

DELIMITER //
CREATE FUNCTION player_name (
    name VARCHAR(90)
)
RETURNS VARCHAR(90)
DETERMINISTIC
BEGIN
    RETURN name;
END //
DELIMITER ;

SELECT team_name,
        full_name,
        fgm,
        fga,
        fg_pct,
        fg3,
        fg3a,
        fg3_pct,
        ft,
        fta,
        ft_pct,
        orb,
        drb,
        trb,
        assists,
        blocks,
        turnovers,
        fouls,
        points
 FROM player_raw p
 WHERE player_name('Anthony Swisher') = p.full_name
 ORDER BY team_name;


# 13
# As a Fan, I want to search the team stats
# so that I can find collective team stats only about teams that I am interested in

-- Team Name Filter
DROP FUNCTION IF EXISTS team_name;

DELIMITER //
CREATE FUNCTION team_name (
    name VARCHAR(90)
)
RETURNS VARCHAR(90)
DETERMINISTIC
BEGIN
    RETURN name;
END //
DELIMITER ;

 SELECT team_name,
        team_fgm,
        team_fga,
        team_fg_pct,
        team_fg3,
        team_fg3a,
        team_fg3_pct,
        team_ft,
        team_fta,
        team_ft_pct,
        team_orb,
        team_drb,
        team_trb,
        team_assists,
        team_blocks,
        team_turnovers,
        team_fouls,
        team_points
 FROM team_raw t
 WHERE player_name('Ballers') = t.team_name
 ORDER BY team_name;


# 14
# As a Fan, I want to search the player list
# so that I can choose a player profile that I am interested in

-- Specific Player Search

SELECT CONCAT(last_name, ', ',first_name) AS name,
       team_name,
       position,
       jersey
FROM player p
JOIN team t
ON p.team_idteam = t.idteam
AND player_name('Anthony Swisher') = p.full_name
ORDER BY last_name, first_name;


# 15
# As a Fan, I want to search the team list
# so that I can choose a team profile that I am interested in
SELECT team_name,
       location,
       conference,
       division,
       mascot
FROM team t
WHERE team_name('Ballers') = t.team_name
ORDER BY conference, division, team_name;


# 16
# As a Fan, I want to view a player profile
# so that I can learn about the background of a player
# (height, weight, date of birth, high school attended, profile picture, etc.)
SELECT full_name, position, jersey, school, team_name
FROM player p
JOIN team t
ON p.team_idteam = t.idteam
ORDER BY idplayer;


# 17
# As a Fan, I want to view a team profile
# so that I can learn about the history of a team
# (city, venue, coach’s name, team logo, team mascot, etc.)
SELECT team_name,
       location,
       conference,
       division,
       mascot
FROM team
ORDER BY conference, division, team_name;


# 18
# As a Fan, I want to view a ‘Top Player Stats’ leaderboard
# so that I can see which player is the top ranked player in each statistical category
 SELECT team_name,
        full_name,
        ROUND(fgm, 0)            AS fgm,
        ROUND(fga, 0)            AS fga,
        fg_pct,
        ROUND(fg3, 0)            AS fg3,
        ROUND(fg3a, 0)           AS fg3a,
        fg3_pct,
        ROUND(ft, 0)             AS ft,
        ROUND(fta, 0)            AS fta,
        ft_pct,
        ROUND(orb, 0)            AS orb,
        ROUND(drb, 0)            AS drb,
        ROUND(trb, 0)            AS trb,
        ROUND(assists, 0)        AS ast,
        ROUND(blocks, 0)         AS blk,
        ROUND(turnovers, 0)      AS tov,
        ROUND(fouls, 0)          AS fouls,
        ROUND(points, 0)         AS pts,
        @curRank := @curRank + 1 AS ranks
 FROM player_avg p,
      (SELECT @curRank := 0) r
 -- Stat Filter
 ORDER BY pts DESC;


# 19
# As a Fan, I want to view a ‘Top Team Stats’ leaderboard
# so that I can see which team is the top ranked team in each statistical category
 SELECT team_name,
        ROUND(team_fgm, 0)       AS team_fgm,
        ROUND(team_fga, 0)       AS team_fga,
        team_fg_pct,
        ROUND(team_fg3, 0)       AS team_fg3,
        ROUND(team_fg3a, 0)         ASteam_fg3a,
        team_fg3_pct,
        ROUND(team_ft, 0)        AS team_ft,
        ROUND(team_fta, 0)       AS team_fta,
        team_ft_pct,
        ROUND(team_orb, 0)       AS team_orb,
        ROUND(team_drb, 0)       AS team_drb,
        ROUND(team_trb, 0)       AS team_trb,
        ROUND(team_assists, 0)   AS team_ast,
        ROUND(team_blocks, 0)    AS team_blk,
        ROUND(team_turnovers, 0) AS team_tov,
        ROUND(team_fouls, 0)     AS team_fouls,
        ROUND(team_points, 0)    AS team_pts,
        @curRank := @curRank + 1 AS ranks
 FROM team_avg t,
      (SELECT @curRank := 0) r
      -- Stat Filter
 ORDER BY team_pts DESC;

