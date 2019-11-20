-- =====================================================
-- Author:      Matthew Frazier
-- Create date: 11/1/19
-- Description: DML for the physical data model.
--              Show indexes.
-- =====================================================

CREATE SCHEMA IF NOT EXISTS njba COLLATE latin1_swedish_ci;

CREATE TABLE box_score
(
    player_idplayer INT UNSIGNED     NOT NULL,
    game_idgame     INT UNSIGNED     NOT NULL,
    mins            TINYINT UNSIGNED NOT NULL,
    fgm             TINYINT UNSIGNED NOT NULL,
    fga             TINYINT UNSIGNED NOT NULL,
    fg_pct          TINYINT UNSIGNED NOT NULL,
    fg3             TINYINT UNSIGNED NOT NULL,
    fg3a            TINYINT UNSIGNED NOT NULL,
    fg3_pct         TINYINT UNSIGNED NOT NULL,
    ft              TINYINT UNSIGNED NOT NULL,
    fta             TINYINT UNSIGNED NOT NULL,
    ft_pct          TINYINT UNSIGNED NOT NULL,
    orb             TINYINT UNSIGNED NOT NULL,
    drb             TINYINT UNSIGNED NOT NULL,
    trb             TINYINT UNSIGNED NOT NULL,
    ast             TINYINT UNSIGNED NOT NULL,
    blk             TINYINT UNSIGNED NOT NULL,
    tov             TINYINT UNSIGNED NOT NULL,
    fouls           TINYINT UNSIGNED NOT NULL,
    pts             TINYINT UNSIGNED NOT NULL,
    team_idteam     INT UNSIGNED     NOT NULL,
    PRIMARY KEY (player_idplayer, game_idgame)
);

CREATE index fk_box_score_game1_idx
	ON box_score (game_idgame);

CREATE index fk_box_score_player1_idx
	ON box_score (player_idplayer);

CREATE index fk_box_score_team1_idx
	ON box_score (team_idteam);

CREATE TABLE fan
(
    idfan        INT UNSIGNED NOT NULL
        PRIMARY KEY,
    first_name   VARCHAR(45)  NOT NULL,
    last_name    VARCHAR(45)  NOT NULL,
    full_name    VARCHAR(90)  NOT NULL,
    email_name   VARCHAR(45)  NOT NULL,
    email_host   VARCHAR(45)  NOT NULL,
    email_domain VARCHAR(45)  NOT NULL
);

CREATE index full_name_idx
	ON fan (full_name);

CREATE index idfan_idx
	ON fan (idfan);

CREATE TABLE loss
(
    season_idseason INT UNSIGNED        NOT NULL,
    loss_team_id    BIGINT(10) UNSIGNED NULL,
    idgame          INT UNSIGNED        NOT NULL,
    loss            TINYINT             NOT NULL,
    conf_loss       TINYINT             NOT NULL,
    div_loss        TINYINT             NOT NULL,
    home_loss       TINYINT             NOT NULL,
    away_loss       TINYINT             NOT NULL
);

CREATE TABLE payment
(
    idpayment INT UNSIGNED                         NOT NULL
        PRIMARY KEY,
    amount    DECIMAL(9, 2) UNSIGNED               NULL,
    type      ENUM ('Shopper', 'Sponsor', 'Donor') NULL
);

CREATE TABLE donor
(
    iddonor           INT UNSIGNED NOT NULL,
    payment_idpayment INT UNSIGNED NOT NULL,
    company_name      VARCHAR(45)  NULL,
    street_address    VARCHAR(45)  NULL,
    PRIMARY KEY (iddonor, payment_idpayment),
    CONSTRAINT fk_donor_payment1
        FOREIGN KEY (payment_idpayment) REFERENCES payment (idpayment)
);

CREATE index fk_donor_payment1_idx
	ON donor (payment_idpayment);

CREATE TABLE products
(
    idproducts   INT UNSIGNED                            NOT NULL
        PRIMARY KEY,
    price        DECIMAL(9, 2) UNSIGNED                  NOT NULL,
    product_type ENUM ('Snapback Cap', 'Fitted Cap', 'T-Shirt',
        'Sweatpants', 'Sweatshirt', 'Jersey', 'Shorts',
        'Socks', 'Hoodie', 'Coat', 'Basketball')         NOT NULL,
    product_size ENUM ('XS', 'S', 'M', 'L', 'XL', 'ALL') NULL,
    department   ENUM ('Men', 'Woman', 'Children')       NOT NULL,
    color        VARCHAR(15)                             NOT NULL,
    description  VARCHAR(90)                             NOT NULL,
    details      VARCHAR(90)                             NOT NULL
);

CREATE TABLE products_has_payment
(
    products_idproducts INT UNSIGNED NOT NULL,
    payment_idpayment   INT UNSIGNED NOT NULL,
    PRIMARY KEY (products_idproducts, payment_idpayment),
    CONSTRAINT fk_products_has_payment1_payment1
        FOREIGN KEY (payment_idpayment)
            REFERENCES payment (idpayment),
    CONSTRAINT fk_products_has_payment1_products1
        FOREIGN KEY (products_idproducts)
            REFERENCES products (idproducts)
);

