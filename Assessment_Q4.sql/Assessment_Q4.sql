WITH customer_transaction_profits AS (
    SELECT
        owner_id,
        COUNT(id) AS total_transactions,
        SUM(transaction_profit) AS total_profit
    FROM (
        SELECT
            owner_id,
            id,
            confirmed_amount * 0.001 AS transaction_profit
        FROM
            savings_savingsaccount
        WHERE
            transaction_status = 'successful' AND confirmed_amount > 0
        UNION ALL
        SELECT
            owner_id,
            id,
            amount_withdrawn * 0.001 AS transaction_profit
        FROM
            withdrawals_withdrawal
        WHERE
            transaction_status_id IN (/* Replace with actual successful withdrawal status IDs */ 3, 4) AND amount_withdrawn > 0
    ) AS transactions_with_profit
    GROUP BY
        owner_id
),
customer_data AS (
    SELECT
        u.id AS customer_id,
        u.first_name,
        u.last_name,
        u.date_joined,
        COALESCE(ctp.total_transactions, 0) AS total_transactions,
        COALESCE(ctp.total_profit, 0) AS total_profit_kobo
    FROM
        users_customuser u
    LEFT JOIN
        customer_transaction_profits ctp ON u.id = ctp.owner_id
)
SELECT
    customer_id,
    CONCAT(first_name, ' ', last_name) AS customer_name,
    TIMESTAMPDIFF(MONTH, date_joined, '2025-05-19') AS account_tenure_months,
    total_transactions,
    ROUND(
        CASE
            WHEN TIMESTAMPDIFF(MONTH, date_joined, '2025-05-19') > 0 AND total_transactions > 0
            THEN (total_transactions / TIMESTAMPDIFF(MONTH, date_joined, '2025-05-19')) * 12 * (total_profit_kobo / total_transactions)
            ELSE 0
        END, 2
    ) AS estimated_clv_kobo
FROM
    customer_data
ORDER BY
    estimated_clv_kobo DESC;