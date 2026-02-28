-- =============================================
-- 01_create_staging_tables.sql
-- Description: Creates raw staging tables for Olist dataset
-- Layer: Staging
-- =============================================

CREATE SCHEMA staging;
GO

-- CATEGORY_TRANSLATION STAGING TABLE
CREATE TABLE staging.stg_category_translation
(
	product_category_name VARCHAR(100),
	product_category_name_english VARCHAR(100)
);

-- CUSTOMERS STAGING TABLE
CREATE TABLE staging.stg_customers
(
	customer_id VARCHAR(50),
	customer_unique_id VARCHAR(50),
	customer_zip_code_prefix INT,
	customer_city VARCHAR(100),
	customer_state VARCHAR(5)
);

-- ORDERS STAGING TABLE
CREATE TABLE staging.stg_orders
(
	order_id VARCHAR(50),
	customer_id VARCHAR(50),
	order_status VARCHAR(20),
	order_purchase_timestamp DATETIME2,
	order_approved_at DATETIME2,
	order_delivered_carrier_date DATETIME2,
	order_delivered_customer_date DATETIME2,
	order_estimated_delivery_date DATETIME2 
);

-- ORDER_ITEMS STAGING TABLE
CREATE TABLE staging.stg_order_items
(
	order_id VARCHAR(50),
	order_item_id INT,
	product_id VARCHAR(50),
	seller_id VARCHAR(50),
	shipping_limit_date DATETIME2,
	price DECIMAL(10,2),
	freight_value DECIMAL(10,2) 
);

-- PAYMENTS STAGING TABLE
CREATE TABLE staging.stg_payments
(
	order_id VARCHAR(50),
	payment_sequential INT,
	payment_type VARCHAR(50),
	payment_installments INT,
	payment_value DECIMAL(10,2)
);

-- PRODUCTS STAGING TABLE
CREATE TABLE staging.stg_products
(
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

-- SELLERS STAGING TABLE
CREATE TABLE staging.stg_sellers
(
	seller_id VARCHAR(50),
	seller_zip_code_prefix VARCHAR(100),
	seller_city  VARCHAR(100),
	seller_state  VARCHAR(5)
);



