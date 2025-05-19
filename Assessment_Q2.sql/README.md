## What This Solution Does

The SQL query calculates the average monthly activity and group them into clear categories.sorting customers on how frequently they use their accounts.

## How It Works

First, i pull out all transactions from the database, making sure i only look at real transactions within our actual date range (August 2016 through April 2025). Then i:

1. Count how many transactions each customer makes each month
2. Calculate their personal average over all months
3. Put them into one of four groups:
   - High Frequency: 10+ transactions/month (power users)
   - Medium Frequency: 3-9 transactions/month (regular users)
   - Low Frequency: 1-2 transactions/month (occasional users)
   - Zero Transactions: Never made a transaction (inactive accounts)

## Why I Built It This Way

I ran into a few interesting challenges while putting this together:

1. The Zero Transaction 
At first I wasn't sure whether to include completely inactive customers in the "Low Frequency" group or keep them separate. After thinking about it, separating them makes more sense because never using an account is fundamentally different than using it occasionally.

2. Edge Cases  
There were some customers who only transacted for part of a month. The monthly average approach automatically handles these cases fairly - if someone made 3 transactions in their first half-month, that would average out appropriately over time.

## Benefit of The Results

The output gives you three clean columns:
- Frequency category (which group they're in)
- Customer count (how many are in each group)
- Average transactions (the actual number for that group)

You'll see the results ordered from most active to least active customers. The finance team can use this to:
- See what percentage of customers are highly engaged
- Identify opportunities to increase activity among occasional users
- Understand the makeup of the customer base