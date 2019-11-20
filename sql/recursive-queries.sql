-- =====================================================
-- Author:      Matthew Frazier
-- Create date: 11/1/19
-- Description: Team Hierarchy.
-- =====================================================

/**
 * Create Hierarchy.
 */
DROP TABLE IF EXISTS team_hierarchy;

CREATE TABLE team_hierarchy
(
    id    INT AUTO_INCREMENT PRIMARY KEY,
    name  VARCHAR(20) NOT NULL,
    l_node  INT NOT NULL,
    r_node INT NOT NULL
);

INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (1,'NJBA',              1,       78);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (2,'Northern',          2,       39);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (3,'Atlantic',          3,       14);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (4,'Pandas',            4,        5);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (5,'Lions',             6,        7);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (6,'Bears',             8,        9);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (7,'Tigers',           10,       11);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (8,'Swish',            12,       13);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (9,'Pacific',          15,       26);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (10,'Toads',           16,       17);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (11,'Hoggers',         18,       19);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (12,'Gorillas',        20,       21);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (13,'Beasts',          22,       23);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (14,'Otters',          24,       25);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (15,'West',            27,       38);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (16,'Ballers',         28,       29);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (17,'Dribblers',       30,       31);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (18,'Predators',       32,       33);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (19,'Hot Shots',       34,       35);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (20,'Cheetahs',        36,       37);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (21,'Southern',        40,       77);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (28,'East',            41,       52);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (29,'Boxers',          42,       43);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (30,'Crusaders',       44,       45);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (31,'Panthers',        46,       47);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (32,'Stars',           48,       49);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (33,'Defenders',       50,       51);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (22,'Midwest',         53,       64);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (23,'Brawlers',        54,       55);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (24,'Chargers',        56,       57);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (25,'Gladiators',      58,       59);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (26,'Rippers',         60,       61);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (27,'Owls',            62,       63);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (34,'Metropolitan',    65,       76);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (35,'Crush',           66,       67);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (36,'Elephants',       68,       69);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (37,'Matadors',        70,       71);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (38,'Chiuhuahuas',     72,       73);
INSERT INTO team_hierarchy(id, name, l_node, r_node) VALUES (39,'Penetrators',     74,       75);

SELECT * FROM team_hierarchy ORDER BY id;


-- Full Tree View
SELECT node.name
FROM team_hierarchy AS node,
        team_hierarchy AS parent
WHERE node.l_node BETWEEN parent.l_node AND parent.r_node
        AND parent.name = 'NJBA'
ORDER BY node.l_node;


-- All Leaf Nodes
SELECT name
FROM team_hierarchy
WHERE r_node = l_node + 1;

-- Recursive Query
-- Tree Traversal for Tree Path (Single)
SELECT parent.name
FROM team_hierarchy AS node,
        team_hierarchy AS parent
WHERE node.l_node BETWEEN parent.l_node AND parent.r_node
        AND node.name = 'Dribblers'
ORDER BY parent.l_node;


-- Recursive Query
-- Tree Traversal for Depth of All Nodes
SELECT node.name, (COUNT(parent.name) - 1) AS depth
FROM team_hierarchy AS node,
        team_hierarchy AS parent
WHERE node.l_node BETWEEN parent.l_node AND parent.r_node
GROUP BY node.name
ORDER BY node.l_node;


-- With Indentation of Hierarchy
SELECT CONCAT( REPEAT('     ', COUNT(parent.name) - 1), node.name) AS name
FROM team_hierarchy AS node,
        team_hierarchy AS parent
WHERE node.l_node BETWEEN parent.l_node AND parent.r_node
GROUP BY node.name
ORDER BY node.l_node;

-- Recursive Query
-- Tree Traversal for Depth of A Sub-Tree
SELECT node.name, (COUNT(parent.name) - (sub_tree.depth + 1)) AS depth
FROM team_hierarchy AS node,
        team_hierarchy AS parent,
        team_hierarchy AS sub_parent,
        (
                SELECT node.name, (COUNT(parent.name) - 1) AS depth
                FROM team_hierarchy AS node,
                team_hierarchy AS parent
                WHERE node.l_node BETWEEN parent.l_node AND parent.r_node
                AND node.name = 'Northern'
                GROUP BY node.name
                ORDER BY node.l_node
        )AS sub_tree
WHERE node.l_node BETWEEN parent.l_node AND parent.r_node
        AND node.l_node BETWEEN sub_parent.l_node AND sub_parent.r_node
        AND sub_parent.name = sub_tree.name
GROUP BY node.name
ORDER BY node.l_node;


-- Recursive Query
-- Tree Traversal for Finding All Immediate Children of A Given Node
SELECT node.name, (COUNT(parent.name) - (sub_tree.depth + 1)) AS depth
FROM team_hierarchy AS node,
        team_hierarchy AS parent,
        team_hierarchy AS sub_parent,
        (
                SELECT node.name, (COUNT(parent.name) - 1) AS depth
                FROM team_hierarchy AS node,
                        team_hierarchy AS parent
                WHERE node.l_node BETWEEN parent.l_node AND parent.r_node
                        AND node.name = 'Southern'
                GROUP BY node.name
                ORDER BY node.l_node
        )AS sub_tree
WHERE node.l_node BETWEEN parent.l_node AND parent.r_node
        AND node.l_node BETWEEN sub_parent.l_node AND sub_parent.r_node
        AND sub_parent.name = sub_tree.name
GROUP BY node.name
HAVING depth <= 1
ORDER BY node.l_node;



-- Recursive Adjacency List Model
DROP TABLE IF EXISTS team_hierarchy_ralm;

