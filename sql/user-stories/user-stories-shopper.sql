-- =====================================================
-- Author:      Matthew Frazier
-- Create date: 11/1/19
-- Description: Shopper Story SQL doc.
--              SQL statment for each user story in MVP.
-- =====================================================

# 1
# As a Shopper, I want to view the schedule
# so that I can find a game that I want to attend where I can buy exclusive merchandise from
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


# 3
# As a Shopper, I want to be able to filter by department within the league store
# so that I can easily find what I am looking for (e.g. Men’s, Women’s, Children’s, etc.)
-- Product Department Filter
DROP FUNCTION IF EXISTS product_dept;

DELIMITER //
CREATE FUNCTION product_dept (
    department VARCHAR(10)
)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    RETURN department;
END //
DELIMITER ;

SELECT team_name,
       price,
       product_type,
       product_size,
       color,
       department
FROM products p
JOIN team_has_products thp
    ON p.idproducts = thp.products_idproducts
JOIN team t
    ON t.idteam = thp.team_idteam
WHERE product_dept('Woman') = p.department
ORDER BY department, team_name, product_type;

SET FOREIGN_KEY_CHECKS=OFF; -- to disable foreign key checks
SET FOREIGN_KEY_CHECKS=ON; -- to re-enable foreign key checks

select max(game_idgame) from box_score;

delete from box_score;
select * from box_score;

# 4
# As a Shopper, I want to be able to filter by category within the league store
# so that I can easily find what I am looking for
# (e.g. Hats, Outerwear, Shirts, Pants, Accessories, Jerseys, Footwear, etc.)
-- Product Type Filter
DROP FUNCTION IF EXISTS product_type;

DELIMITER //
CREATE FUNCTION product_type (
    type VARCHAR(15)
)
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    RETURN type;
END //
DELIMITER ;

SELECT team_name,
       price,
       product_type,
       product_size,
       color,
       department
FROM products p
JOIN team_has_products thp
    ON p.idproducts = thp.products_idproducts
JOIN team t
    ON t.idteam = thp.team_idteam
WHERE product_type('Snapback Cap') = p.product_type
ORDER BY department, team_name, product_type;


# 5
# As a Shopper, I want to filter apparel by color
# so that I can coordinate my wardrobe
-- Product Color Filter
DROP FUNCTION IF EXISTS product_color;

DELIMITER //
CREATE FUNCTION product_color (
    color VARCHAR(15)
)
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    RETURN color;
END //
DELIMITER ;

SELECT team_name,
       price,
       product_type,
       product_size,
       color,
       department
FROM products p
JOIN team_has_products thp
    ON p.idproducts = thp.products_idproducts
JOIN team t
    ON t.idteam = thp.team_idteam
WHERE product_color('Home') = p.color
ORDER BY department, team_name, product_type;


# 6
# As a Shopper, I want to filter by team
# so that I can only see relevant apparel items for my favorite team
-- Product Team Filter
DROP FUNCTION IF EXISTS product_team;

DELIMITER //
CREATE FUNCTION product_team (
    team VARCHAR(45)
)
RETURNS VARCHAR(45)
DETERMINISTIC
BEGIN
    RETURN team;
END //
DELIMITER ;

SELECT team_name,
       price,
       product_type,
       product_size,
       color,
       department
FROM products p
JOIN team_has_products thp
    ON p.idproducts = thp.products_idproducts
JOIN team t
    ON t.idteam = thp.team_idteam
WHERE product_team('Toads') = t.team_name
ORDER BY department, team_name, product_type;


# 7
# As a Shopper, I want to filter by “Sale” or “Clearance” items
# so that I can buy items on a budget
-- Create a stored procedure to make items on Sale/Clearance
-- Add a column to the products table as a flag for on Sale/Clearance
-- Alter the products table to label on Sale/Clearance items
-- Clearance = Price * 40% Off
-- Sale = Price * 15% Off


# 8
# As a Shopper, I want to view frequently purchased items
# so that I can see what apparel is trendy
-- Top Selling 15 Products
 SELECT idproducts,
        price,
        product_type,
        product_size,
        department,
        color,
        team_idteam,
        COUNT(*) as num_sold
 FROM (products_has_payment php
          JOIN products p
               ON php.products_idproducts = p.idproducts
          JOIN team_has_products thp
               ON p.idproducts = thp.products_idproducts
          JOIN team t
               ON thp.team_idteam = t.idteam)
-- Stat Filter
 GROUP BY 1
ORDER BY num_sold DESC
LIMIT 15;

select * from products;

# 10
# As a Shopper, I want to view a description of the apparel item
# so that I can learn about a product
SELECT team_name,
       price,
       product_type,
       product_size,
       color,
       department,
       description
FROM products p
JOIN team_has_products thp
    ON p.idproducts = thp.products_idproducts
JOIN team t
    ON t.idteam = thp.team_idteam
WHERE product_team('Toads') = t.team_name
and product_dept('Men') = p.department
and product_color('Home') = p.color
ORDER BY department, team_name, product_type;



# 16
# As a Shopper, I want to view details about the quality of the product
# so that I can make an informed purchase (e.g. Mesh fabric, Dry clean only, 80% Polyester, etc.)
# Would need to create a new one to many relationship for this in mysql workbench
SELECT team_name,
       price,
       product_type,
       product_size,
       color,
       department,
       details
FROM products p
JOIN team_has_products thp
    ON p.idproducts = thp.products_idproducts
JOIN team t
    ON t.idteam = thp.team_idteam
WHERE idproducts = 34
ORDER BY department, team_name, product_type;

# 18
# As a Shopper, I want to view related items with respect to my selected item
# so that I can have a variety of options to choose from before making a purchase
# e.g. A man who purchased a Toads home jersey would be shown
# other Toad Men home products
SELECT team_name,
       price,
       product_type,
       product_size,
       color,
       department
FROM products p
JOIN team_has_products thp
    ON p.idproducts = thp.products_idproducts
JOIN team t
    ON t.idteam = thp.team_idteam
WHERE product_team('Toads') = t.team_name
and product_dept('Men') = p.department
and product_color('Home') = p.color
ORDER BY department, team_name, product_type;
