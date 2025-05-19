WITH max_transaction_date AS (
  SELECT MAX(transaction_date) AS latest_date FROM savings_savingsaccount
)
-- Now get all active savings or investment plans with no transaction in over a year.
SELECT 
  p.id AS plan_id,
  p.owner_id,
  CASE 
    WHEN p.is_regular_savings = 1 THEN 'Savings'
    WHEN p.is_a_fund = 1 THEN 'Investment'
    ELSE 'Unknown'
  END AS type,
  -- Get the most recent transaction for each plan
  MAX(s.transaction_date) AS last_transaction_date,
  -- Calculate how long it's been since that transaction
  DATEDIFF((SELECT latest_date FROM max_transaction_date), MAX(s.transaction_date)) AS inactivity_days

FROM 
  plans_plan p
LEFT JOIN 
  savings_savingsaccount s ON p.id = s.plan_id
-- Only include savings and investment plans that aren't deleted
WHERE 
  (p.is_regular_savings = 1 OR p.is_a_fund = 1)
  AND p.is_deleted = 0
-- Group by plan to get the latest transaction per plan
GROUP BY 
  p.id, p.owner_id, p.is_regular_savings, p.is_a_fund
-- Filter for plans that have had at least one transaction,-- and that transaction was over a year ago
HAVING 
  last_transaction_date IS NOT NULL
  AND DATEDIFF((SELECT latest_date FROM max_transaction_date), last_transaction_date) > 365;
