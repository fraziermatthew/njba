-- =====================================================
-- Author:      Matthew Frazier
-- Create date: 11/1/19
-- Description: Procedures for NJBA.
-- =====================================================

/**
 * Backfill the payment table with the subtotals of all items
 * for each payment
 */
 -- Runtime ~2 m
DROP PROCEDURE payment_sum;

DELIMITER $$
CREATE PROCEDURE payment_sum()
BEGIN
    -- Payment ID iteration variable
    DECLARE paymentid INT;
    SET paymentid = 340287;

    -- Begin Loop
    loop_label:  LOOP

        -- Repeat while the loop is less than the max payment id
        IF  paymentid > 1000000 THEN
            LEAVE  loop_label;
        END  IF;

        -- Sum up the amount of the payment
#         SET @amt = (
#                     SELECT amount
#                     FROM products p JOIN
#                          products_has_payment php
#                              ON p.idproducts = php.products_idproducts
#                     JOIN payment m ON php.payment_idpayment = m.idpayment
#                     WHERE php.payment_idpayment = 340286
#                     GROUP BY php.payment_idpayment -- 700001
#                    );

        SET @amt = (
          SELECT SUM(p.price) 
        FROM products p WHERE p.idproducts IN (
          SELECT php.products_idproducts 
          FROM products_has_payment php 
          WHERE php.payment_idpayment = paymentid
          )
          );

        -- Update the amount of the payment with the summed amount
        UPDATE payment
        SET amount = @amt
        WHERE idpayment = paymentid;

        -- Increase the iteration variable
        SET paymentid = paymentid + 1;

        ITERATE  loop_label;

    -- Exit the loop
    END LOOP;

END$$

DELIMITER ;

CALL payment_sum();



/**
 * Backfill the standings table
 */
 -- Runtime ~2 m
DROP PROCEDURE standings_update;

