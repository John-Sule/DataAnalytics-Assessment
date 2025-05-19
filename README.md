# Data Analyst SQL Assessment

This project is a technical assessment focused on evaluating core SQL proficiency for solving practical business problems using relational data. The data spans multiple customer-related tables, including user information, savings transactions, investment plans, and withdrawals. The objective was to craft optimal SQL solutions to support departments like marketing, operations, and finance in making data-driven decisions.

## Objective

The primary aim of the assessment was to demonstrate the ability to:

- Extract and transform relevant information from transactional tables
- Write clear, efficient, and logically sound SQL queries
- Derive business insights such as customer behavior, value segmentation, and plan performance
- Communicate the analytical process effectively

The entire process was implemented in **MySQL**, and four core questions formed the basis of this analysis. Each query was submitted as a standalone `.sql` file, with supporting commentary inline for clarity.

---

## Initial Data Preparation

Before diving into the core questions, it was necessary to **filter and clean the data**. Although this wasn't part of the final deliverables (and thus not uploaded to the repository), it played a crucial role in ensuring the quality of insights generated. This step involved:

- Verifying referential integrity (e.g., matching `owner_id` in `plans_plan` to `id` in `users_customuser`)
- Ensuring `confirmed_amount` and `transaction_date` fields were not null and relevant
- Eliminating blank or null `first_name` and `last_name` fields in user records to maintain reliable identifiers
- Understanding which plans qualified as savings (`is_regular_savings = 1`) or investments (`is_a_fund = 1`)

This pre-processing provided a solid foundation for answering the four core questions.

---

## Question 1: High-Value Customers with Multiple Products

This query identified users who had both **funded savings and funded investment plans**. The intent was to spotlight cross-sell opportunities, where customers demonstrated diversified engagement. We filtered savings by non-zero deposits and investment plans by correct plan flags, then joined this data with user profiles. Grouping by user ID allowed us to count their product ownership and aggregate their total deposits.

**Approach Highlights:**

- Filtering only users with both product types
- Ensuring deposits were successfully made
- Sorting by the highest total deposit in Naira for prioritization

---

## Question 2: Transaction Frequency Analysis

This question tackled customer segmentation based on **how frequently they transacted**. We computed the average transactions per month for each user, then bucketed them into frequency bands: High (≥10), Medium (3–9), and Low (≤2).

**Approach Highlights:**

- Calculating each user's transaction rate using `COUNT/months active`
- Categorizing users accordingly with a `CASE` statement
- Ensuring only valid names and confirmed transactions were considered

This segmentation would enable personalized marketing or retention strategies based on usage behavior.

---

## Question 3: Account Inactivity Detection

Operations needed to detect **plans with no inflows in the past 365 days**, as these might indicate churn or neglect. This query focused on both savings and investment plans, checking their latest transaction date and computing inactivity periods.

**Approach Highlights:**

- Joining `plans_plan` with `savings_savingsaccount` and filtering confirmed inflows
- Using `DATEDIFF` to compute inactivity duration
- Filtering results with inactivity longer than 365 days

The result was a list of stale accounts needing re-engagement or review.

---

## Question 4: Customer Lifetime Value (CLV) Estimation

Marketing required an estimation of CLV using a simplified model based on **average monthly deposit volume** over a customer's tenure. We considered total confirmed deposits and their duration of activity in months, converting kobo to naira.

**Approach Highlights:**

- Calculating `lifespan_months` between the first and last transaction
- Computing average monthly deposits
- Presenting estimated CLV in Naira
- Handling missing names with `COALESCE`, though most records appeared valid upon investigation

The output served to identify high-value customers and shape retention investment.

---

## Challenges Encountered

Several challenges emerged during the process:
- **MySQL vs PostgreSQL**: Preferring PostgreSQL for SQL operations, as a data scientist, but facing adaptation challenges and pressed for time, I completed the MySQL-based project using MySQL Workbench
- **Missing Values:** A few records had missing names, which required `COALESCE` as a safety fallback.
- **Data Volume and Format:** Converting monetary values in kobo accurately to naira requires consistency in calculations and rounding.
- **ID Matching**: Extra attention was given to ensure all foreign key relations (e.g., `owner_id`, `plan_id`) aligned properly during joins, avoiding duplicate rows or data mismatches.

Despite these, each obstacle was resolved through iterative debugging and validation.

---

## Final Thoughts

This assessment offered a valuable opportunity to showcase technical SQL skills alongside business thinking. Each query was crafted not just to retrieve data but to answer a real business question efficiently and meaningfully. The additional effort in data filtering, formatting, and explanation was taken to ensure clarity, accuracy, and alignment with real-world analytical workflows.
