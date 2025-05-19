
    Task
To write a SQL query to find customers who have at least one funded savings plan AND at least one funded investment plan, and return those customers sorted by their total deposits.

    Approach
1. WITH ALL_USER_PLAN AS (...)
codes here was for merging and organizing necessary data from the three tables
- savings_savingsaccount (contain deposit amounts)
- plans_plan(contains funded savings plan AND funded investment plan)
- users_customuser (customer first and last names)

-This step helps isolate and simplify the logic used in my final query-

2. Filtering for Funded Plans
In the main query, I used "CASE WHEN" logic combined with "COUNT"(DISTINCT ...)` to:

- Count only those savings plans where:
 "is_regular_savings = 1" AND "amount > 0"

- Count only those investment plans where:
 "is_a_fund = 1" AND "amount > 0"
(This ensures only funded plans are considered)

3. Final Output
-Grouped results by customer (owner_id, name).
Filtered customers using "HAVING" to ensure:
- At least one funded savings plan AND
- At least one funded investment plan
- Calculated the total deposits using "SUM(amount)"
- Sorted results by "total_deposits DESC" to prioritize top customers.