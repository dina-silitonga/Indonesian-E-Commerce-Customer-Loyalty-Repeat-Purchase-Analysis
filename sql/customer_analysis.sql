
CREATE DATABASE ecommerce_analysis;

USE ecommerce_analysis;


USE ecommerce_analysis;

SELECT DATABASE();



USE ecommerce_analysis;

CREATE TABLE transactions (
    No INT,
    Trx_Date DATE,
    Cust_ID VARCHAR(20),
    Age INT,
    Gender VARCHAR(20),
    AREA VARCHAR(50),
    Product_ID VARCHAR(30),
    Product_Name VARCHAR(150),
    Category VARCHAR(100),
    Amount INT
);



SHOW TABLES;

DESCRIBE transactions;



USE ecommerce_analysis;

SELECT COUNT(*) AS total_data
FROM transactions;


SELECT *
FROM transactions
LIMIT 10;

SELECT
    COUNT(DISTINCT Cust_ID) AS total_unique_customers
FROM transactions;

SELECT
    Gender,
    COUNT(DISTINCT Cust_ID) AS total_customers
FROM transactions
GROUP BY Gender;


SELECT
    Category,
    COUNT(*) AS total_records
FROM transactions
GROUP BY Category
ORDER BY total_records DESC;


# sebelum perbaikan
SELECT
    No,
    Product_ID,
    Product_Name,
    Category
FROM transactions
WHERE Category = 'E';


# perbaikan kategori
UPDATE transactions
SET Category = 'Body Treatment'
WHERE Product_ID = '121314151'
  AND Category = 'E';



SELECT
    No,
    Product_ID,
    Product_Name,
    Category
FROM transactions
WHERE No = 785;


# periksa kategori E
SELECT COUNT(*) AS remaining_E_category
FROM transactions
WHERE Category = 'E';



# Menghitung aktivitas setiap pelanggan

SELECT
    Cust_ID,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY Cust_ID
ORDER BY total_transactions DESC;


# Mengelompokkan pelanggan

SELECT
    CASE
        WHEN transaction_count = 1 THEN 'One-Time Customer'
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

# Menghitung persentasi pelanggan berulang

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


# Aktivitas pelanggan per bulan

SELECT
    DATE_FORMAT(Trx_Date, '%Y-%m') AS month,
    COUNT(*) AS total_records,
    COUNT(DISTINCT Cust_ID) AS unique_customers
FROM transactions
GROUP BY DATE_FORMAT(Trx_Date, '%Y-%m')
ORDER BY month;


# Pelanggan yang aktif di kedua bulan

SELECT
    COUNT(DISTINCT june.Cust_ID) AS june_customers,
    COUNT(DISTINCT july.Cust_ID) AS july_customers,
    COUNT(DISTINCT june.Cust_ID) AS june_total,
    COUNT(DISTINCT july.Cust_ID) AS july_total,
    COUNT(DISTINCT CASE
        WHEN july.Cust_ID IS NOT NULL THEN june.Cust_ID
    END) AS active_in_both_months
FROM transactions june
LEFT JOIN transactions july
    ON june.Cust_ID = july.Cust_ID
    AND DATE_FORMAT(july.Trx_Date, '%Y-%m') = '2022-07'
WHERE DATE_FORMAT(june.Trx_Date, '%Y-%m') = '2022-06';

SELECT
    COUNT(DISTINCT june.Cust_ID) AS june_customers,
    COUNT(DISTINCT july.Cust_ID) AS july_customers,
    COUNT(DISTINCT june.Cust_ID) AS june_total,
    COUNT(DISTINCT july.Cust_ID) AS july_total,
    COUNT(DISTINCT CASE
        WHEN july.Cust_ID IS NOT NULL THEN june.Cust_ID
    END) AS active_in_both_months
FROM transactions june
LEFT JOIN transactions july
    ON june.Cust_ID = july.Cust_ID
    AND DATE_FORMAT(july.Trx_Date, '%Y-%m') = '2022-07'
WHERE DATE_FORMAT(june.Trx_Date, '%Y-%m') = '2022-06';
SELECT
    COUNT(DISTINCT june.Cust_ID) AS june_customers,
    COUNT(DISTINCT july.Cust_ID) AS july_customers,
    COUNT(DISTINCT june.Cust_ID) AS june_total,
    COUNT(DISTINCT july.Cust_ID) AS july_total,
    COUNT(DISTINCT CASE
        WHEN july.Cust_ID IS NOT NULL THEN june.Cust_ID
    END) AS active_in_both_months
FROM transactions june
LEFT JOIN transactions july
    ON june.Cust_ID = july.Cust_ID
    AND DATE_FORMAT(july.Trx_Date, '%Y-%m') = '2022-07'
WHERE DATE_FORMAT(june.Trx_Date, '%Y-%m') = '2022-06';

# pelanggan yang aktifdikedua bulan

SELECT
    COUNT(DISTINCT Cust_ID) AS active_in_both_months
FROM transactions
WHERE Cust_ID IN (
    SELECT Cust_ID
    FROM transactions
    WHERE MONTH(Trx_Date) = 6
)
AND MONTH(Trx_Date) = 7;


