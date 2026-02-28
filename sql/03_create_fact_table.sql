-- =============================================================
-- File: 03_create_fact_table.sql
-- Description: Creates and populates the fact_orders table
-- Grain: One row per order-item
--
-- Fact Table:
--   - fact_orders
--
-- Measures:
--   - price
--   - freight_value
--   - payment_value
--
-- Foreign Keys:
--   - customer_key  -> dim_customers
--   - product_key   -> dim_products
--   - seller_key    -> dim_sellers
--   - order_date_key -> dim_date
--
-- Notes:
--   - Surrogate keys used for all dimension references
--   - Data sourced from staging layer
--   - Run after dimension tables are created and populated
-- =============================================================

CREATE TABLE dwh.fact_orders
(
	fact_order_key INT IDENTITY(1,1) PRIMARY KEY,
	order_id VARCHAR(50),
	product_key INT,
	customer_key INT,
	seller_key INT,
	order_date_key INT,
	price DECIMAL(10,2),
	freight_value DECIMAL(10,2),
	payment_value DECIMAL(10,2)
);


TRUNCATE TABLE [dwh].[fact_orders];

INSERT INTO [dwh].[fact_orders](
order_id,
product_key,
customer_key,
seller_key,
order_date_key,
price,
freight_value,
payment_value
)
SELECT 
oi.order_id,
dp.product_key,
dc.customer_key,
ds.seller_key,
CAST(FORMAT(o.order_purchase_timestamp, 'yyyyMMdd') AS INT) AS order_date_key,
oi.price,
oi.freight_value,
ISNULL(payment.total_payment_value, 0)
FROM [staging].[stg_order_items] AS oi
JOIN [staging].[stg_orders] AS o
ON oi.order_id = o.order_id
JOIN [dwh].[dim_customers] AS dc
ON o.customer_id = dc.customer_id
JOIN [dwh].[dim_products] AS dp
ON oi.product_id = dp.product_id
JOIN [dwh].[dim_sellers] AS ds
ON oi.seller_id = ds.seller_id
LEFT JOIN (
SELECT order_id, SUM(payment_value) AS total_payment_value
FROM [staging].[stg_payments]
GROUP BY order_id
) AS payment
ON oi.order_id = payment.order_id;