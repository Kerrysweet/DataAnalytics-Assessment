# Account Inactivity Analysis

## Objective
This SQL query identifies all active savings or investment accounts that have had no transactions in the last 365 days. This analysis can help in
- Detecting dormant accounts
- Improve customer engagement
- Comply with regulatory requirements
- Optimize account management

## My Technical Approach

 1. Data Understanding
The solution leverages two key tables:
- plans_plan: Contains account metadata and status
- savings_savingsaccount: Stores transaction history

2. Solution Architecture
The query uses a two-phase approach:

## Phase 1: Establish Baseline
WITH max_transaction_date AS (
  SELECT MAX(transaction_date) AS latest_date FROM savings_savingsaccount
)
- Identifies the most recent transaction date across all accounts
- Serves as the reference point for calculating inactivity periods

## Phase 2: Account Analysis
SELECT 
  p.id AS plan_id,
  p.owner_id,
  CASE 
    WHEN p.is_regular_savings = 1 THEN 'Savings'
    WHEN p.is_a_fund = 1 THEN 'Investment'
    ELSE 'Unknown'
  END AS type,
  MAX(s.transaction_date) AS last_transaction_date,
  DATEDIFF((SELECT latest_date FROM max_transaction_date), MAX(s.transaction_date)) AS inactivity_days
- Classifies account types (Savings/Investment)
- Identifies each account's last transaction date
- Calculates days since last transaction

### 3. Filtering Logic
WHERE 
  (p.is_regular_savings = 1 OR p.is_a_fund = 1)
  AND p.is_deleted = 0
- Includes only savings/investment accounts
- Excludes deleted accounts

### 4. Result 
HAVING 
  last_transaction_date IS NOT NULL
  AND DATEDIFF((SELECT latest_date FROM max_transaction_date), last_transaction_date) > 365
- Ensures accounts have transaction history
- Filters for accounts inactive >365 days