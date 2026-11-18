-- Customer Churn & Retention Analytics
-- SQL Analysis using PostgreSQL


-- 1. Create table

CREATE TABLE customer_churn (
    customerID VARCHAR(20),
    gender VARCHAR(20),
    "SeniorCitizen" INTEGER,
    "Partner" VARCHAR(10),
    "Dependents" VARCHAR(10),
    tenure INTEGER,
    "PhoneService" VARCHAR(10),
    "MultipleLines" VARCHAR(30),
    "InternetService" VARCHAR(30),
    "OnlineSecurity" VARCHAR(30),
    "OnlineBackup" VARCHAR(30),
    "DeviceProtection" VARCHAR(30),
    "TechSupport" VARCHAR(30),
    "StreamingTV" VARCHAR(30),
    "StreamingMovies" VARCHAR(30),
    "Contract" VARCHAR(30),
    "PaperlessBilling" VARCHAR(10),
    "PaymentMethod" VARCHAR(50),
    "MonthlyCharges" NUMERIC(10,2),
    "TotalCharges" NUMERIC(12,2),
    "Churn" VARCHAR(10)
);


-- 2. Check imported data

SELECT *
FROM customer_churn
LIMIT 5;


-- 3. Total customers

SELECT COUNT(*) AS total_customers
FROM customer_churn;


-- 4. Churned vs retained customers

SELECT
    "Churn",
    COUNT(*) AS customer_count
FROM customer_churn
GROUP BY "Churn";


-- 5. Overall churn rate

SELECT
    ROUND(
        100.0 * SUM(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn;


-- 6. Churn by contract

SELECT
    "Contract",
    COUNT(*) AS total_customers,
    SUM(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM customer_churn
GROUP BY "Contract"
ORDER BY churned_customers DESC;


-- 7. Churn rate by contract

SELECT
    "Contract",
    COUNT(*) AS total_customers,
    SUM(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY "Contract"
ORDER BY churn_rate DESC;


-- 8. Churn by payment method

SELECT
    "PaymentMethod",
    COUNT(*) AS total_customers,
    SUM(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY "PaymentMethod"
ORDER BY churn_rate DESC;


-- 9. Churn by tenure group

SELECT
    CASE
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        ELSE '49+ months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY tenure_group
ORDER BY churn_rate DESC;


-- 10. Average monthly charges by churn status

SELECT
    "Churn",
    COUNT(*) AS customer_count,
    ROUND(AVG("MonthlyCharges"), 2) AS avg_monthly_charges
FROM customer_churn
GROUP BY "Churn"
ORDER BY avg_monthly_charges DESC;


-- 11. Identify high-risk churned customers

SELECT
    customerID,
    "Contract",
    tenure,
    "MonthlyCharges",
    "PaymentMethod",
    "Churn"
FROM customer_churn
WHERE "Contract" = 'Month-to-month'
  AND tenure <= 12
  AND "MonthlyCharges" > 70
  AND "Churn" = 'Yes'
ORDER BY "MonthlyCharges" DESC;