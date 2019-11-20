-- =====================================================
-- Author:      Matthew Frazier
-- Create date: 11/1/19
-- Description: Donor Story SQL doc.
--              SQL statment for each user story in MVP.
-- =====================================================

# 2
# As a Donor, I want to view the other donors of the league so
# that I can see all one-time donor who support the league
DELIMITER //

CREATE PROCEDURE donors_list (
    IN name VARCHAR(45)
)
BEGIN
    SELECT *
      FROM njba.donor
     WHERE company_name != name;
END //

DELIMITER ;


# 3
# As a Donor, I want to submit a request to make a donation
# so that I can easily contribute one-time monetary gifts to the league
DELIMITER //

CREATE FUNCTION add_donor (
    name    VARCHAR(45),
    address VARCHAR(45),
    amt     DECIMAL(9,2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    SET @pymt_id := (SELECT MAX(idpayment) + 1 FROM payment);

    INSERT INTO payment(idpayment, amount, type)
         SELECT @pymt_id, amt, 'Donor'
           FROM payment;

    SET @donorid := (SELECT MAX(iddonor) + 1 FROM donor);

    INSERT INTO donor(iddonor, payment_idpayment, company_name, street_address)
         SELECT @donorid, @pymt_id, name, address
           FROM donor;
    RETURN 'Donor Added';
END //
DELIMITER ;
