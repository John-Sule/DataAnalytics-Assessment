-- Use the database
USE adashi_staging;

-- Q1: High-Value Customers with Both Funded Savings and Investment Plans (High-Value Customers with Multiple Products)

SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT s.plan_id) AS savings_count,
    COUNT(DISTINCT p.id) AS investment_count,
    ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits_naira
FROM users_customuser u

-- Join to valid savings transactions
JOIN savings_savingsaccount s 
    ON s.owner_id = u.id
   AND s.confirmed_amount > 0

-- Join to valid investment plans
JOIN plans_plan p 
    ON p.owner_id = u.id
   AND p.is_a_fund = 1 
   AND p.is_regular_savings = 0

-- Apply filters for valid users
WHERE u.first_name IS NOT NULL AND u.first_name != ''
  AND u.last_name IS NOT NULL AND u.last_name != ''

GROUP BY u.id, u.first_name, u.last_name

-- Ensure both savings and investment counts exist
HAVING savings_count > 0 AND investment_count > 0

ORDER BY total_deposits_naira DESC;