CREATE TABLE team_hierarchy_ralm
(
    id    INT AUTO_INCREMENT PRIMARY KEY,
    name  VARCHAR(20) NOT NULL,
    parent  INT DEFAULT NULL
);


INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (1, 'NJBA', NULL);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (2, 'Northern',1);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (3, 'Atlantic',2);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (4, 'Pandas', 3);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (5, 'Lions', 3);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (6, 'Bears', 3);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (7, 'Tigers', 3);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (8, 'Swish', 3);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (9, 'Pacific', 2);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (10, 'Toads', 9);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (11, 'Hoggers', 9);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (12, 'Gorillas', 9);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (13, 'Beasts', 9);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (14, 'Otters', 9);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (15, 'West',2);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (16, 'Ballers', 15);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (17, 'Dribblers', 15);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (18, 'Predators', 15);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (19, 'Hot Shots', 15);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (20, 'Cheetahs', 15);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (21, 'Southern',1);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (22, 'East', 21);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (23, 'Boxers', 22);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (24, 'Crusaders', 22);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (25, 'Panthers', 22);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (26, 'Stars', 22);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (27, 'Defenders', 22);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (28, 'Midwest' ,21);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (29, 'Brawlers', 28);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (30, 'Chargers', 28);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (31, 'Gladiators', 28);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (32, 'Rippers', 28);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (33, 'Owls', 28);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (34, 'Metropolitan', 21);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (35, 'Crush', 34);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (36, 'Elephants', 34);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (37, 'Matadors', 34);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (38, 'Chiuhuahuas', 34);
INSERT INTO team_hierarchy_ralm(id, name, parent) VALUES (39, 'Penetrators', 34);


-- Full Tree View
SELECT t1.name AS lev1, t2.name as lev2, t3.name as lev3, t4.name as lev4
FROM team_hierarchy_ralm AS t1
LEFT JOIN team_hierarchy_ralm AS t2 ON t2.parent = t1.id
LEFT JOIN team_hierarchy_ralm AS t3 ON t3.parent = t2.id
LEFT JOIN team_hierarchy_ralm AS t4 ON t4.parent = t3.id
WHERE t1.name = 'NJBA';


-- Root Node
SELECT id, name
FROM team_hierarchy_ralm
WHERE parent IS NULL;

-- Finding children of a node
SELECT id, name
FROM team_hierarchy_ralm
WHERE parent = 22;

-- Finding all leaf nodes
SELECT c1.id, c1.name
FROM team_hierarchy_ralm c1
LEFT JOIN team_hierarchy_ralm c2
    ON c2.parent = c1.id
WHERE c2.id IS NULL;

-- Tree Traversal for Tree Path (Single)
SELECT t1.name AS level_1,
       t2.name as level_2,
       t3.name as level_3,
       t4.name as level_4
FROM team_hierarchy_ralm AS t1
LEFT JOIN team_hierarchy_ralm AS t2 ON t2.parent = t1.id
LEFT JOIN team_hierarchy_ralm AS t3 ON t3.parent = t2.id
LEFT JOIN team_hierarchy_ralm AS t4 ON t4.parent = t3.id
WHERE t1.name = 'NJBA' AND t4.name = 'Ballers';


  SELECT id, name, name as path
    FROM team_hierarchy_ralm
    WHERE parent IS NULL
  UNION ALL
  SELECT c.id, c.name, CONCAT( cp.name, ' > ', c.name)
    FROM team_hierarchy_ralm AS cp JOIN team_hierarchy_ralm AS c
      ON cp.id = c.parent
ORDER BY id;


-- MySQL 8.0 Recursive
/*
-- Querying the whole tree - Recursive CTE
WITH RECURSIVE category_path (id, title, path) AS
(
  SELECT id, name, name as path
    FROM team_hierarchy_ralm
    WHERE parent IS NULL
  UNION ALL
  SELECT c.id, c.name, CONCAT(cp.path, ' > ', c.name)
    FROM derived AS cp JOIN team_hierarchy_ralm AS c
      ON cp.id = c.parent
)
SELECT * FROM derived
ORDER BY path;

-- Querying a sub-tree
WITH RECURSIVE derived (id, name, path) AS
(
  SELECT id, name, name as path
    FROM team_hierarchy_ralm
    WHERE parent = 2

  UNION ALL

  SELECT c.id, c.name, CONCAT(cp.path, ' > ', c.name)
    FROM derived AS cp
    JOIN team_hierarchy_ralm AS c
      ON cp.id = c.parent
)
SELECT * FROM derived
ORDER BY path;

-- Querying a single path
WITH RECURSIVE derived (id, name, parent) AS
(
  SELECT id, name, parent
    FROM team_hierarchy_ralm
    WHERE id = 38 -- child node

  UNION ALL

  SELECT c.id, c.name, c.parent
    FROM derived AS cp
    JOIN team_hierarchy_ralm AS c
      ON cp.parent = c.id
)
SELECT * FROM derived;

-- Calculating depth level of each node
WITH RECURSIVE derived (id, name, level) AS
(
  SELECT id, name, 0 level
    FROM team_hierarchy_ralm
    WHERE parent IS NULL

  UNION ALL

  SELECT c.id, c.name, cp.level + 1
    FROM derived AS cp JOIN team_hierarchy_ralm AS c
      ON cp.id = c.parent
)
SELECT * FROM derived
ORDER BY level;

-- Moving a subtree
UPDATE team_hierarchy_ralm
   SET  parent = 2 -- Insert parent node here
 WHERE id = 31;
 */

