-- =============================================================
-- File: 02_create_dimension_tables.sql
-- Description: Creates and populates dimension tables 
--              for the Data Warehouse (dwh schema)
--              
-- Dimensions Created:
--   - dim_customers
--   - dim_products
--   - dim_sellers
--   - dim_date
--
-- Notes:
--   - Surrogate keys implemented using IDENTITY
--   - Data sourced from staging schema
--   - Run after 01_create_staging_tables.sql
-- =============================================================

CREATE SCHEMA dwh;
GO


-- =============================================
-- Create and Populate Customers Dimension Table.
-- =============================================
CREATE TABLE dwh.dim_customers
(
	customer_key INT IDENTITY(1,1) PRIMARY KEY,
	customer_id VARCHAR(50),
	customer_unique_id VARCHAR(50),
	customer_zip_code_prefix INT,
	customer_city VARCHAR(100),
	customer_state VARCHAR(5)
);

INSERT INTO dwh.dim_customers (
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
)
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM staging.stg_customers;


-- =============================================
-- Create and Populate Date Dimension Table.
-- Derived from staging.stg_orders
-- =============================================
CREATE TABLE dwh.dim_date
(
	date_key INT IDENTITY PRIMARY KEY,
	full_date DATE,
	year INT,
	month INT,
	day INT,
	quarter INT,
	month_name VARCHAR(20)
);

INSERT INTO dwh.dim_date (
    full_date,
    year,
    month,
    day,
    quarter,
    month_name
)
SELECT DISTINCT
    CAST(order_purchase_timestamp AS DATE) AS full_date,
    YEAR(order_purchase_timestamp) AS year,
    MONTH(order_purchase_timestamp) AS month,
    DAY(order_purchase_timestamp) AS day,
    DATEPART(QUARTER, order_purchase_timestamp) AS quarter,
    DATENAME(MONTH, order_purchase_timestamp) AS month_name
FROM staging.stg_orders;

-- =============================================
-- Create and Populate Products Dimension Table.
-- =============================================
CREATE TABLE dwh.dim_products
(
	product_key INT IDENTITY PRIMARY KEY,
	product_id VARCHAR(50),
	product_category_name VARCHAR(100),
	product_name_length INT,
	product_description_length INT,
	product_photos_qty INT,
	product_weight_g INT,
	product_length_cm INT,
	product_height_cm INT,
	product_width_cm INT
);

INSERT INTO dwh.dim_products (
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM staging.stg_products;

-- =============================================
-- Create and Populate Sellers Dimension Table.
-- Derived from staging.stg_orders
-- =============================================
CREATE TABLE dwh.dim_sellers
(
	seller_key INT IDENTITY PRIMARY KEY,
	seller_id VARCHAR(50),
	seller_zip_code_prefix VARCHAR(100),
	seller_city  VARCHAR(100),
	seller_state  VARCHAR(5)
);

INSERT INTO dwh.dim_sellers (
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM staging.stg_sellers;

