-- =====================================================
-- Author:      Matthew Frazier
-- Create date: 11/1/19
-- Description: Identify reporting/analytics stories.
--              Show SQL, query plan & output in a doc.
-- =====================================================

--  Fan User Story #3, 8, 9, 18, 19

-- =====================================================
-- # 3
-- =====================================================
--  As a Fan, I want to VIEW totals (standings)
--  so that easily know each team’s ranking

--  3 Sub-tasks
--  1. Need to create a totals view that records wins AND losses
--        e.g. Totals VIEW attributes -> seasonid, teamid, wins, loses, win%, conference, division, home, road
--  2. Need to create a standings view that summarizes each team based ON totals view
--  3. Need to rank teams in standings

--  Sub-task 1 - Create Totals View

EXPLAIN EXTENDED
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
         ) AS t1
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
         ) AS t2
         ON t1.idgame = t2.idgame
    WHERE t1.team_name <> t2.team_name
    HAVING win_team_id IS NOT NULL
       AND loss_team_id IS NOT NULL
);


--  Sub-task 2 - Create standings View

EXPLAIN EXTENDED
(
    SELECT season_idseason,
           loss_team_id,
           COUNT(loss_team_id) AS loss
    FROM totals
    WHERE (home_team_id = loss_team_id
        OR away_team_id = loss_team_id)
    GROUP BY 1, 2
    ORDER BY 1, 2
);


EXPLAIN EXTENDED
(
    SELECT season_idseason,
           win_team_id,
           COUNT(win_team_id) AS win
    FROM totals
    WHERE (home_team_id = win_team_id
        OR away_team_id = win_team_id)
    GROUP BY 1, 2
    ORDER BY 1, 2
);

EXPLAIN EXTENDED
(
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


--  Sub-task 3 - Rank the standings

EXPLAIN EXTENDED
(
    SELECT s.season_idseason,
           t.team_name,
           s.win_pct,
           @curRank := @curRank + 1 AS ranks
    FROM standings s
             JOIN team t ON s.idteam = t.idteam,
         (SELECT @curRank := 0) r
--  WHERE s.idseason = 2
    ORDER BY win_pct DESC
);


-- =====================================================
-- # 8
-- =====================================================
--  As a Fan, I want to view player stats
--  so that I can see a player‘s averages over various time periods
--  (e.g. month-to-month stats, season averages, etc.)

--  2 Sub-tasks
--  1. Need to create a totals view that records number of games played by a team in a given period
--        e.g. games_played VIEW attributes -> date, teamid, played_game
--  2. Need to create a standings view that summarizes each team based ON totals view

-- Traditional Stats
-- _______________________________________________________________________________________________________
--  Stat    |  Name                             |  Formula                                              --
-- _________|___________________________________|_________________________________________________________
--  gp 	    | Games Played                      |                                                       --
--  min	    | Minutes Played                    |                                                       --
--  pts	    | Points                            |                                                       --
--  fgm	    | Field Goals Made                  |                                                       --
--  fga	    | Field Goals Attempted             |                                                       --
--  fg_pct  | Field Goal Percentage             | (FGM / FGA) * 100                                     --
--  fg3	    | 3 Point Field Goals Made          |                                                       --
--  fg3a	| 3 Point Field Goals Attempted     |                                                       --
--  fg3_pct | 3 Point Field Goals Percentage    | (FG3 / FG3A) * 100                                    --
--  ft	    | Free Throws Made                  |                                                       --
--  fta	    | Free Throws Attempted             |                                                       --
--  ft_pct  | Free Throw Percentage             | (FT / FTA) * 100                                      --
--  orb	    | Offensive Rebounds                |                                                       --
--  drb	    | Defensive Rebounds                |                                                       --
--  trb	    | Total Rebounds                    |                                                       --
--  ast	    | Assists                           |                                                       --
--  fouls   | Fouls                             |                                                       --
--  blk	    | Blocks                            |                                                       --
--  tov	    | Turnovers                         |                                                       --
-- _________|___________________________________|_________________________________________________________


-- Player Averages

EXPLAIN EXTENDED
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
--               JOIN games_played gp
--                    ON t.team_name = gp.team_name
    WHERE g.date BETWEEN start_date() AND end_date()
    GROUP BY 1, 2
    ORDER BY 1, 2 ASC
);


-- Player Sum (Raw Scores)

EXPLAIN EXTENDED
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

EXPLAIN EXTENDED
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


-- =====================================================
-- # 9
-- =====================================================

--  9
--  As a Fan, I want to view team stats
--  so that I can see a team’s averages over various time periods
--  (e.g. month-to-month stats, season averages, etc.)

