-- =============================================================
-- File: 06_customer_cohort_view.sql
-- View Name: dwh.vw_customer_cohort
--
-- Description:
--   Creates cohort-based retention dataset for analytics.
--
-- Logic:
--   1. Identifies each customer's first purchase date.
--   2. Calculates month difference from first purchase (cohort index).
--   3. Aggregates active customers by cohort month and month number.
--
-- Output Columns:
--   - CohortMonth   (First purchase month)
--   - month_number  (Months since acquisition)
--   - Active_Customers (Distinct customers active in that period)
--
-- Grain:
--   One row per CohortMonth per Month_Number.
--
-- Used For:
--   - Tableau retention heatmap
--   - Retention trend analysis
--
-- Execution Order:
--   Run after fact and dimension tables are populated.
-- =============================================================

CREATE OR ALTER VIEW dwh.vw_customer_cohort AS
WITH first_purchase AS
(
SELECT 
dc.customer_unique_id,
MIN(dd.full_date) AS first_purchase_date
FROM [dwh].[fact_orders] AS f
JOIN [dwh].[dim_customers] AS dc
ON f.customer_key = dc.customer_key
JOIN [dwh].[dim_date] AS dd
ON f.order_date_key = dd.date_key
GROUP BY dc.customer_unique_id
),
customer_orders AS
(
SELECT
dc.customer_unique_id,
fp.first_purchase_date,
dd.full_date,
DATEDIFF(MONTH, fp.first_purchase_date, dd.full_date) AS month_number
FROM [dwh].[fact_orders] AS f
JOIN [dwh].[dim_date] AS dd
ON f.order_date_key = dd.date_key
JOIN [dwh].[dim_customers] AS dc
ON f.customer_key = dc.customer_key
JOIN first_purchase AS fp
ON dc.customer_unique_id = fp.customer_unique_id
)
SELECT DATEFROMPARTS(YEAR(first_purchase_date), MONTH(first_purchase_date), 1) AS CohortMonth,
month_number,
COUNT(DISTINCT customer_unique_ID) AS Active_Customers
FROM customer_orders
GROUP BY DATEFROMPARTS(YEAR(first_purchase_date), Month(first_purchase_date), 1), month_number

GO