DELIMITER $$
CREATE PROCEDURE standings_update()
BEGIN

    -- Season ID iteration variable
    DECLARE season INT;
    SET season = 1;

    -- Team ID iteration variable
    SET @team = 1;

    -- Begin Loop
    WHILE season <= 30 DO

        loop_label2:  LOOP

            -- For each team IN the loop
            IF @team > 30 THEN
                LEAVE  loop_label2;
            END IF;

            -- ============================================
            -- Update Winning Data
            -- ============================================
            -- Sum up the amount of Total Wins
            IF (
                SELECT COUNT(*) AS wins
                  FROM totals
                 WHERE win_team_id = @team
                   AND season_idseason = season
                 GROUP BY season_idseason, win_team_id
            )
            THEN
            BEGIN
            SET @win_count = (
                        SELECT COUNT(*) AS wins
                          FROM totals
                         WHERE win_team_id = @team
                           AND season_idseason = season
                         GROUP BY season_idseason, win_team_id
                       );
            END;
            ELSE BEGIN SET @win_count = 0; END;
            END IF;

            -- Update the amount of wins IN the leader-board with the Total Wins amount
            UPDATE leaderboard
            SET wins = @win_count
            WHERE season_idseason = season AND team_idteam = @team;


            -- Sum up the amount of Conference Win
            IF (
                SELECT COUNT(*) AS con_win
                  FROM totals t
                 WHERE loss_team_id IN (
                     SELECT idteam
                     FROM team
                     WHERE conference = (
                         SELECT conference
                         FROM team
                         WHERE idteam = win_team_id
                         )
                     )
                 AND win_team_id = @team
                 AND season_idseason = season
                 GROUP BY season_idseason, win_team_id
            )
            THEN
            BEGIN
            SET @conwins = (
                                SELECT COUNT(*) AS con_win
                                  FROM totals t
                                 WHERE loss_team_id IN (
                                SELECT idteam
                                  FROM team
                                 WHERE conference = (
                                    SELECT conference
                                      FROM team
                                     WHERE idteam = win_team_id
                                    )
                                )
                                 AND win_team_id = @team
                                 AND season_idseason = season
                            GROUP BY season_idseason, win_team_id
                       );
            END;
            ELSE BEGIN SET @conwins = 0; END;
            END IF;

            -- Update the amount of wins IN the leader-board with the Conference Wins amount
            UPDATE leaderboard
            SET conf_win = @conwins
            WHERE season_idseason = season AND team_idteam = @team;



            -- Sum up the amount of Division Win
            IF (
                SELECT COUNT(*) AS div_win
                  FROM totals t
                 WHERE loss_team_id IN (
                    SELECT idteam
                      FROM team
                     WHERE division = (
                        SELECT division
                          FROM team
                         WHERE idteam = win_team_id
                        )
                    )
                     AND win_team_id = @team
                     AND season_idseason = season
                GROUP BY season_idseason, win_team_id
            )
            THEN
            BEGIN
                SET @divwins = (SELECT COUNT(*) AS div_win
                                  FROM totals t
                                 WHERE loss_team_id IN (
                                    SELECT idteam
                                      FROM team
                                     WHERE division = (
                                        SELECT division
                                          FROM team
                                         WHERE idteam = win_team_id
                                        )
                                    )
                                AND win_team_id = @team
                                AND season_idseason = season
                                GROUP BY season_idseason, win_team_id);
            END;
            ELSE BEGIN SET @divwins = 0; END;
            END IF;

            -- Update the amount of loss IN the leader-board with the Division Loss amount
            UPDATE leaderboard
            SET div_win = @divwins
            WHERE season_idseason = season AND team_idteam = @team;


            -- Sum up the amount of Home Wins
            IF (
                SELECT COUNT(*) AS home_win
                            FROM totals
                            WHERE win_team_id = home_team_id
                              AND win_team_id = @team
                              AND season_idseason = season
                            GROUP BY season_idseason, win_team_id
            )
            THEN
            BEGIN
            SET @homewins = (
                            SELECT COUNT(*) AS home_win
                             FROM totals
                            WHERE win_team_id = home_team_id
                              AND win_team_id = @team
                              AND season_idseason = season
                            GROUP BY season_idseason, win_team_id
                       );
            END;
            ELSE BEGIN SET @homewins = 0; END;
            END IF;

            -- Update the amount of wins IN the leader-board with the Home Wins amount
            UPDATE leaderboard
            SET home_win = @homewins
            WHERE season_idseason = season AND team_idteam = @team;


            -- Sum up the amount of Away Wins
            IF (
                SELECT COUNT(*) AS away_win
                  FROM totals
                 WHERE win_team_id = away_team_id
                   AND win_team_id = @team
                   AND season_idseason = season
                 GROUP BY season_idseason, win_team_id
            )
            THEN
            BEGIN
            SET @awaywins = (
                            SELECT COUNT(*) AS away_win
                             FROM totals
                            WHERE win_team_id = away_team_id
                              AND win_team_id = @team
                              AND season_idseason = season
                            GROUP BY season_idseason, win_team_id
                       );
            END;
            ELSE BEGIN SET @awaywins = 0; END;
            END IF;

            -- Update the amount of wins IN the leader-board with the Away Wins amount
            UPDATE leaderboard
            SET away_win = @awaywins
            WHERE season_idseason = season AND team_idteam = @team;


            -- ============================================
            -- Update Losing Data
            -- ============================================
            -- Sum up the amount of Total Losses
            IF (
                SELECT COUNT(*) AS loss
                  FROM totals
                 WHERE loss_team_id = @team
                   AND season_idseason = season
                 GROUP BY season_idseason, loss_team_id
            )
            THEN
            BEGIN
            SET @loss_count = (
                        SELECT COUNT(*) AS loss
                          FROM totals
                         WHERE loss_team_id = @team
                           AND season_idseason = season
                         GROUP BY season_idseason, loss_team_id
                       );
            END;
            ELSE BEGIN SET @loss_count = 0; END;
            END IF;

            -- Update the amount of loss IN the leader-board with the Total Wins amount
            UPDATE leaderboard
            SET loss = @loss_count
            WHERE season_idseason = season AND team_idteam = @team;


            -- Sum up the amount of Conference Win
            IF (
                SELECT COUNT(*) AS con_loss
                  FROM totals t
                 WHERE win_team_id IN (
                     SELECT idteam
                     FROM team
                     WHERE conference = (
                         SELECT conference
                         FROM team
                         WHERE idteam = loss_team_id
                         )
                     )
                 AND loss_team_id = @team
                 AND season_idseason = season
                 GROUP BY season_idseason, loss_team_id
            )
            THEN
            BEGIN
            SET @conloss = (
                            SELECT COUNT(*) AS con_loss
                             FROM totals t
                            WHERE win_team_id IN (
                                SELECT idteam
                                FROM team
                                WHERE conference = (
                                    SELECT conference
                                    FROM team
                                    WHERE idteam = loss_team_id
                                    )
                                )
                            AND loss_team_id = @team
                            AND season_idseason = season
                            GROUP BY season_idseason, loss_team_id
                       );
            END;
            ELSE BEGIN SET @conloss = 0; END;
            END IF;

            -- Update the amount of loss IN the leader-board with the Conference Wins amount
            UPDATE leaderboard
            SET conf_loss = @conloss
            WHERE season_idseason = season
              AND team_idteam = @team;



            -- Sum up the amount of Division Win
            IF (
                SELECT COUNT(*) AS div_loss
                FROM totals t
                WHERE win_team_id IN (
                    SELECT idteam
                    FROM team
                    WHERE division = (
                        SELECT division
                        FROM team
                        WHERE idteam = loss_team_id
                        )
                    )
                AND loss_team_id = @team
                AND season_idseason = season
                GROUP BY season_idseason, loss_team_id
            )
            THEN
            BEGIN
                SET @divloss = (SELECT COUNT(*) AS div_loss
                                FROM totals t
                                WHERE win_team_id IN (
                                    SELECT idteam
                                    FROM team
                                    WHERE division = (
                                        SELECT division
                                        FROM team
                                        WHERE idteam = loss_team_id
                                        )
                                    )
                                AND loss_team_id = @team
                                AND season_idseason = season
                                GROUP BY season_idseason, loss_team_id);
            END;
            ELSE BEGIN SET @divloss = 0; END;
            END IF;

            -- Update the amount of loss IN the leader-board with the Division Loss amount
            UPDATE leaderboard
            SET div_loss = @divloss
            WHERE season_idseason = season
              AND team_idteam = @team;


            -- Sum up the amount of Home Loss
            IF (
                SELECT COUNT(*) AS home_loss
                  FROM totals
                 WHERE loss_team_id = home_team_id
                   AND loss_team_id = @team
                   AND season_idseason = season
                 GROUP BY season_idseason, loss_team_id
            )
            THEN
            BEGIN
            SET @homeloss = (
                            SELECT COUNT(*) AS home_loss
                              FROM totals
                             WHERE loss_team_id = home_team_id
                               AND loss_team_id = @team
                               AND season_idseason = season
                             GROUP BY season_idseason, loss_team_id
                       );
            END;
            ELSE BEGIN SET @homeloss = 0; END;
            END IF;

            -- Update the amount of loss IN the leader-board with the Home Wins amount
            UPDATE leaderboard
            SET home_loss = @homeloss
            WHERE season_idseason = season
              AND team_idteam = @team;


            -- Sum up the amount of Away Losses
            IF (
                SELECT COUNT(*) AS away_loss
                  FROM totals
                 WHERE loss_team_id = away_team_id
                   AND loss_team_id = @team
                   AND season_idseason = season
                 GROUP BY season_idseason, loss_team_id
            )
            THEN
            BEGIN
            SET @awayloss = (
                            SELECT COUNT(*) AS away_loss
                             FROM totals
                            WHERE loss_team_id = away_team_id
                              AND loss_team_id = @team
                              AND season_idseason = season
                            GROUP BY season_idseason, loss_team_id
                       );
            END;
            ELSE BEGIN SET @awayloss = 0; END;
            END IF;

            -- Update the amount of loss IN the leader-board with the Away Wins amount
            UPDATE leaderboard
            SET away_loss = @awayloss
            WHERE season_idseason = season AND team_idteam = @team;


            -- Increase the team id variable
            SET @team = @team + 1;

            ITERATE  loop_label2;

        END LOOP;

        -- Reset the team variable
        SET @team = 1;

        -- Increase the iteration variable
        SET season = season + 1;

        END WHILE;

END$$

DELIMITER ;

CALL standings_update();