CREATE index fk_products_has_payment1_payment1_idx
	ON products_has_payment (payment_idpayment);

CREATE index fk_products_has_payment1_products1_idx
	ON products_has_payment (products_idproducts);

CREATE TABLE referee
(
    idreferee  INT UNSIGNED NOT NULL
        PRIMARY KEY,
    first_name VARCHAR(45)  NULL,
    last_name  VARCHAR(45)  NULL,
    full_name  VARCHAR(90)  NULL,
    title      VARCHAR(45)  NULL
);

CREATE TABLE season
(
    idseason   INT UNSIGNED                    NOT NULL
        PRIMARY KEY,
    start_date date                            NOT NULL,
    end_date   date                            NOT NULL,
    type       ENUM ('Pre', 'Regular', 'Post') NOT NULL
);

CREATE TABLE referee_has_season
(
    season_idseason   INT UNSIGNED NOT NULL,
    referee_idreferee INT UNSIGNED NOT NULL,
    PRIMARY KEY (season_idseason, referee_idreferee),
    CONSTRAINT fk_referee_has_season_referee1
        FOREIGN KEY (referee_idreferee) REFERENCES referee (idreferee)
            ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_referee_has_season_season1
        FOREIGN KEY (season_idseason) REFERENCES season (idseason)
            ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE index fk_referee_has_season_referee1_idx
	ON referee_has_season (referee_idreferee);

CREATE index fk_referee_has_season_season1_idx
	ON referee_has_season (season_idseason);

CREATE TABLE shopper
(
    idshopper         INT UNSIGNED NOT NULL,
    payment_idpayment INT UNSIGNED NOT NULL,
    first_name        VARCHAR(45)  NOT NULL,
    last_name         VARCHAR(45)  NOT NULL,
    full_name         VARCHAR(90)  NOT NULL,
    street_address    VARCHAR(45)  NULL,
    zip_code          VARCHAR(45)  NULL,
    PRIMARY KEY (idshopper, payment_idpayment),
    CONSTRAINT fk_shopper_payment1
        FOREIGN KEY (payment_idpayment) REFERENCES payment (idpayment)
);

CREATE index fk_shopper_payment1_idx
	ON shopper (payment_idpayment);

CREATE TABLE sponsor
(
    idsponsor      INT UNSIGNED NOT NULL
        PRIMARY KEY,
    company_name   VARCHAR(45)  NULL,
    street_address VARCHAR(45)  NULL,
    phone          VARCHAR(15)  NULL
);

CREATE TABLE sponsor_has_payment
(
	sponsor_idsponsor INT UNSIGNED NOT NULL,
	payment_idpayment INT UNSIGNED NOT NULL,
	PRIMARY KEY (sponsor_idsponsor, payment_idpayment),
	CONSTRAINT fk_sponsor_has_payment_payment1
		FOREIGN KEY (payment_idpayment)
		    REFERENCES payment (idpayment),
	CONSTRAINT fk_sponsor_has_payment_sponsor1
		FOREIGN KEY (sponsor_idsponsor)
		    REFERENCES sponsor (idsponsor)
);

CREATE index fk_sponsor_has_payment_payment1_idx
	ON sponsor_has_payment (payment_idpayment);

CREATE index fk_sponsor_has_payment_sponsor1_idx
	ON sponsor_has_payment (sponsor_idsponsor);

CREATE TABLE team
(
    idteam     INT UNSIGNED NOT NULL
        PRIMARY KEY,
    team_name  VARCHAR(45)  NOT NULL,
    location   VARCHAR(45)  NOT NULL,
    conference VARCHAR(15)  NOT NULL,
    division   VARCHAR(15)  NOT NULL,
    mascot     VARCHAR(45)  NULL,
    CONSTRAINT fk_team_idteam
        FOREIGN KEY (idteam)
            REFERENCES box_score (player_idplayer)
            ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE box_score
	ADD CONSTRAINT fk_box_score_team1
		FOREIGN KEY (team_idteam)
		    REFERENCES team (idteam)
			ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE coach
(
    idcoach     INT UNSIGNED NOT NULL,
    team_idteam INT UNSIGNED NOT NULL,
    first_name  VARCHAR(45)  NOT NULL,
    last_name   VARCHAR(45)  NOT NULL,
    full_name   VARCHAR(90)  NOT NULL,
    title       VARCHAR(45)  NOT NULL,
    PRIMARY KEY (idcoach, team_idteam),
    CONSTRAINT fk_coach_team1
        FOREIGN KEY (team_idteam) REFERENCES team (idteam)
);

CREATE index fk_coach_team1_idx
	ON coach (team_idteam);

CREATE TABLE game
(
    idgame          INT UNSIGNED NOT NULL,
    season_idseason INT UNSIGNED NOT NULL,
    date            DATE         NULL,
    time            VARCHAR(15)  NULL,
    home_team_id    INT UNSIGNED NULL,
    away_team_id    INT UNSIGNED NULL,
    venue           VARCHAR(45)  NULL,
    attendance      INT UNSIGNED NULL,
    PRIMARY KEY (idgame, season_idseason),
    CONSTRAINT fk_away_team_id
        FOREIGN KEY (away_team_id)
            REFERENCES team (idteam)
            ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_game_season1
        FOREIGN KEY (season_idseason)
            REFERENCES season (idseason),
    CONSTRAINT fk_home_team_id
        FOREIGN KEY (home_team_id)
            REFERENCES team (idteam)
            ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE box_score
	ADD CONSTRAINT fk_box_score_game1
		FOREIGN KEY (game_idgame)
		    REFERENCES game (idgame)
			ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE fan_has_game
(
    fan_idfan   INT UNSIGNED NOT NULL,
    game_idgame INT UNSIGNED NOT NULL,
    PRIMARY KEY (fan_idfan, game_idgame),
    CONSTRAINT fk_fan_has_game_fan1
        FOREIGN KEY (fan_idfan)
            REFERENCES fan (idfan)
            ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_fan_has_game_game1
        FOREIGN KEY (game_idgame)
            REFERENCES game (idgame)
            ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE index fk_fan_has_game_fan1_idx
	ON fan_has_game (fan_idfan);

CREATE index fk_fan_has_game_game1_idx
	ON fan_has_game (game_idgame);

CREATE index fk_away_team_id_idx
	ON game (away_team_id);

CREATE index fk_game_season1_idx
	ON game (season_idseason);

CREATE index fk_home_team_id_idx
	ON game (home_team_id);

CREATE index game_date_idx
	ON game (date);

CREATE TABLE game_has_referee
(
    game_idgame          INT UNSIGNED NOT NULL,
    game_season_idseason INT UNSIGNED NOT NULL,
    referee_idreferee    INT UNSIGNED NOT NULL,
    PRIMARY KEY (game_idgame, game_season_idseason, referee_idreferee),
    CONSTRAINT fk_game_has_referee_game1
        FOREIGN KEY (game_idgame, game_season_idseason)
            REFERENCES game (idgame, season_idseason),
    CONSTRAINT fk_game_has_referee_referee1
        FOREIGN KEY (referee_idreferee)
            REFERENCES referee (idreferee)
);

CREATE index fk_game_has_referee_game1_idx
	ON game_has_referee (game_idgame, game_season_idseason);

CREATE index fk_game_has_referee_referee1_idx
	ON game_has_referee (referee_idreferee);

CREATE TABLE leaderboard
(
    season_idseason INT UNSIGNED           NOT NULL,
    team_idteam     INT UNSIGNED           NOT NULL,
    wins            INT UNSIGNED DEFAULT 0 NOT NULL,
    loss            INT UNSIGNED DEFAULT 0 NOT NULL,
    conf_win        INT UNSIGNED DEFAULT 0 NOT NULL,
    div_win         INT UNSIGNED DEFAULT 0 NOT NULL,
    conf_loss       INT UNSIGNED DEFAULT 0 NOT NULL,
    div_loss        INT UNSIGNED DEFAULT 0 NOT NULL,
    home_win        INT UNSIGNED DEFAULT 0 NOT NULL,
    away_win        INT UNSIGNED DEFAULT 0 NOT NULL,
    home_loss       INT UNSIGNED DEFAULT 0 NOT NULL,
    away_loss       INT UNSIGNED DEFAULT 0 NOT NULL,
    PRIMARY KEY (season_idseason, team_idteam),
    CONSTRAINT fk_season_ida
        FOREIGN KEY (season_idseason)
            REFERENCES season (idseason)
            ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_team_idteama
        FOREIGN KEY (team_idteam)
            REFERENCES team (idteam)
            ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE index fk_leaderboard1_idx
	ON leaderboard (season_idseason);

CREATE index fk_leaderboard2_idx
	ON leaderboard (team_idteam);

CREATE TABLE player
(
    idplayer    INT UNSIGNED                       NOT NULL
        PRIMARY KEY,
    first_name  VARCHAR(45)                        NOT NULL,
    last_name   VARCHAR(45)                        NOT NULL,
    full_name   VARCHAR(125)                       NOT NULL,
    position    ENUM ('PG', 'SG', 'SF', 'PF', 'C') NOT NULL,
    jersey      TINYINT UNSIGNED                   NOT NULL,
    school      VARCHAR(75)                        NOT NULL,
    team_idteam INT UNSIGNED                       NOT NULL,
    CONSTRAINT fk_player_team1
        FOREIGN KEY (team_idteam)
            REFERENCES team (idteam)
);

ALTER TABLE box_score
	ADD CONSTRAINT fk_box_score_player1
		FOREIGN KEY (player_idplayer)
		    REFERENCES player (idplayer)
			ON UPDATE CASCADE ON DELETE CASCADE;

CREATE index fk_player_team1_idx
	ON player (team_idteam);

CREATE index name
	ON player (first_name, last_name);

CREATE index player_idx_idplayer
	ON player (idplayer);

CREATE TABLE season_has_coach
(
    season_idseason   INT UNSIGNED NOT NULL,
    coach_idcoach     INT UNSIGNED NOT NULL,
    coach_team_idteam INT UNSIGNED NOT NULL,
    PRIMARY KEY (season_idseason, coach_idcoach, coach_team_idteam),
    CONSTRAINT fk_season_has_coach_coach1
        FOREIGN KEY (coach_idcoach, coach_team_idteam)
            REFERENCES coach (idcoach, team_idteam),
    CONSTRAINT fk_season_has_coach_season1
        FOREIGN KEY (season_idseason)
            REFERENCES season (idseason)
);

CREATE index fk_season_has_coach_coach1_idx
	ON season_has_coach (coach_idcoach, coach_team_idteam);

CREATE index fk_season_has_coach_season1_idx
	ON season_has_coach (season_idseason);

CREATE index team_idx_team_name
	ON team (team_name);

CREATE TABLE team_has_products
(
    team_idteam         INT UNSIGNED NOT NULL,
    products_idproducts INT UNSIGNED NOT NULL,
    PRIMARY KEY (team_idteam, products_idproducts),
    CONSTRAINT fk_team_has_products_products1
        FOREIGN KEY (products_idproducts)
            REFERENCES products (idproducts),
    CONSTRAINT fk_team_has_products_team1
        FOREIGN KEY (team_idteam)
            REFERENCES team (idteam)
);

CREATE index fk_team_has_products_products1_idx
	ON team_has_products (products_idproducts);

CREATE index fk_team_has_products_team1_idx
	ON team_has_products (team_idteam);

CREATE TABLE team_hierarchy
(
    id     INT AUTO_INCREMENT
        PRIMARY KEY,
    name   VARCHAR(20) NOT NULL,
    l_node INT         NOT NULL,
    r_node INT         NOT NULL
);

CREATE TABLE team_hierarchy_ralm
(
    id     INT AUTO_INCREMENT
        PRIMARY KEY,
    name   VARCHAR(20) NOT NULL,
    parent INT         NULL
);

CREATE TABLE totals
(
    idgame          INT UNSIGNED NOT NULL,
    season_idseason INT UNSIGNED NOT NULL,
    home_team_id    INT UNSIGNED NULL,
    away_team_id    INT UNSIGNED NULL,
    win_team_id     INT UNSIGNED NULL,
    loss_team_id    INT UNSIGNED NULL
);

CREATE index season_idx_win
	ON totals (season_idseason);

CREATE index winteamid_idx_win
	ON totals (win_team_id);

CREATE TABLE win
(
    season_idseason INT UNSIGNED         NOT NULL,
    win_team_id     BIGINT(10) UNSIGNED  NULL,
    idgame          INT UNSIGNED         NOT NULL,
    win             BIGINT(21) DEFAULT 0 NOT NULL,
    conf_win        INT(1)     DEFAULT 0 NOT NULL,
    div_win         INT(1)     DEFAULT 0 NOT NULL,
    home_win        INT(1)     DEFAULT 0 NOT NULL,
    away_win        INT(1)     DEFAULT 0 NOT NULL
);

CREATE index season_idx_win
	ON win (season_idseason);

CREATE index winteamid_idx_win
	ON win (win_team_id);

CREATE definer = admin@`%` view games_played AS
(
    SELECT `game_total`.`team_name` AS `team_name`,
           SUM(`game_total`.`games_played`) AS `games_played`
    FROM (
            SELECT COUNT(0) AS `games_played`, `njba`.`team`.`team_name` AS `team_name`
            FROM (`njba`.`schedule` `s`
            JOIN `njba`.`team`
            ON ((`njba`.`team`.`team_name` = `s`.`home`)))
            WHERE (`s`.`date` BETWEEN `start_date`() AND `end_date`())
            GROUP BY `njba`.`team`.`team_name`

            UNION ALL

            SELECT COUNT(0) AS `games_played`, `njba`.`team`.`team_name` AS `team_name`
            FROM (`njba`.`schedule` `s`
            JOIN `njba`.`team`
            ON ((`njba`.`team`.`team_name` = `s`.`away`)))
            WHERE (`s`.`date` BETWEEN `start_date`() AND `end_date`())
            GROUP BY `njba`.`team`.`team_name`
        ) `game_total`
    GROUP BY `game_total`.`team_name`
);

CREATE definer = admin@`%` view player_adv AS (
SELECT `t`.`team_name`                                                                               AS `team_name`,
       `p`.`full_name`                                                                               AS `full_name`,
       ROUND((((SUM((`pr`.`fgm` + `pr`.`fg3`)) + (0.5 * `pr`.`fg3`))
                   / SUM((`pr`.`fga` + `pr`.`fg3a`))) * 100),
             1)                                                                                      AS `efg_pct`,
       ROUND((SUM((`pr`.`fga` + `pr`.`fg3a`)) + (0.475 * `pr`.`fta`)),
             1)                                                                                      AS `tsa`,
       ROUND(((`pr`.`points` / (2 * (SUM((`pr`.`fga` + `pr`.`fg3a`)) +
                                     (0.475 * `pr`.`fta`)))) * 100),
             1)                                                                                      AS `ts_pct`,
       ROUND(((`pr`.`ft` /
               SUM((`pr`.`fga` + `pr`.`fg3a`))) * 100), 1)                                           AS `ftr`,
       ROUND(((100 * `pr`.`turnovers`) /
              ((SUM((`pr`.`fga` + `pr`.`fg3a`)) + (0.44 * `pr`.`fta`)) + `pr`.`turnovers`)),
             1)                                                                                      AS `tov_pct`,
       ROUND((((((((((`pr`.`points` +
                      (0.4 * SUM((`pr`.`fga` + `pr`.`fg3a`)))) - (0.7 * `pr`.`fga`)) -
                    (0.4 * (`pr`.`fta` - `pr`.`ft`))) + (0.7 * `pr`.`orb`)) + (0.3 * `pr`.`drb`)) +
                 (0.7 * `pr`.`assists`)) + (0.7 * `pr`.`blocks`)) -
               (0.4 * `pr`.`fouls`)) - `pr`.`turnovers`),
             1)                                                                                      AS `gmsc`
FROM (((`njba`.`player_raw` `pr`
    JOIN `njba`.`player` `p`
    ON ((`pr`.`full_name` = `p`.`full_name`)))
    JOIN `njba`.`team` `t`
    ON ((`pr`.`team_name` = `t`.`team_name`)))
    JOIN `njba`.`games_played` `gp`
    ON ((`t`.`team_name` = `gp`.`team_name`)))
GROUP BY `t`.`team_name`, `p`.`full_name`
ORDER BY `t`.`team_name`, `p`.`full_name`);

CREATE definer = admin@`%` view player_avg AS (
SELECT `t`.`team_name`                                                AS `team_name`,
       `p`.`full_name`                                                AS `full_name`,
       AVG(`b`.`mins`)                                                AS `mins`,
       AVG(`b`.`fgm`)                                                 AS `fgm`,
       AVG(`b`.`fga`)                                                 AS `fga`,
       (CASE WHEN (`b`.`fga` <> 0)
           THEN ROUND(((AVG(`b`.`fgm`) / AVG(`b`.`fga`)) * 100), 1)
           ELSE 0 END)                                                AS `fg_pct`,
       AVG(`b`.`fg3`)                                                 AS `fg3`,
       AVG(`b`.`fg3a`)                                                AS `fg3a`,
       (CASE WHEN (`b`.`fg3a` <> 0)
           THEN ROUND(((AVG(`b`.`fg3`) / AVG(`b`.`fg3a`)) * 100), 1)
           ELSE 0 END)                                                AS `fg3_pct`,
       AVG(`b`.`ft`)                                                  AS `ft`,
       AVG(`b`.`fta`)                                                 AS `fta`,
       (CASE WHEN (`b`.`fta` <> 0)
           THEN ROUND(((AVG(`b`.`ft`) / AVG(`b`.`fta`)) * 100), 1)
           ELSE 0 END)                                                AS `ft_pct`,
       AVG(`b`.`orb`)                                                 AS `orb`,
       AVG(`b`.`drb`)                                                 AS `drb`,
       AVG(`b`.`trb`)                                                 AS `trb`,
       AVG(`b`.`ast`)                                                 AS `assists`,
       AVG(`b`.`blk`)                                                 AS `blocks`,
       AVG(`b`.`tov`)                                                 AS `turnovers`,
       AVG(`b`.`fouls`)                                               AS `fouls`,
       AVG(`b`.`pts`)                                                 AS `points`
FROM (((`njba`.`game` `g`
    JOIN `njba`.`box_score` `b`
    ON ((`g`.`idgame` = `b`.`game_idgame`)))
    JOIN `njba`.`player` `p`
    ON ((`b`.`player_idplayer` = `p`.`idplayer`)))
    JOIN `njba`.`team` `t`
    ON ((`b`.`team_idteam` = `t`.`idteam`)))
WHERE (`g`.`date` BETWEEN `start_date`() AND `end_date`())
GROUP BY `t`.`team_name`, `p`.`full_name`
ORDER BY `t`.`team_name`, `p`.`full_name`);

CREATE definer = admin@`%` view player_raw AS (
SELECT `t`.`team_name`                                AS `team_name`,
       `p`.`full_name`                                AS `full_name`,
       SUM(`b`.`mins`)                                AS `mins`,
       SUM(`b`.`fgm`)                                 AS `fgm`,
       SUM(`b`.`fga`)                                 AS `fga`,
       (CASE WHEN (`b`.`fga` <> 0)
           THEN ROUND(((SUM(`b`.`fgm`) /
                        SUM(`b`.`fga`)) * 100), 1)
           ELSE 0 END)                                AS `fg_pct`,
       SUM(`b`.`fg3`)                                 AS `fg3`,
       SUM(`b`.`fg3a`)                                AS `fg3a`,
       (CASE WHEN (`b`.`fg3a` <> 0)
           THEN ROUND(((SUM(`b`.`fg3`) /
                        SUM(`b`.`fg3a`)) * 100), 1)
           ELSE 0 END)                                AS `fg3_pct`,
       SUM(`b`.`ft`)                                  AS `ft`,
       SUM(`b`.`fta`)                                 AS `fta`,
       (CASE WHEN (`b`.`fta` <> 0)
           THEN ROUND(((SUM(`b`.`ft`) /
                        SUM(`b`.`fta`)) * 100), 1)
           ELSE 0 END)                                AS `ft_pct`,
       SUM(`b`.`orb`)                                 AS `orb`,
       SUM(`b`.`drb`)                                 AS `drb`,
       SUM(`b`.`trb`)                                 AS `trb`,
       SUM(`b`.`ast`)                                 AS `assists`,
       SUM(`b`.`blk`)                                 AS `blocks`,
       SUM(`b`.`tov`)                                 AS `turnovers`,
       SUM(`b`.`fouls`)                               AS `fouls`,
       SUM(`b`.`pts`)                                 AS `points`
FROM ((((`njba`.`game` `g`
    JOIN `njba`.`box_score` `b`
    ON ((`g`.`idgame` = `b`.`game_idgame`)))
    JOIN `njba`.`player` `p`
    ON ((`b`.`player_idplayer` = `p`.`idplayer`)))
    JOIN `njba`.`team` `t` ON ((`b`.`team_idteam` = `t`.`idteam`)))
    JOIN `njba`.`games_played` `gp`
    ON ((`t`.`team_name` = `gp`.`team_name`)))
WHERE (`g`.`date` BETWEEN `start_date`() AND `end_date`())
GROUP BY `t`.`team_name`, `p`.`full_name`
ORDER BY `t`.`team_name`, `p`.`full_name`);

CREATE definer = admin@`%` view schedule AS (
SELECT `g`.`date`                                              AS `date`,
       (SELECT `njba`.`team`.`team_name`
        FROM `njba`.`team`
        WHERE (`njba`.`team`.`idteam` = `g`.`home_team_id`))   AS `home`,
       (SELECT `njba`.`team`.`team_name`
        FROM `njba`.`team`
        WHERE (`njba`.`team`.`idteam` = `g`.`away_team_id`))   AS `away`
FROM `njba`.`game` `g`);

CREATE definer = admin@`%` view standings AS (
SELECT `standings`.`season_idseason`                                                 AS `season_idseason`,
       `standings`.`idteam`                                                          AS `idteam`,
       SUM(`standings`.`game_win`)                                                   AS `wins`,
       SUM(`standings`.`game_loss`)                                                  AS `loses`,
       ROUND(((SUM(`standings`.`game_win`) / 
               SUM((`standings`.`game_win` + `standings`.`game_loss`))) * 100), 1)   AS `win_pct`,      
       CONCAT(CAST(SUM(`standings`.`conf_win`) AS CHAR(2) charset utf8mb4), ' - ',
              CAST(SUM(`standings`.`cONf_loss`) AS CHAR(2) charset utf8mb4))         AS `conf_record`,
       CONCAT(CAST(SUM(`standings`.`div_win`) AS CHAR(2) charset utf8mb4), ' - ',
              CAST(SUM(`standings`.`div_loss`) AS CHAR(2) charset utf8mb4))          AS `div_record`,
       CONCAT(CAST(SUM(`standings`.`home_win`) AS CHAR(2) charset utf8mb4), ' - ',
              CAST(SUM(`standings`.`home_loss`) AS CHAR(2) charset utf8mb4))         AS `home_record`,
       CONCAT(CAST(SUM(`standings`.`away_win`) AS CHAR(2) charset utf8mb4), ' - ',
              CAST(SUM(`standings`.`away_loss`) AS CHAR(2) charset utf8mb4))         AS `away_record`
FROM (SELECT `s`.`season_idseason`                                             AS `season_idseason`,
             `t`.`idteam`                                                      AS `idteam`,
             `t`.`conference`                                                  AS `conference`,
             `t`.`division`                                                    AS `division`,
             `s`.`win_team_id`                                                 AS `win_team_id`,
             `s`.`loss_team_id`                                                AS `loss_team_id`,
             (CASE WHEN (`s`.`win_team_id` = `t`.`idteam`) THEN 1 ELSE 0 END)  AS `game_win`,
             (CASE WHEN (`s`.`loss_team_id` = `t`.`idteam`) THEN 1 ELSE 0 END) AS `game_loss`,
             (CASE
                  WHEN ((`s`.`win_team_id` = `t`.`idteam`) AND
                        (`t`.`conference` = (SELECT `t`.`conference`
                                             FROM `njba`.`team` `t`
                                             WHERE (`s`.`loss_team_id` = `t`.`idteam`))))
                      THEN 1
                  ELSE 0 END)                                                  AS `conf_win`,
             (CASE
                  WHEN ((`s`.`loss_team_id` = `t`.`idteam`) AND
                        (`t`.`conference` = (SELECT `t`.`conference`
                                             FROM `njba`.`team` `t`
                                             WHERE (`s`.`win_team_id` = `t`.`idteam`))))
                      THEN 1
                  ELSE 0 END)                                                  AS `cONf_loss`,
             (CASE
                  WHEN ((`s`.`win_team_id` = `t`.`idteam`) AND
                        (`t`.`division` = (SELECT `t`.`division`
                                           FROM `njba`.`team` `t`
                                           WHERE (`s`.`loss_team_id` = `t`.`idteam`))))
                      THEN 1
                  ELSE 0 END)                                                  AS `div_win`,
             (CASE
                  WHEN ((`s`.`loss_team_id` = `t`.`idteam`) AND
                        (`t`.`division` = (SELECT `t`.`division`
                                           FROM `njba`.`team` `t`
                                           WHERE (`s`.`win_team_id` = `t`.`idteam`))))
                      THEN 1
                  ELSE 0 END)                                                  AS `div_loss`,
             (CASE
                  WHEN ((`s`.`win_team_id` = `t`.`idteam`) AND
                        (`s`.`home_team_id` = `s`.`win_team_id`)) THEN 1
                  ELSE 0 END)                                                  AS `home_win`,
             (CASE
                  WHEN ((`s`.`loss_team_id` = `t`.`idteam`) AND
                        (`s`.`home_team_id` = `s`.`loss_team_id`)) THEN 1
                  ELSE 0 END)                                                  AS `home_loss`,
             (CASE
                  WHEN ((`s`.`win_team_id` = `t`.`idteam`) AND
                        (`s`.`away_team_id` = `s`.`win_team_id`)) THEN 1
                  ELSE 0 END)                                                  AS `away_win`,
             (CASE
                  WHEN ((`s`.`loss_team_id` = `t`.`idteam`) AND
                        (`s`.`away_team_id` = `s`.`loss_team_id`)) THEN 1
                  ELSE 0 END)                                                  AS `away_loss`
      FROM (`njba`.`totals` `s`
               JOIN `njba`.`team` `t`)) `standings`
GROUP BY `standings`.`idteam`);

CREATE definer = admin@`%` view team_avg AS (
SELECT `t`.`team_name`                                    AS `team_name`,
       ROUND(SUM((`b`.`mins` / `gp`.`games_played`)), 0)  AS `mins`,
       ROUND((SUM(`b`.`fgm`) / `gp`.`games_played`), 0)   AS `team_fgm`,
       ROUND((SUM(`b`.`fga`) / `gp`.`games_played`), 0)   AS `team_fga`,
       ROUND(((ROUND((SUM(`b`.`fgm`) / `gp`.`games_played`), 0) / ROUND((SUM(`b`.`fga`) / `gp`.`games_played`), 0)) *
              100), 1)                                    AS `team_fg_pct`,
       ROUND((SUM(`b`.`fg3`) / `gp`.`games_played`), 0)   AS `team_fg3`,
       ROUND((SUM(`b`.`fg3a`) / `gp`.`games_played`), 0)  AS `team_fg3a`,
       ROUND(((ROUND((SUM(`b`.`fg3`) / `gp`.`games_played`), 0) / ROUND((SUM(`b`.`fg3a`) / `gp`.`games_played`), 0)) *
              100), 1)                                    AS `team_fg3_pct`,
       ROUND((SUM(`b`.`ft`) / `gp`.`games_played`), 0)    AS `team_ft`,
       ROUND((SUM(`b`.`fta`) / `gp`.`games_played`), 0)   AS `team_fta`,
       ROUND(((ROUND((SUM(`b`.`ft`) / `gp`.`games_played`), 0) / ROUND((SUM(`b`.`fta`) / `gp`.`games_played`), 0)) *
              100), 1)                                    AS `team_ft_pct`,
       ROUND((SUM(`b`.`orb`) / `gp`.`games_played`), 0)   AS `team_orb`,
       ROUND((SUM(`b`.`drb`) / `gp`.`games_played`), 0)   AS `team_drb`,
       ROUND((SUM(`b`.`trb`) / `gp`.`games_played`), 0)   AS `team_trb`,
       ROUND((SUM(`b`.`ast`) / `gp`.`games_played`), 0)   AS `team_assists`,
       ROUND((SUM(`b`.`blk`) / `gp`.`games_played`), 0)   AS `team_blocks`,
       ROUND((SUM(`b`.`tov`) / `gp`.`games_played`), 0)   AS `team_turnovers`,
       ROUND((SUM(`b`.`fouls`) / `gp`.`games_played`), 0) AS `team_fouls`,
       ROUND((SUM(`b`.`pts`) / `gp`.`games_played`), 0)   AS `team_points`
FROM (((`njba`.`game` `g`
    JOIN `njba`.`box_score` `b`
    ON ((`g`.`idgame` = `b`.`game_idgame`)))
    JOIN `njba`.`team` `t`
    ON ((`b`.`team_idteam` = `t`.`idteam`)))
    JOIN `njba`.`games_played` `gp`
    ON ((`t`.`team_name` = `gp`.`team_name`)))
WHERE (`g`.`date` BETWEEN `start_date`() AND `end_date`())
GROUP BY `t`.`team_name`
ORDER BY `t`.`team_name`);

CREATE definer = admin@`%` view team_raw AS (
SELECT `t`.`team_name`                                      AS `team_name`,
       ROUND(SUM(`b`.`mins`), 0)                            AS `mins`,
       SUM(`b`.`fgm`)                                       AS `team_fgm`,
       SUM(`b`.`fga`)                                       AS `team_fga`,
       ROUND(((SUM(`b`.`fgm`) / SUM(`b`.`fga`)) * 100), 1)  AS `team_fg_pct`,
       SUM(`b`.`fg3`)                                       AS `team_fg3`,
       SUM(`b`.`fg3a`)                                      AS `team_fg3a`,
       ROUND(((SUM(`b`.`fg3`) / SUM(`b`.`fg3a`)) * 100), 1) AS `team_fg3_pct`,
       SUM(`b`.`ft`)                                        AS `team_ft`,
       SUM(`b`.`fta`)                                       AS `team_fta`,
       ROUND(((SUM(`b`.`ft`) / SUM(`b`.`fta`)) * 100), 1)   AS `team_ft_pct`,
       SUM(`b`.`orb`)                                       AS `team_orb`,
       SUM(`b`.`drb`)                                       AS `team_drb`,
       SUM(`b`.`trb`)                                       AS `team_trb`,
       SUM(`b`.`ast`)                                       AS `team_assists`,
       SUM(`b`.`blk`)                                       AS `team_blocks`,
       SUM(`b`.`tov`)                                       AS `team_turnovers`,
       SUM(`b`.`fouls`)                                     AS `team_fouls`,
       SUM(`b`.`pts`)                                       AS `team_points`
FROM (((`njba`.`game` `g`
    JOIN `njba`.`box_score` `b`
    ON ((`g`.`idgame` = `b`.`game_idgame`)))
    JOIN `njba`.`team` `t`
    ON ((`b`.`team_idteam` = `t`.`idteam`)))
    JOIN `njba`.`games_played` `gp`
    ON ((`t`.`team_name` = `gp`.`team_name`)))
WHERE (`g`.`date` BETWEEN `start_date`() AND `end_date`())
GROUP BY `t`.`team_name`
ORDER BY `t`.`team_name`);

CREATE definer = admin@`%` FUNCTION end_date() RETURNS VARCHAR(10)
BEGIN
    RETURN '2069-06-13';
END;

CREATE definer = admin@`%` FUNCTION fan_buys_ticket(gameID INT UNSIGNED,
                                                    first_name VARCHAR(45),
                                                    last_name VARCHAR(45),
                                                    email_name VARCHAR(45),
                                                    email_host VARCHAR(45),
                                                    email_domain VARCHAR(45)) RETURNS VARCHAR(20)
BEGIN
    -- If this is a new fan
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
        -- Add the new fan to the fan TABLE
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
    -- If this is an old fan, find the fan id
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

    -- Simulate fan purchasing ticket, ADD fan to fan_has_game TABLE
    INSERT INTO fan_has_game(fan_idfan, game_idgame)
         SELECT @fan_id, gameid
           FROM fan_has_game;

    RETURN 'Fan Added';
END;

CREATE definer = admin@`%` procedure payment_sum()
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
        SET @amt = (
                    SELECT SUM(price)
                    FROM products
                    WHERE idproducts in (
                        SELECT products_idproducts
                        FROM products_has_payment
                        WHERE payment_idpayment = paymentid
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

END;

CREATE definer = admin@`%` FUNCTION player_name(name VARCHAR(90)) RETURNS VARCHAR(90)
BEGIN
    RETURN name;
END;

CREATE definer = admin@`%` FUNCTION product_color(color VARCHAR(15)) RETURNS VARCHAR(15)
BEGIN
    RETURN color;
END;

CREATE definer = admin@`%` FUNCTION product_dept(department VARCHAR(10)) RETURNS VARCHAR(10)
BEGIN
    RETURN department;
END;

CREATE definer = admin@`%` FUNCTION product_team(team VARCHAR(45)) RETURNS VARCHAR(45)
BEGIN
    RETURN team;
END;

CREATE definer = admin@`%` FUNCTION product_type(type VARCHAR(15)) RETURNS VARCHAR(15)
BEGIN
    RETURN type;
END;

CREATE definer = admin@`%` FUNCTION season() RETURNS TINYINT(1)
BEGIN
    RETURN 1;
END;

CREATE definer = admin@`%` procedure standings_update()
BEGIN

    -- Season ID iteration variable
    DECLARE season INT;
    SET season = 1;

    -- Team ID iteration variable
    SET @team = 1;

    -- Begin Loop
    WHILE season <= 30 DO

        loop_label2:  LOOP

            -- For each team in the loop
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

END;

CREATE definer = admin@`%` FUNCTION start_date() RETURNS VARCHAR(10)
BEGIN
    RETURN '2019-08-01';
END;

CREATE definer = admin@`%` FUNCTION stat_filter(id VARCHAR(10)) RETURNS VARCHAR(10)
BEGIN
    RETURN id;
END;

CREATE definer = admin@`%` FUNCTION team_name(name VARCHAR(90)) RETURNS VARCHAR(90)
BEGIN
    RETURN name;
END;

