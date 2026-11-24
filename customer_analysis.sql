
-- ==========================================
-- PROJECT: Indonesian E-Commerce Customer Analysis
-- PURPOSE: Customer Behavior & Activity Analysis
-- DATABASE: ecommerce_analysis
-- ==========================================

USE ecommerce_analysis;


-- 1. Total Unique Customers
SELECT
    COUNT(DISTINCT Cust_ID) AS total_unique_customers
FROM transactions;


-- 2. Customer Distribution by Gender
SELECT
    Gender,
    COUNT(DISTINCT Cust_ID) AS total_customers
FROM transactions
GROUP BY Gender;


-- 3. Transaction Records by Product Category
SELECT
    Category,
    COUNT(*) AS total_records
FROM transactions
GROUP BY Category
ORDER BY total_records DESC;


-- 4. Customer Classification
SELECT
    CASE
        WHEN transaction_count = 1
            THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS total_customers
FROM (
    SELECT
        Cust_ID,
        COUNT(*) AS transaction_count
    FROM transactions
    GROUP BY Cust_ID
) AS customer_summary
GROUP BY customer_type;


-- 5. Repeat Customer Percentage
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN transaction_count = 1 THEN 1 ELSE 0 END)
        AS one_time_customers,
    SUM(CASE WHEN transaction_count > 1 THEN 1 ELSE 0 END)
        AS repeat_customers,
    ROUND(
        SUM(CASE WHEN transaction_count > 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        Cust_ID,
        COUNT(*) AS transaction_count
    FROM transactions
    GROUP BY Cust_ID
) AS customer_summary;


-- 6. Monthly Customer Activity
SELECT
    DATE_FORMAT(Trx_Date, '%Y-%m') AS month,
    COUNT(*) AS total_records,
    COUNT(DISTINCT Cust_ID) AS unique_customers
FROM transactions
GROUP BY DATE_FORMAT(Trx_Date, '%Y-%m')
ORDER BY month;


-- 7. June-to-July Customer Activity
SELECT
    june.june_customers,
    july.july_customers,
    both_months.active_in_both_months,
    ROUND(
        both_months.active_in_both_months * 100.0
        / june.june_customers, 2
    ) AS june_to_july_activity_rate
FROM
    (
        SELECT COUNT(DISTINCT Cust_ID) AS june_customers
        FROM transactions
        WHERE MONTH(Trx_Date) = 6
          AND YEAR(Trx_Date) = 2022
    ) june
CROSS JOIN
    (
        SELECT COUNT(DISTINCT Cust_ID) AS july_customers
        FROM transactions
        WHERE MONTH(Trx_Date) = 7
          AND YEAR(Trx_Date) = 2022
    ) july
CROSS JOIN
    (
        SELECT COUNT(DISTINCT a.Cust_ID) AS active_in_both_months
        FROM transactions a
        INNER JOIN transactions b
            ON a.Cust_ID = b.Cust_ID
        WHERE MONTH(a.Trx_Date) = 6
          AND YEAR(a.Trx_Date) = 2022
          AND MONTH(b.Trx_Date) = 7
          AND YEAR(b.Trx_Date) = 2022
    ) both_months;