#pelanggan juni yang aktif di juli

SELECT
    ROUND(
        COUNT(DISTINCT CASE
            WHEN MONTH(Trx_Date) = 7 THEN Cust_ID
        END) * 100.0 /
        (
            SELECT COUNT(DISTINCT Cust_ID)
            FROM transactions
            WHERE MONTH(Trx_Date) = 6
        ),
        2
    ) AS june_to_july_activity_rate
FROM transactions
WHERE MONTH(Trx_Date) IN (6, 7);


#pemeriksaan 

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

# Analisis jumlah record setiap kategori 

SELECT
    Category,
    COUNT(*) AS total_records
FROM transactions
GROUP BY Category
ORDER BY total_records DESC;


# Menghitung persentasi setiap kategori

SELECT
    Category,
    COUNT(*) AS total_records,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM transactions),
        2
    ) AS percentage
FROM transactions
GROUP BY Category
ORDER BY total_records DESC;

# Menghitung jumlah pelanggan unik perkategori

SELECT
    Category,
    COUNT(DISTINCT Cust_ID) AS unique_customers
FROM transactions
GROUP BY Category
ORDER BY unique_customers DESC;

# Membandingkan aktivitas kategori setiap bulan

SELECT
    Category,
    SUM(CASE
        WHEN MONTH(Trx_Date) = 6 THEN 1
        ELSE 0
    END) AS june_records,
    SUM(CASE
        WHEN MONTH(Trx_Date) = 7 THEN 1
        ELSE 0
    END) AS july_records,
    COUNT(*) AS total_records
FROM transactions
GROUP BY Category
ORDER BY total_records DESC;

#Cohort
# Menentukan bulan pertama pelanggan muncul

SELECT
    DATE_FORMAT(first_activity, '%Y-%m') AS cohort_month,
    COUNT(*) AS total_customers
FROM (
    SELECT
        Cust_ID,
        MIN(Trx_Date) AS first_activity
    FROM transactions
    GROUP BY Cust_ID
) AS customer_first_activity
GROUP BY DATE_FORMAT(first_activity, '%Y-%m')
ORDER BY cohort_month;

# Menghitung pelanggan aktif setiap bulan berd cohort

SELECT
    DATE_FORMAT(first_month, '%Y-%m') AS cohort_month,
    COUNT(DISTINCT Cust_ID) AS cohort_size,
    COUNT(DISTINCT CASE
        WHEN MONTH(Trx_Date) = 6 THEN Cust_ID
    END) AS active_june,
    COUNT(DISTINCT CASE
        WHEN MONTH(Trx_Date) = 7 THEN Cust_ID
    END) AS active_july
FROM (
    SELECT
        Cust_ID,
        MIN(Trx_Date) OVER (
            PARTITION BY Cust_ID
        ) AS first_month,
        Trx_Date
    FROM transactions
) AS cohort_data
GROUP BY first_month
ORDER BY cohort_month;

#Menghitung observade activity rate

SELECT
    COUNT(DISTINCT june.Cust_ID) AS june_cohort,
    COUNT(DISTINCT july.Cust_ID) AS active_again_in_july,
    ROUND(
        COUNT(DISTINCT july.Cust_ID) * 100.0 /
        COUNT(DISTINCT june.Cust_ID),
        2
    ) AS june_to_july_activity_rate
FROM transactions june
INNER JOIN transactions july
    ON june.Cust_ID = july.Cust_ID
WHERE YEAR(june.Trx_Date) = 2022
  AND MONTH(june.Trx_Date) = 6
  AND YEAR(july.Trx_Date) = 2022
  AND MONTH(july.Trx_Date) = 7;


# Koreksi 4.2

SELECT
    DATE_FORMAT(first_month, '%Y-%m') AS cohort_month,
    COUNT(DISTINCT Cust_ID) AS cohort_size,
    COUNT(DISTINCT CASE
        WHEN DATE_FORMAT(Trx_Date, '%Y-%m') = '2022-06'
        THEN Cust_ID
    END) AS active_june,
    COUNT(DISTINCT CASE
        WHEN DATE_FORMAT(Trx_Date, '%Y-%m') = '2022-07'
        THEN Cust_ID
    END) AS active_july
FROM (
    SELECT
        Cust_ID,
        MIN(Trx_Date) OVER (
            PARTITION BY Cust_ID
        ) AS first_month,
        Trx_Date
    FROM transactions
) AS cohort_data
GROUP BY DATE_FORMAT(first_month, '%Y-%m')
ORDER BY cohort_month;


SELECT
    june.june_customers,
    both_months.active_again_in_july,
    ROUND(
        both_months.active_again_in_july * 100.0
        / june.june_customers,
        2
    ) AS june_to_july_activity_rate
