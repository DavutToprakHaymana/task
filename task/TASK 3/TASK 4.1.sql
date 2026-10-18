 -- =====================================================================
-- Task 4: Warm-up Queries (1-5)
-- =====================================================================

-- Question 1: Total records in the fleet.
SELECT count(*) AS total_robots 
FROM robots;
-- 10
-- Interpretation: There are a total of 10 registered robots deployed in the entire fleet system.


-- Question 2: Number of active robots.
SELECT count(*) AS active_robots 
FROM robots 
WHERE status = 'active';
-- 6
-- Interpretation: Out of the 10 robots, 6 are currently operational and actively performing tasks in the field.


-- Question 3: Sum of all battery levels.
SELECT sum(battery_level) AS total_battery 
FROM robots;
-- 381
-- Interpretation: The cumulative energy storage across all active and measurable robot batteries stands at 376 percentage points.


-- Question 4: Average battery level rounded to one decimal place.
SELECT round(avg(battery_level), 1) AS avg_battery 
FROM robots;
-- 42.3
-- Interpretation: The mathematical average energy level per robot is 41.8%, excluding the unmeasurable record.


-- Question 5: Minimum and maximum battery levels.
SELECT min(battery_level) AS min_battery, max(battery_level) AS max_battery 
FROM robots;
-- 0 | 91
-- Interpretation: The fleet exhibits a critical variance, spanning from a completely depleted battery (0%) to a nearly full capacity (91%).


-- =====================================================================
-- Part 2: Medium Queries (6-10)
-- =====================================================================

-- Question 6: Count of robots grouped by their status.
SELECT status, count(*) AS robot_count 
FROM robots 
GROUP BY status;
-- 4 rows returned.
-- Interpretation: 4 rows are returned because there are exactly 4 distinct system states (active, charging, maintenance, offline) currently present in the database.


-- Question 7: Robot count and average battery level grouped by model.
SELECT model, count(*) AS robot_count, round(avg(battery_level), 1) AS avg_battery 
FROM robots 
GROUP BY model;
-- 3 rows returned.
-- Interpretation: The fleet is balanced across 3 distinct mechanical designs, where the DRN-X1 model holds the highest count but suffers from missing metrics.


-- Question 8: Count of robots grouped by zone and status.
SELECT zone, status, count(*) AS robot_count 
FROM robots 
GROUP BY zone, status;
-- 7 rows returned.
-- Interpretation: Unexpected row represents a NULL zone with an active status, meaning one robot is working outside designated containment maps.


-- Question 9: Models that have more than one robot.
SELECT model, count(*) AS robot_count 
FROM robots 
GROUP BY model 
HAVING count(*) > 1;
-- 3 rows returned.
-- Interpretation: "More than two" means strictly greater than 2 (>2). All 3 models in our database have more than 2 records, so all are listed.


-- Question 10: Models with at least 2 active robots and their average battery level.
SELECT model, round(avg(battery_level), 1) AS avg_battery 
FROM robots 
WHERE status = 'active' 
GROUP BY model 
HAVING count(*) >= 2;
-- 2 rows returned.
-- Interpretation: The WHERE clause filtered out non-active robots beforehand, while the HAVING clause eliminated models that failed to meet the minimum operational fleet size of 2 active units.


-- =====================================================================
-- Part 3: Hard Queries (11-15)
-- =====================================================================

-- Question 11: Single query to compare total count with individual column counts to hunt NULLs.
SELECT count(*) AS total_rows, count(id) AS id_count, count(name) AS name_count, 
       count(model) AS model_count, count(status) AS status_count, 
       count(battery_level) AS battery_count, count(zone) AS zone_count, 
       count(operator_name) AS operator_count 
FROM robots;
-- 10 | 10 | 10 | 10 | 10 | 9 | 9 | 9
-- Interpretation: Column metrics prove that battery_level, zone, and operator_name each contain exactly 1 missing (NULL) value.


-- Question 12: List robots with missing information.
SELECT * 
FROM robots 
WHERE battery_level IS NULL OR zone IS NULL OR operator_name IS NULL;
-- Using "= NULL" returns 0 rows because NULL cannot be compared with equality. Using "IS NULL" correctly returns 2 rows (Mars-03 and Kartal-04).
-- Interpretation: The system identifies 2 defective profiles where crucial operational or environmental parameters are completely unrecorded.


-- Question 13: Average calculated by ignoring nulls vs. treating nulls as zero.
SELECT round(avg(battery_level), 1) AS ignore_null, 
       round(avg(coalesce(battery_level, 0)), 1) AS treat_as_zero 
FROM robots;
-- 42.3 | 38.1
-- Interpretation: Treating NULL as zero drops the metric by 4.2 points. Ignoring NULL is more honest here because a missing telemetry value does not mean the physical battery is at 0%.


-- Question 14: Count of operators grouped by their hiring year.
SELECT extract(YEAR FROM hired_at) AS hire_year, count(*) AS operator_count 
FROM operators 
GROUP BY extract(YEAR FROM hired_at) 
ORDER BY hire_year;
-- 4 rows returned.
-- Interpretation: Recruitment trends show a heavy expansion curve, peaking with 5 new hires during the 2026 operational year.


-- Question 15: Categorize robots by battery status using CASE WHEN.
SELECT 
  CASE 
    WHEN battery_level < 20 THEN 'Critical'
    WHEN battery_level BETWEEN 20 AND 59 THEN 'Low'
    WHEN battery_level >= 60 THEN 'Normal'
    ELSE 'Unknown'
  END AS battery_status, 
  count(*) AS robot_count 
FROM robots 
GROUP BY 
  CASE 
    WHEN battery_level < 20 THEN 'Critical'
    WHEN battery_level BETWEEN 20 AND 59 THEN 'Low'
    WHEN battery_level >= 60 THEN 'Normal'
    ELSE 'Unknown'
  END;
-- 4 rows returned.
-- Interpretation: Kartal-04 falls into the 'Unknown' category because its battery column is NULL, failing all numeric threshold checks. Shifting the IS NULL line to the bottom changes nothing because the ELSE clause or a specific IS NULL condition catches it accurately.

