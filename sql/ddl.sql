-- =====================================================
-- Author:      Matthew Frazier
-- Create date: 11/1/19
-- Description: DML for the physical data model.
--              Show indexes.
-- =====================================================

CREATE SCHEMA IF NOT EXISTS njba COLLATE latin1_swedish_ci;

CREATE TABLE IF NOT EXISTS box_score
(
	player_idplayer INT     UNSIGNED NOT NULL,
	game_idgame     INT     UNSIGNED NOT NULL,
	mins            TINYINT UNSIGNED NOT NULL,
	fga             TINYINT UNSIGNED NOT NULL,
	fgm             TINYINT UNSIGNED NOT NULL,
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
	team_idteam     INT     UNSIGNED NOT NULL,
	PRIMARY KEY (player_idplayer, game_idgame)
);

CREATE TABLE IF NOT EXISTS fan
(
	idfan INT UNSIGNED NOT NULL
		PRIMARY KEY,
	first_name VARCHAR(45) NOT NULL,
	last_name VARCHAR(45) NOT NULL,
	full_name VARCHAR(90) NOT NULL,
	email_name VARCHAR(45) NOT NULL,
	email_host VARCHAR(45) NOT NULL,
	email_domain VARCHAR(45) NOT NULL
);

CREATE INDEX full_name_idx
	ON fan (full_name);

CREATE INDEX idfan_idx
	ON fan (idfan);

CREATE TABLE IF NOT EXISTS payment
(
	idpayment INT UNSIGNED NOT NULL
		PRIMARY KEY,
	amount DECIMAL(9,2) UNSIGNED NULL,
	type ENUM('Shopper', 'Sponsor', 'Donor') NULL
);

CREATE TABLE IF NOT EXISTS donor
(
	iddonor INT UNSIGNED NOT NULL,
	payment_idpayment INT UNSIGNED NOT NULL,
	company_name VARCHAR(45) NULL,
	street_address VARCHAR(45) NULL,
	PRIMARY KEY (iddonor, payment_idpayment),
	CONSTRAINT fk_donor_payment1
		FOREIGN KEY (payment_idpayment) REFERENCES payment (idpayment)
);

CREATE INDEX fk_donor_payment1_idx
	ON donor (payment_idpayment);

CREATE TABLE IF NOT EXISTS products
(
	idproducts INT UNSIGNED NOT NULL
		PRIMARY KEY,
	price DECIMAL(9,2) UNSIGNED NOT NULL,
	product_type ENUM('Snapback Cap', 'Fitted Cap', 'T-Shirt', 'Sweatpants',
                      'Sweatshirt', 'Jersey', 'Shorts', 'Socks',
                      'Hoodie', 'Coat', 'Basketball') NOT NULL,
	product_size ENUM('XS', 'S', 'M', 'L', 'XL', 'ALL') NULL
);

CREATE TABLE IF NOT EXISTS products_has_payment
(
	products_idproducts INT UNSIGNED NOT NULL,
	payment_idpayment INT UNSIGNED NOT NULL,
	PRIMARY KEY (products_idproducts, payment_idpayment),
	CONSTRAINT fk_products_has_payment1_payment1
		FOREIGN KEY (payment_idpayment) REFERENCES payment (idpayment),
	CONSTRAINT fk_products_has_payment1_products1
		FOREIGN KEY (products_idproducts) REFERENCES products (idproducts)
);

CREATE INDEX fk_products_has_payment1_payment1_idx
	ON products_has_payment (payment_idpayment);

CREATE INDEX fk_products_has_payment1_products1_idx
	ON products_has_payment (products_idproducts);

CREATE TABLE IF NOT EXISTS referee
(
	idreferee INT UNSIGNED NOT NULL
		PRIMARY KEY,
	first_name VARCHAR(45) NULL,
	last_name VARCHAR(45) NULL,
	full_name VARCHAR(90) NULL,
	title VARCHAR(45) NULL
);

CREATE TABLE IF NOT EXISTS season
(
	idseason INT UNSIGNED NOT NULL
		PRIMARY KEY,
	start_date date NOT NULL,
	end_date date NOT NULL,
	type ENUM('Pre', 'Regular', 'Post') NOT NULL
);

