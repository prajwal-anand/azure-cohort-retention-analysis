-- =============================================
-- File: 04_dimension_constraints.sql
-- Description: Adds foreign key constraints 
--              between fact_orders and dimension tables
-- Layer: Data Warehouse (Integrity Enforcement)
-- =============================================

-- Foreign Key : customer_key
ALTER TABLE [dwh].[fact_orders]
ADD CONSTRAINT FK_fact_orders_customers
FOREIGN KEY (customer_key)
REFERENCES [dwh].[dim_customers](customer_key);

-- Foreign Key : product_key
ALTER TABLE [dwh].[fact_orders]
ADD CONSTRAINT FK_fact_orders_products
FOREIGN KEY (product_key)
REFERENCES [dwh].[dim_products](product_key)

-- Foreign Key : seller_key
ALTER TABLE [dwh].[fact_orders]
ADD CONSTRAINT FK_fact_orders_seller
FOREIGN KEY (seller_key)
REFERENCES [dwh].[dim_sellers](seller_key)

-- Foreign Key : order_date_key
ALTER TABLE [dwh].[fact_orders]
ADD CONSTRAINT FK_fact_orders_date
FOREIGN KEY (order_date_key)
REFERENCES [dwh].[dim_date](date_key)
