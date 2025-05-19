WITH ALL_USER_PLAN AS ( 
  SELECT
    u.id AS owner_id,
    u.first_name,
    u.last_name,
    p.id AS plan_id,
    p.is_a_fund,
    p.is_regular_savings,
    s.amount
  FROM savings_savingsaccount s
  LEFT JOIN plans_plan p ON s.plan_id = p.id
  LEFT JOIN users_customuser u ON p.owner_id = u.id
)
SELECT
  owner_id,
  CONCAT(first_name, ' ', last_name) AS name,
  COUNT(DISTINCT CASE WHEN is_regular_savings = 1 AND amount > 0 THEN plan_id END) AS savings_count,
  COUNT(DISTINCT CASE WHEN is_a_fund = 1 AND amount > 0 THEN plan_id END) AS investment_count,
  SUM(amount) AS total_deposits
FROM ALL_USER_PLAN
GROUP BY owner_id, first_name, last_name
HAVING
  COUNT(DISTINCT CASE WHEN is_regular_savings = 1 AND amount > 0 THEN plan_id END) >= 1
  AND COUNT(DISTINCT CASE WHEN is_a_fund = 1 AND amount > 0 THEN plan_id END) >= 1
ORDER BY total_deposits DESC;
