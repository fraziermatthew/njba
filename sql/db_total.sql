-- =====================================================
-- Author:      Matthew Frazier
-- Create date: 11/1/19
-- Description: Provide results of -> select count(*)
--              for each table.
-- =====================================================

SELECT COUNT(*) box_score_count
  FROM njba.box_score;

SELECT COUNT(*) coach_count
  FROM njba.coach;

SELECT COUNT(*) donor_count
  FROM njba.donor;

SELECT COUNT(*) fan_count
  FROM njba.fan;

SELECT COUNT(*) fan_has_game_count
  FROM njba.fan_has_game;

SELECT COUNT(*) game_count
  FROM njba.game;

SELECT COUNT(*) game_has_referee_count
  FROM njba.game_has_referee;

SELECT COUNT(*) payment_count
  FROM njba.payment;

SELECT COUNT(*) player_count
  FROM njba.player;

SELECT COUNT(*) products_count
  FROM njba.products;

SELECT COUNT(*) products_has_payment_count
  FROM njba.products_has_payment;

SELECT COUNT(*) referee_count
  FROM njba.referee;

SELECT COUNT(*) referee_has_season_count
  FROM njba.referee_has_season;

SELECT COUNT(*) season_count
  FROM njba.season;

SELECT COUNT(*) season_has_coach_count
  FROM njba.season_has_coach;

SELECT COUNT(*) shopper_count
  FROM njba.shopper;

SELECT COUNT(*) sponsor_count
  FROM njba.sponsor;

SELECT COUNT(*) sponsor_has_payment_count
  FROM njba.sponsor_has_payment;

SELECT COUNT(*) team_count
  FROM njba.team;

SELECT COUNT(*) team_has_products_count
  FROM njba.team_has_products;

  SELECT table_schema “njba”,
         sum( data_length + index_length )
             / 1024 / 1024 /1024 'DB Size (GB)'
    FROM information_schema.TABLES
GROUP BY table_schema;
