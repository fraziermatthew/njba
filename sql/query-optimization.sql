-- =====================================================
-- Author:      Matthew Frazier
-- Create date: 11/1/19
-- Description: Identify 5 queries that require
--              optimization. Provide SQL, query plan
--              and query execution time both before and
--              and after the optimization.
-- =====================================================

EXPLAIN EXTENDED (
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