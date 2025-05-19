--  QUESTION 4: Customer Lifetime Value (CLV) Estimation

-- Use the database
USE adashi_staging;

-- Aggregate transaction data for each customer (owner_id)
WITH customer_transactions AS (
    SELECT
        p.owner_id,  -- customer ID
        MIN(s.transaction_date) AS first_transaction_date,  -- earliest transaction
        MAX(s.transaction_date) AS last_transaction_date,   -- latest transaction
        COUNT(*) AS total_transactions,                     -- total number of transactions
        SUM(s.confirmed_amount) AS total_deposits           -- total value of deposits (in kobo)
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id  -- link transactions to customers via their plan
    WHERE s.transaction_status = 'success' -- only successful transactions
    GROUP BY p.owner_id
),

-- Calculate lifespan of each customer in months
customer_lifespan AS (
    SELECT
        ct.owner_id,
        ct.total_transactions,
        ct.total_deposits,
        TIMESTAMPDIFF(MONTH, ct.first_transaction_date, ct.last_transaction_date) + 1 AS lifespan_months
        -- lifespan is the difference in months between first and last transaction
    FROM customer_transactions ct
),

-- Calculate CLV and attach customer names
customer_clv AS (
    SELECT
        cl.owner_id,
        COALESCE(u.name, 'N/A') AS name,  -- handle missing names by displaying 'N/A'
        cl.lifespan_months,
        cl.total_transactions,
        ROUND(cl.total_deposits / 100.0, 2) AS total_deposits_naira,  -- convert from kobo to naira
        ROUND((cl.total_deposits / cl.lifespan_months) / 100.0, 2) AS avg_monthly_deposit_naira,
        ROUND(cl.total_deposits / 100.0, 2) AS estimated_clv_naira  -- same as total deposits in naira
    FROM customer_lifespan cl
    JOIN users_customuser u ON cl.owner_id = u.id
    WHERE cl.lifespan_months > 0
)

-- Return final result with top customers by CLV
SELECT
    owner_id AS customer_id,
    name,
    lifespan_months AS tenure_months,
    total_transactions,
    estimated_clv_naira AS estimated_clv
FROM customer_clv
ORDER BY estimated_clv DESC
LIMIT 100;
