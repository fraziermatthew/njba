-- =====================================================
-- Author:      Matthew Frazier
-- Create date: 11/1/19
-- Description: Identify reporting/analytics stories.
--              Show SQL, query plan & output in a doc.
-- =====================================================

-- Traditional Stats
#_______________________________________________________________________________________________________#
# Stat    |  Name                             |  Formula                                                #
#_________|___________________________________|_________________________________________________________#
# gp 	  | Games Played                      |                                                         #
# min	  | Minutes Played                    |                                                         #
# pts	  | Points                            |                                                         #
# fgm	  | Field Goals Made                  |                                                         #
# fga	  | Field Goals Attempted             |                                                         #
# fg_pct  | Field Goal Percentage             | (FGM / FGA) * 100                                       #
# fg3	  | 3 Point Field Goals Made          |                                                         #
# fg3a	  | 3 Point Field Goals Attempted     |                                                         #
# fg3_pct | 3 Point Field Goals Percentage    | (FG3 / FG3A) * 100                                      #
# ft	  | Free Throws Made                  |                                                         #
# fta	  | Free Throws Attempted             |                                                         #
# ft_pct  | Free Throw Percentage             | (FT / FTA) * 100                                        #
# orb	  | Offensive Rebounds                |                                                         #
# drb	  | Defensive Rebounds                |                                                         #
# trb	  | Total Rebounds                    |                                                         #
# ast	  | Assists                           |                                                         #
# fouls	  | Fouls                             |                                                         #
# blk	  | Blocks                            |                                                         #
# tov	  | Turnovers                         |                                                         #
#_________|___________________________________|_________________________________________________________#





-- Advanced Stats
#_______________________________________________________________________________________________________#
# Stat    |  Name                             |  Formula                                                #
#_________|___________________________________|_________________________________________________________#
# efg_pct | Effective Field Goal Percentage	  |  (FG + 0.5 * 3P) / FGA                                  #
# tsa	  | True Shooting Attempts	          |  FGA + 0.475 * FTA                                      #
# ts_pct  | True Shooting Percentage	      |  PTS / (2 * TSA) -->  PTS / (2 * (FGA + 0.475 * FTA))   #
# ftr	  | Free Throw Rate	                  |  FT / FGA                                               #
# tov_pct | Turnover Percentage	              |  100 * TOV / (FGA + 0.44 * FTA + TOV)                   #
# gmsc    | Game Score      	              |  PTS + 0.4 * FG - 0.7 * FGA - 0.4*(FTA - FT) + 0.7 *    #
#         |                                   |  ORB + 0.3 * DRB + STL + 0.7 * AST + 0.7 * BLK - 0.4 *  #
#         |                                   |  Fouls - TOV                                            #
#_________|___________________________________|_________________________________________________________#

DROP VIEW IF EXISTS player_adv;

CREATE VIEW player_adv AS
(
    SELECT t.team_name,
           p.full_name,
           ROUND((SUM(fgm + fg3) + 0.5 * fg3) / SUM(fga + fg3a) * 100, 1)    AS efg_pct,
           ROUND(SUM(fga + fg3a) + 0.475 * fta, 1)  AS tsa,
           ROUND(points / (2 * (SUM(fga + fg3a) + 0.475 * fta)) * 100, 1) AS ts_pct,
           ROUND((ft / SUM(fga + fg3a)  * 100), 1)   AS ftr,
           ROUND(100 * turnovers / (SUM(fga + fg3a) + 0.44 * fta + turnovers), 1)   AS tov_pct,
           ROUND((points + 0.4 * SUM(fga + fg3a) - 0.7 * fga -
                  0.4 * (fta - ft) + 0.7 * orb + 0.3 * drb + 0.7 *
                  assists + 0.7 * blocks - 0.4 * Fouls - turnovers), 1) AS gmsc
#            (100 * ((SUM(fga + fg3a) + 0.44 * fta + turnovers) * (TmMP / 5)) / (min * (TmFGA + 0.44 * Tm FTA + Tm TOV))) AS usage
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