-- Traditional Stats
-- _______________________________________________________________________________________________________
--  Stat    |  Name                             |  Formula                                              --
-- _________|___________________________________|_________________________________________________________
--  gp 	    | Games Played                      |                                                       --
--  min	    | Minutes Played                    |                                                       --
--  pts	    | Points                            |                                                       --
--  fgm	    | Field Goals Made                  |                                                       --
--  fga	    | Field Goals Attempted             |                                                       --
--  fg_pct  | Field Goal Percentage             | (FGM / FGA) * 100                                     --
--  fg3	    | 3 Point Field Goals Made          |                                                       --
--  fg3a	| 3 Point Field Goals Attempted     |                                                       --
--  fg3_pct | 3 Point Field Goals Percentage    | (FG3 / FG3A) * 100                                    --
--  ft	    | Free Throws Made                  |                                                       --
--  fta	    | Free Throws Attempted             |                                                       --
--  ft_pct  | Free Throw Percentage             | (FT / FTA) * 100                                      --
--  orb	    | Offensive Rebounds                |                                                       --
--  drb	    | Defensive Rebounds                |                                                       --
--  trb	    | Total Rebounds                    |                                                       --
--  ast	    | Assists                           |                                                       --
--  fouls   | Fouls                             |                                                       --
--  blk	    | Blocks                            |                                                       --
--  tov	    | Turnovers                         |                                                       --
-- _________|___________________________________|_________________________________________________________

-- Team Averages
EXPLAIN EXTENDED
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

EXPLAIN EXTENDED
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

-- =====================================================
-- # 18
-- =====================================================
--  As a Fan, I want to view a ‘Top Player Stats’ leaderboard
--  so that I can see which player is the top ranked player in each statistical category

EXPLAIN EXTENDED
(
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
    ORDER BY pts DESC
);


-- =====================================================
-- # 19
-- =====================================================
--  As a Fan, I want to view a ‘Top Team Stats’ leaderboard
--  so that I can see which team is the top ranked team in each statistical category

EXPLAIN EXTENDED
(
    SELECT team_name,
           ROUND(team_fgm, 0)       AS team_fgm,
           ROUND(team_fga, 0)       AS team_fga,
           team_fg_pct,
           ROUND(team_fg3, 0)       AS team_fg3,
           ROUND(team_fg3a, 0)      AS team_fg3a,
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
    ORDER BY team_pts DESC
);

-- Note: There are no user stories for displaying the store data. Store is out of the scope of MVP.

-- =====================================================
-- Additional Reporting/Analytics
-- =====================================================

-- Advanced Stats
-- _______________________________________________________________________________________________________
--  Stat    |  Name                             |  Formula                                              --
-- _________|___________________________________|_________________________________________________________
--  efg_pct | Effective Field Goal Percentage	|  (FG + 0.5 * 3P) / FGA                                --
--  tsa	    | True Shooting Attempts	        |  FGA + 0.475 * FTA                                    --
--  ts_pct  | True Shooting Percentage	        |  PTS / (2 * TSA) -->  PTS / (2 * (FGA + 0.475 * FTA)) --
--  ftr	    | Free Throw Rate	                |  FT / FGA                                             --
--  tov_pct | Turnover Percentage	            |  100 * TOV / (FGA + 0.44 * FTA + TOV)                 --
--  gmsc    | Game Score      	                |  PTS + 0.4 * FG - 0.7 * FGA - 0.4*(FTA - FT) + 0.7 *  --
--          |                                   |  ORB + 0.3 * DRB + STL + 0.7 * AST + 0.7 * BLK        --
--          |                                   |  - 0.4 * Fouls - TOV                                  --
-- _________|___________________________________|_________________________________________________________

EXPLAIN EXTENDED
(
    SELECT t.team_name,
           p.full_name,
           ROUND((SUM(fgm + fg3) + 0.5 * fg3)
                     / SUM(fga + fg3a) * 100, 1)                AS efg_pct,
           ROUND(SUM(fga + fg3a) + 0.475 * fta, 1)              AS tsa,
           ROUND(points / (2 * (SUM(fga + fg3a) +
                                0.475 * fta)) * 100, 1)         AS ts_pct,
           ROUND((ft / SUM(fga + fg3a) * 100), 1)               AS ftr,
           ROUND(100 * turnovers / (SUM(fga + fg3a) +
                                    0.44 * fta + turnovers), 1) AS tov_pct,
           ROUND((points + 0.4 * SUM(fga + fg3a) - 0.7 *
                  fga - 0.4 * (fta - ft) + 0.7 * orb + 0.3 *
                  drb + 0.7 * assists + 0.7 * blocks - 0.4 *
                  Fouls - turnovers), 1)                        AS gmsc
    FROM player_raw pr
             JOIN player p
                  ON pr.full_name = p.full_name
             JOIN team t
                  ON pr.team_name = t.team_name
             JOIN games_played gp
                  ON t.team_name = gp.team_name
    GROUP BY 1, 2
    ORDER BY 1, 2 ASC
);