FROM (
    SELECT COUNT(DISTINCT Cust_ID) AS june_customers
    FROM transactions
    WHERE Trx_Date >= '2022-06-01'
      AND Trx_Date < '2022-07-01'
) AS june
CROSS JOIN (
    SELECT COUNT(DISTINCT a.Cust_ID) AS active_again_in_july
    FROM transactions a
    WHERE a.Trx_Date >= '2022-06-01'
      AND a.Trx_Date < '2022-07-01'
      AND EXISTS (
          SELECT 1
          FROM transactions b
          WHERE b.Cust_ID = a.Cust_ID
            AND b.Trx_Date >= '2022-07-01'
            AND b.Trx_Date < '2022-08-01'
      )
) AS both_months;



# 5. Selanjutnya: Customer Behavior Analysis
#Menghitung frekkuesni record setiap pelanggan

SELECT
    Cust_ID,
    COUNT(*) AS total_records
FROM transactions
GROUP BY Cust_ID
ORDER BY total_records DESC;


#Mengelompokkan pelanggan berdasarkan frekuensi

SELECT
    CASE
        WHEN total_records BETWEEN 1 AND 2
            THEN 'Low Activity'
        WHEN total_records BETWEEN 3 AND 5
            THEN 'Medium Activity'
        ELSE 'High Activity'
    END AS activity_segment,
    COUNT(*) AS total_customers
FROM (
    SELECT
        Cust_ID,
        COUNT(*) AS total_records
    FROM transactions
    GROUP BY Cust_ID
) AS customer_frequency
GROUP BY activity_segment
ORDER BY total_customers DESC;

# menghitung persentasi setiap segmen

SELECT
    activity_segment,
    total_customers,
    ROUND(
        total_customers * 100.0 /
        SUM(total_customers) OVER (),
        2
    ) AS percentage
FROM (
    SELECT
        CASE
            WHEN total_records BETWEEN 1 AND 2
                THEN 'Low Activity'
            WHEN total_records BETWEEN 3 AND 5
                THEN 'Medium Activity'
            ELSE 'High Activity'
        END AS activity_segment,
        COUNT(*) AS total_customers
    FROM (
        SELECT
            Cust_ID,
            COUNT(*) AS total_records
        FROM transactions
        GROUP BY Cust_ID
    ) AS customer_frequency
    GROUP BY activity_segment
) AS segment_summary
ORDER BY total_customers DESC;


# Melihatstatistik frekuensi pelanggan

SELECT
    COUNT(*) AS total_customers,
    ROUND(AVG(total_records), 2) AS average_records,
    MIN(total_records) AS minimum_records,
    MAX(total_records) AS maximum_records
FROM (
    SELECT
        Cust_ID,
        COUNT(*) AS total_records
    FROM transactions
    GROUP BY Cust_ID
) AS customer_frequency;


#6. Cusumer preferency categoti

SELECT
    Cust_ID,
    COUNT(DISTINCT Category) AS total_categories
FROM transactions
GROUP BY Cust_ID
ORDER BY total_categories DESC;


# Distribusi kategori keragaman pelanggan
SELECT
    total_categories,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(DISTINCT Cust_ID) FROM transactions),
        2
    ) AS percentage
FROM (
    SELECT
        Cust_ID,
        COUNT(DISTINCT Category) AS total_categories
    FROM transactions
    GROUP BY Cust_ID
) AS customer_category
GROUP BY total_categories
ORDER BY total_categories DESC;


# Analisis pelanggan berd wilayah
SELECT
    AREA,
    COUNT(DISTINCT Cust_ID) AS total_customers,
    COUNT(*) AS total_records
FROM transactions
GROUP BY AREA
ORDER BY total_customers DESC;

# ratarata catatan per pelanggan setiap wilayah
SELECT
    AREA,
    COUNT(DISTINCT Cust_ID) AS total_customers,
    COUNT(*) AS total_records,
    ROUND(
        COUNT(*) / COUNT(DISTINCT Cust_ID), 2
    ) AS avg_records_per_customer
FROM transactions
GROUP BY AREA
ORDER BY avg_records_per_customer DESC;

#Analisis demograsi usia pelanggan
SELECT
    CASE
        WHEN Age < 20 THEN 'Under 20'
        WHEN Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60 and above'
    END AS age_group,
    COUNT(DISTINCT Cust_ID) AS total_customers
FROM transactions
GROUP BY age_group
ORDER BY
    CASE age_group
        WHEN 'Under 20' THEN 1
        WHEN '20-29' THEN 2
        WHEN '30-39' THEN 3
        WHEN '40-49' THEN 4
        WHEN '50-59' THEN 5
        ELSE 6
    END;

# analisis gender
SELECT
    Gender,
    COUNT(DISTINCT Cust_ID) AS total_customers,
    COUNT(*) AS total_records,
    ROUND(
        COUNT(*) / COUNT(DISTINCT Cust_ID), 2
    ) AS avg_records_per_customer
FROM transactions
GROUP BY Gender
ORDER BY total_customers DESC;

# Custumer activity
SELECT
    Category,
    COUNT(DISTINCT Cust_ID) AS total_customers,
    COUNT(*) AS total_records,
    ROUND(
        COUNT(*) / COUNT(DISTINCT Cust_ID), 2
    ) AS avg_records_per_customer
FROM transactions
GROUP BY Category
ORDER BY avg_records_per_customer DESC;