CREATE TABLE IF NOT EXISTS referee_has_season
(
	season_idseason INT UNSIGNED NOT NULL,
	referee_idreferee INT UNSIGNED NOT NULL,
	PRIMARY KEY (season_idseason, referee_idreferee),
	CONSTRAINT fk_referee_has_season_referee1
		FOREIGN KEY (referee_idreferee) REFERENCES referee (idreferee)
			ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_referee_has_season_season1
		FOREIGN KEY (season_idseason) REFERENCES season (idseason)
			ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX fk_referee_has_season_referee1_idx
	ON referee_has_season (referee_idreferee);

CREATE INDEX fk_referee_has_season_season1_idx
	ON referee_has_season (season_idseason);

CREATE TABLE IF NOT EXISTS shopper
(
	idshopper INT UNSIGNED NOT NULL,
	payment_idpayment INT UNSIGNED NOT NULL,
	first_name VARCHAR(45) NOT NULL,
	last_name VARCHAR(45) NOT NULL,
	full_name VARCHAR(90) NOT NULL,
	street_address VARCHAR(45) NULL,
	zip_code VARCHAR(45) NULL,
	PRIMARY KEY (idshopper, payment_idpayment),
	CONSTRAINT fk_shopper_payment1
		FOREIGN KEY (payment_idpayment) REFERENCES payment (idpayment)
);

CREATE INDEX fk_shopper_payment1_idx
	ON shopper (payment_idpayment);

CREATE TABLE IF NOT EXISTS sponsor
(
	idsponsor INT UNSIGNED NOT NULL
		PRIMARY KEY,
	company_name VARCHAR(45) NULL,
	street_address VARCHAR(45) NULL,
	phone VARCHAR(15) NULL
);

CREATE TABLE IF NOT EXISTS sponsor_has_payment
(
	sponsor_idsponsor INT UNSIGNED NOT NULL,
	payment_idpayment INT UNSIGNED NOT NULL,
	PRIMARY KEY (sponsor_idsponsor, payment_idpayment),
	CONSTRAINT fk_sponsor_has_payment_payment1
		FOREIGN KEY (payment_idpayment) REFERENCES payment (idpayment),
	CONSTRAINT fk_sponsor_has_payment_sponsor1
		FOREIGN KEY (sponsor_idsponsor) REFERENCES sponsor (idsponsor)
);

CREATE INDEX fk_sponsor_has_payment_payment1_idx
	ON sponsor_has_payment (payment_idpayment);

CREATE INDEX fk_sponsor_has_payment_sponsor1_idx
	ON sponsor_has_payment (sponsor_idsponsor);

CREATE TABLE IF NOT EXISTS team
(
	idteam INT UNSIGNED NOT NULL
		PRIMARY KEY,
	team_name VARCHAR(45) NOT NULL,
	location VARCHAR(45) NOT NULL,
	conference VARCHAR(15) NOT NULL,
	division VARCHAR(15) NOT NULL,
	mascot VARCHAR(45) NULL,
	CONSTRAINT fk_team_idteam
		FOREIGN KEY (idteam) REFERENCES box_score (player_idplayer)
			ON UPDATE CASCADE ON DELETE CASCADE
);

alter table box_score
	add CONSTRAINT fk_box_score_team1
		FOREIGN KEY (team_idteam) REFERENCES team (idteam)
			ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS coach
(
	idcoach INT UNSIGNED NOT NULL,
	team_idteam INT UNSIGNED NOT NULL,
	first_name VARCHAR(45) NOT NULL,
	last_name VARCHAR(45) NOT NULL,
	full_name VARCHAR(90) NOT NULL,
	title VARCHAR(45) NOT NULL,
	PRIMARY KEY (idcoach, team_idteam),
	CONSTRAINT fk_coach_team1
		FOREIGN KEY (team_idteam) REFERENCES team (idteam)
);

CREATE INDEX fk_coach_team1_idx
	ON coach (team_idteam);

CREATE TABLE IF NOT EXISTS game
(
	idgame INT UNSIGNED NOT NULL,
	season_idseason INT UNSIGNED NOT NULL,
	date date NULL,
	time VARCHAR(15) NULL,
	home_team_id INT UNSIGNED NULL,
	away_team_id INT UNSIGNED NULL,
	venue VARCHAR(45) NULL,
	attendance INT UNSIGNED NULL,
	PRIMARY KEY (idgame, season_idseason),
	CONSTRAINT fk_away_team_id
		FOREIGN KEY (away_team_id) REFERENCES team (idteam)
			ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_game_season1
		FOREIGN KEY (season_idseason) REFERENCES season (idseason),
	CONSTRAINT fk_home_team_id
		FOREIGN KEY (home_team_id) REFERENCES team (idteam)
			ON UPDATE CASCADE ON DELETE CASCADE
);

alter table box_score
	add CONSTRAINT fk_box_score_game1
		FOREIGN KEY (game_idgame) REFERENCES game (idgame)
			ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS fan_has_game
(
	fan_idfan INT UNSIGNED NOT NULL,
	game_idgame INT UNSIGNED NOT NULL,
	PRIMARY KEY (fan_idfan, game_idgame),
	CONSTRAINT fk_fan_has_game_fan1
		FOREIGN KEY (fan_idfan) REFERENCES fan (idfan)
			ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_fan_has_game_game1
		FOREIGN KEY (game_idgame) REFERENCES game (idgame)
			ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX fk_fan_has_game_fan1_idx
	ON fan_has_game (fan_idfan);

CREATE INDEX fk_fan_has_game_game1_idx
	ON fan_has_game (game_idgame);

CREATE INDEX fk_away_team_id_idx
	ON game (away_team_id);

CREATE INDEX fk_game_season1_idx
	ON game (season_idseason);

CREATE INDEX fk_home_team_id_idx
	ON game (home_team_id);

CREATE TABLE IF NOT EXISTS game_has_referee
(
	game_idgame INT UNSIGNED NOT NULL,
	game_season_idseason INT UNSIGNED NOT NULL,
	referee_idreferee INT UNSIGNED NOT NULL,
	PRIMARY KEY (game_idgame, game_season_idseason, referee_idreferee),
	CONSTRAINT fk_game_has_referee_game1
		FOREIGN KEY (game_idgame, game_season_idseason) REFERENCES game (idgame, season_idseason),
	CONSTRAINT fk_game_has_referee_referee1
		FOREIGN KEY (referee_idreferee) REFERENCES referee (idreferee)
);

CREATE INDEX fk_game_has_referee_game1_idx
	ON game_has_referee (game_idgame, game_season_idseason);

CREATE INDEX fk_game_has_referee_referee1_idx
	ON game_has_referee (referee_idreferee);

CREATE TABLE IF NOT EXISTS player
(
	idplayer INT UNSIGNED NOT NULL
		PRIMARY KEY,
	first_name VARCHAR(45) NOT NULL,
	last_name VARCHAR(45) NOT NULL,
	full_name VARCHAR(125) NOT NULL,
	position ENUM('PG', 'SG', 'SF', 'PF', 'C') NOT NULL,
	jersey TINYINT UNSIGNED NOT NULL,
	school VARCHAR(75) NOT NULL,
	team_idteam INT UNSIGNED NOT NULL,
	CONSTRAINT fk_player_team1
		FOREIGN KEY (team_idteam) REFERENCES team (idteam)
);

alter table box_score
	add CONSTRAINT fk_box_score_player1
		FOREIGN KEY (player_idplayer) REFERENCES player (idplayer)
			ON UPDATE CASCADE ON DELETE CASCADE;

CREATE INDEX fk_player_team1_idx
	ON player (team_idteam);

CREATE INDEX name
	ON player (first_name, last_name);

CREATE TABLE IF NOT EXISTS season_has_coach
(
	season_idseason INT UNSIGNED NOT NULL,
	coach_idcoach INT UNSIGNED NOT NULL,
	coach_team_idteam INT UNSIGNED NOT NULL,
	PRIMARY KEY (season_idseason, coach_idcoach, coach_team_idteam),
	CONSTRAINT fk_season_has_coach_coach1
		FOREIGN KEY (coach_idcoach, coach_team_idteam) REFERENCES coach (idcoach, team_idteam),
	CONSTRAINT fk_season_has_coach_season1
		FOREIGN KEY (season_idseason) REFERENCES season (idseason)
);

CREATE INDEX fk_season_has_coach_coach1_idx
	ON season_has_coach (coach_idcoach, coach_team_idteam);

CREATE INDEX fk_season_has_coach_season1_idx
	ON season_has_coach (season_idseason);

CREATE TABLE IF NOT EXISTS team_has_products
(
	team_idteam INT UNSIGNED NOT NULL,
	products_idproducts INT UNSIGNED NOT NULL,
	PRIMARY KEY (team_idteam, products_idproducts),
	CONSTRAINT fk_team_has_products_products1
		FOREIGN KEY (products_idproducts) REFERENCES products (idproducts),
	CONSTRAINT fk_team_has_products_team1
		FOREIGN KEY (team_idteam) REFERENCES team (idteam)
);

CREATE INDEX fk_team_has_products_products1_idx
	ON team_has_products (products_idproducts);

CREATE INDEX fk_team_has_products_team1_idx
	ON team_has_products (team_idteam);

