-- =====================================================================
-- Part 1: Easy Queries (1-5)
-- =====================================================================

-- Question 1: List the names and models of all robots.
SELECT name, model 
FROM robots;
-- 10 rows returned.


-- Question 2: Display the robot name as "robot", and the missing charge amount (100 minus battery_level) as "missing".
SELECT name AS robot, (100 - battery_level) AS missing 
FROM robots;
-- 10 rows returned.


-- Question 3: Robots with a battery level above 50.
SELECT * 
FROM robots 
WHERE battery_level > 50;
-- 4 rows returned.


-- Question 4: Robots that are in maintenance status.
SELECT * 
FROM robots 
WHERE status = 'maintenance';
-- 1 row returned.


-- Question 5: Robots that are not in active status.
SELECT * 
FROM robots 
WHERE status != 'active';
-- 4 rows returned.


-- =====================================================================
-- Part 2: Medium Queries (6-10)
-- =====================================================================

-- Question 6: Robots that belong to the 'AMR-300' model and have a battery level above 40.
SELECT * 
FROM robots 
WHERE model = 'AMR-300' AND battery_level > 40;
-- 2 rows returned.


-- Question 7: Robots that are either charging or in maintenance, and have a battery level below 50.
SELECT * 
FROM robots 
WHERE (status = 'charging' OR status = 'maintenance') AND battery_level < 50;
-- 1 row returned.
-- Note: When executed without parentheses, 2 rows are returned instead of 1. Because the AND operator has higher precedence than OR, the unparenthesized query evaluates as "all robots that are charging OR robots that are in maintenance with a battery level below 50". This causes Kartal-04 (which is charging and has a NULL battery level) to be incorrectly included, resulting in a difference of 1 row.


-- Question 8: Robots with a battery level between 15 and 50 (inclusive).
SELECT * 
FROM robots 
WHERE battery_level BETWEEN 15 AND 50;
-- 3 rows returned.


-- Question 9: Robots that are not located in 'Depo A' or 'Depo B'.
SELECT * 
FROM robots 
WHERE zone NOT IN ('Depo A', 'Depo B') OR zone IS NULL;
-- 5 rows returned.


-- Question 10: Robots whose names start with "kartal", case-insensitively.
SELECT * 
FROM robots 
WHERE name ILIKE 'kartal%';
-- 4 rows returned.
-- Note: 4 rows were expected, and exactly 4 rows were returned. There is no discrepancy because the ILIKE operator eliminates case sensitivity, successfully matching all records starting with "Kartal".


-- =====================================================================
-- Part 3: Hard Queries (11-15)
-- =====================================================================

-- Question 11: Sort the robots first by model (A to Z), and then by battery level within the same model (highest to lowest).
SELECT * 
FROM robots 
ORDER BY model ASC, battery_level DESC;
-- 10 rows returned.


-- Question 12: Top 3 robots with the highest battery levels.
SELECT * 
FROM robots 
WHERE battery_level IS NOT NULL 
ORDER BY battery_level DESC 
LIMIT 3;
-- 3 rows returned.


-- Question 13: What distinct zones exist in the fleet?
SELECT DISTINCT zone 
FROM robots 
WHERE zone IS NOT NULL;
-- 5 rows returned.


-- Question 14: List the operator names sorted correctly according to the Turkish alphabet.
SELECT operator_name 
FROM operators 
ORDER BY operator_name;
-- 10 rows returned.
-- Note: In standard English sorting, Turkish characters are pushed to the very end of the list. With proper linguistic collation, names containing Turkish characters shifted positions to their correct alphabetical order: "Çağla" moved ahead of "Can", and "Şule" placed correctly between "Deniz" and "Emre".


-- Question 15: List the name, zone, and battery level of active robots that are in 'Dış Alan' or 'Depo B', sorted by battery level from lowest to highest.
SELECT name, zone, battery_level 
FROM robots 
WHERE zone IN ('Dış Alan', 'Depo B') AND status = 'active'
ORDER BY battery_level ASC;
-- 4 rows returned.
