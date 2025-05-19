-- Use the database
USE adashi_staging;

-- Q2: Transaction Frequency Category Per Customer (Transaction Frequency Analysis)

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(transactions_per_month), 1) AS avg_transactions_per_month
FROM (
    -- Subquery: Calculate the monthly transaction rate and categorize frequency
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        COUNT(s.id) / TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) AS transactions_per_month,

        -- Frequency categorization based on monthly transaction count
        CASE 
            WHEN COUNT(s.id) / TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) >= 10 THEN 'High Frequency'
            WHEN COUNT(s.id) / TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category

    FROM users_customuser u
    JOIN savings_savingsaccount s 
        ON u.id = s.owner_id
        AND s.confirmed_amount > 0
        AND s.transaction_date IS NOT NULL

    -- Filter to ensure names are available
    WHERE u.first_name IS NOT NULL AND u.first_name != ''
      AND u.last_name IS NOT NULL AND u.last_name != ''

    -- Group transactions by customer
    GROUP BY u.id, u.first_name, u.last_name

    -- Ensure customers have activity span over at least 1 month
    HAVING TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) > 0
) AS frequency_summary

-- Aggregate result by frequency category
GROUP BY frequency_category;
