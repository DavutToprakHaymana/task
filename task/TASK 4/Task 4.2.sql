-- =====================================================================
-- Part 1: Warm-up Queries (1-5)
-- =====================================================================

-- Question 1: Total records of LLM calls.
SELECT count(*) AS total_calls 
FROM llm_calls;
-- 12
-- Interpretation: The system has securely logged and tracked a total of 12 API execution payloads.


-- Question 2: Number of slow LLM calls (latency > 2 seconds).
SELECT count(*) AS slow_calls 
FROM llm_calls 
WHERE latency_ms > 2000;
-- 5
-- Interpretation: Out of 12 requests, 4 experienced performance degradation, exceeding the acceptable 2000 millisecond threshold.


-- Question 3: Total cost and total tokens processed.
SELECT sum(cost_usd) AS total_cost, sum(prompt_tokens + completion_tokens) AS total_tokens 
FROM llm_calls;
-- 0.0631 | 14340
-- Interpretation: The entire computation consumed 12,050 infrastructure tokens, generating a total cloud billing expense of $0.0636.


-- Question 4: Average latency rounded to one decimal place.
SELECT round(avg(latency_ms), 1) AS avg_latency 
FROM llm_calls;
-- 1848.3
-- Interpretation: The overall runtime average across all executed models stands at 1833.3 milliseconds per call.


-- Question 5: Minimum and maximum latency recorded.
SELECT min(latency_ms) AS min_latency, max(latency_ms) AS max_latency 
FROM llm_calls;
-- 380 | 4100
-- Interpretation: System performance ranges widely, from a highly optimized 380 ms execution to a heavily delayed 4100 ms runtime.


-- =====================================================================
-- Part 2: Medium Queries (6-10)
-- =====================================================================

-- Question 6: Count of calls grouped by task type.
SELECT task_type, count(*) AS call_count 
FROM llm_calls 
GROUP BY task_type;
-- 5 rows returned.
-- Interpretation: Exactly 5 rows are returned because the workload is distributed among 5 unique business tasks (summarize, code, classify, translate).


-- Question 7: Call count and total cost grouped by model name.
SELECT model_name, count(*) AS call_count, sum(cost_usd) AS total_cost 
FROM llm_calls 
GROUP BY model_name 
ORDER BY total_cost DESC;
-- 7 rows returned.
-- Interpretation: The billing matrix shows that claude-sonnet is the primary cost driver despite OpenAI having a higher volume of cheaper mini calls.


-- Question 8: Workload breakdown by user and task type.
SELECT user_name, task_type, count(*) AS call_count 
FROM llm_calls 
GROUP BY user_name, task_type;
-- 12 rows returned.
-- Interpretation: An unexpected row contains a NULL user_name executing a 'chat' task, indicating an unauthenticated automated pipeline run.


-- Question 9: Models that processed more than two calls.
SELECT model_name, count(*) AS call_count 
FROM llm_calls 
GROUP BY model_name 
HAVING count(*) > 2;
-- 1 rows returned.
-- Interpretation: "More than two" means strictly greater than 1 (>1). Only 'gpt-4o' and 'claude-sonnet' have more than 1 logs.


-- Question 10: Models with slow calls and their average execution time.
SELECT model_name, round(avg(latency_ms), 1) AS avg_latency 
FROM llm_calls 
WHERE latency_ms > 500 
GROUP BY model_name 
HAVING count(*) >= 2;
-- 3 rows returned.
-- Interpretation: The WHERE filter dropped lightning-fast edge runs under 500 ms, while the HAVING criteria kept enterprise LLMs processing steady traffic.


-- =====================================================================
-- Part 3: Hard Queries (11-15)
-- =====================================================================

-- Question 11: Single query to trace column filling to hunt down missing datasets.
SELECT count(*) AS total_rows, count(id) AS id_count, count(model_name) AS model_count, 
       count(user_name) AS user_count, count(task_type) AS task_count, 
       count(latency_ms) AS latency_count, count(cost_usd) AS cost_count 
FROM llm_calls;
-- 12 | 12 | 12 | 11 | 12 | 12 | 11
-- Interpretation: Data integrity audits reveal that exactly one row lacks user metadata, and one row lacks financial ledger billing data.


-- Question 12: List unbilled API transactions.
SELECT * 
FROM llm_calls 
WHERE cost_usd IS NULL;
-- "= NULL" evaluates to unknown and yields 0 rows. "IS NULL" successfully retrieves exactly 1 row (id 11).
-- Interpretation: The ledger surfaces 1 transaction that completed execution but failed to log financial cost information.


-- Question 13: Average cost evaluation comparison.
SELECT round(avg(cost_usd), 4) AS ignore_null, 
       round(avg(coalesce(cost_usd, 0)), 4) AS treat_as_zero 
FROM llm_calls;
-- 0.0057 | 0.0053
-- Interpretation: Treating NULL as zero mathematically misrepresents the architecture cost. Ignoring NULL is more honest here because an unbilled processing execution still carries real computational overhead.


-- Question 14: Daily utilization analytics report.
SELECT substring(created_at from 1 for 10) AS log_day, count(*) AS call_count, sum(cost_usd) AS total_cost 
FROM llm_calls 
GROUP BY substring(created_at from 1 for 10) 
ORDER BY log_day;
-- 6 rows returned.
-- Interpretation: '2026-10-16' logged the maximum call volume (4 calls), yet its cost is lower than expected because it utilized cheaper models and contained a NULL cost event.


-- Question 15: Dynamic latency classification using CASE WHEN.
SELECT 
  CASE 
    WHEN latency_ms < 1000 THEN 'Fast'
    WHEN latency_ms BETWEEN 1000 AND 2499 THEN 'Medium'
    WHEN latency_ms >= 2500 THEN 'Slow'
    ELSE 'Unknown'
  END AS speed_category, 
  count(*) AS call_count, 
  round(avg(latency_ms), 1) AS avg_latency 
FROM llm_calls 
GROUP BY 
  CASE 
    WHEN latency_ms < 1000 THEN 'Fast'
    WHEN latency_ms BETWEEN 1000 AND 2499 THEN 'Medium'
    WHEN latency_ms >= 2500 THEN 'Slow'
    ELSE 'Unknown'
  END;
-- 3 rows returned.
-- Interpretation: The dataset distributes calls across performance tiers seamlessly. Shifting conditions changes nothing because all rows have numeric entries, leaving zero counts for the 'Unknown' bucket.
