-- Use the database
USE adashi_staging;

-- Q3: Identify inactive plans (no deposits in the past 365 days) - Account Inactivity Alert

SELECT
    p.id AS plan_id,                                -- Unique ID of the plan
    p.owner_id,                                     -- Customer (owner) ID
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'       -- Label as 'Savings' if regular savings plan
        WHEN p.is_a_fund = 1 THEN 'Investment'             -- Label as 'Investment' if a fund
        ELSE 'Other'                                       -- Label as 'Other' if neither
    END AS type,
    MAX(s.transaction_date) AS last_transaction_date,      -- Most recent deposit date
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days -- Days since last deposit

FROM plans_plan p

JOIN savings_savingsaccount s
    ON p.id = s.plan_id                                   -- Match transactions to plans
    AND s.confirmed_amount > 0                            -- Only include successful deposits
    AND s.transaction_date IS NOT NULL                    -- Ensure transaction date exists

WHERE
    p.owner_id IS NOT NULL                                -- Only include plans with valid owner
    AND (
        (p.is_regular_savings = 1 AND p.is_a_fund = 0) OR -- Filter for Savings plans only
        (p.is_regular_savings = 0 AND p.is_a_fund = 1)    -- OR Investment plans only
    )

GROUP BY p.id, p.owner_id, type

HAVING DATEDIFF(CURDATE(), MAX(s.transaction_date)) > 365 -- Only plans inactive for > 1 year

ORDER BY inactivity_days DESC;                            -- Sort by most inactive
