-- =============================================================
-- File: 05_create_performance_indexes.sql
-- Description: Creates non-clustered indexes to optimize
--              analytical query performance.
--
-- Indexed Columns:
--   - fact_orders.order_date_key
--   - fact_orders.customer_key
--   - fact_orders.product_key
--
-- Purpose:
--   - Improve JOIN performance between fact and dimensions
--   - Enhance cohort and retention query speed
--
-- Execution Order:
--   - Run after fact table and constraints are created
-- =============================================================

CREATE INDEX idx_fact_order_date
ON [dwh].[fact_orders](order_date_key)

CREATE INDEX idx_fact_customer
ON [dwh].[dim_customers](customer_key)

CREATE INDEX idx_fact_product
ON [dwh].[dim_products](product_key)
