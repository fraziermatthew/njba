-- =====================================================
-- Author:      Matthew Frazier
-- Create date: 11/1/19
-- Description: Sponsor Story SQL doc.
--              SQL statment for each user story in MVP.
-- =====================================================

# 2
# As a Sponsor, I want to view the major sponsors of the league
# so that I can see all organizations who sponsor the league
DELIMITER //

CREATE PROCEDURE sponsors_list (
    IN name VARCHAR(45)
)
BEGIN
    SELECT *
      FROM njba.sponsor
     WHERE company_name != name;
END //

DELIMITER ;


# 3
# As a Sponsor, I want to submit a request to become a sponsor of the league
# so that I can contribute annual monetary gifts to the league
DELIMITER //

CREATE FUNCTION add_sponsor (
    name    VARCHAR(45),
    amt  DECIMAL(9,2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    SET @pymt_id := (SELECT MAX(idpayment) + 1 FROM payment);

    INSERT INTO payment(idpayment, amount, type)
         SELECT @pymt_id, amt, 'Sponsor'
           FROM njba.payment;

    SET @sponsorid := (
        SELECT DISTINCT idsponsor
          FROM njba.sponsor
         WHERE company_name = name
        );

    INSERT INTO sponsor_has_payment(sponsor_idsponsor, payment_idpayment)
         SELECT @sponsorid, @pymt_id
           FROM njba.sponsor_has_payment;

     RETURN 'Sponsor Added';
END //
DELIMITER ;
