
-- ==========================================
-- E-Commerce Sales Analysis Portfolio
-- View 02: Valid Sales Items
-- ==========================================

USE ecommerce_portfolio;

CREATE OR REPLACE VIEW vw_valid_sales_items AS

SELECT
    -- Order information
    v.order_id,
    v.customer_id,
    v.order_date,
    v.order_year,
    v.order_month,
    v.order_status,

    -- Sales and shipping information
    v.sales_channel,
    v.shipping_city,
    v.shipping_state,

    -- Product information
    oi.product_id,
    p.category,

    -- Sales details
    oi.quantity,
    oi.unit_price,

    -- Revenue per order item
    (oi.quantity * oi.unit_price) AS line_revenue

FROM vw_valid_sales_orders v

INNER JOIN order_items oi
    ON v.order_id = oi.order_id

INNER JOIN products p
    ON oi.product_id = p.product_id;
