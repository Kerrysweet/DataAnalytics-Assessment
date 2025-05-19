WITH customer_transactions AS (
  SELECT 
    owner_id AS customer_id,
    transaction_date
  FROM savings_savingsaccount
  WHERE transaction_date BETWEEN '2016-08-28' AND '2025-04-18'
),

monthly_counts AS (
  SELECT
    customer_id,
    DATE_FORMAT(transaction_date, '%Y-%m-01') AS month,
    COUNT(*) AS transactions
  FROM customer_transactions
  GROUP BY customer_id, DATE_FORMAT(transaction_date, '%Y-%m-01')
),

customer_stats AS (
  SELECT
    u.id AS customer_id,
    COALESCE(AVG(m.transactions), 0) AS avg_transactions_per_month,
    COUNT(m.month) AS active_months
  FROM users_customuser u
  LEFT JOIN monthly_counts m ON u.id = m.customer_id
  GROUP BY u.id
)
SELECT
  CASE
    WHEN active_months = 0 THEN 'Zero Transactions'
    WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
    WHEN avg_transactions_per_month >= 3 THEN 'Medium Frequency'
    ELSE 'Low Frequency'
  END AS frequency_category,
  COUNT(*) AS customer_count,
  ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM customer_stats
GROUP BY frequency_category
ORDER BY
  CASE frequency_category
    WHEN 'High Frequency' THEN 1
    WHEN 'Medium Frequency' THEN 2
    WHEN 'Low Frequency' THEN 3
    WHEN 'Zero Transactions' THEN 4
  END;