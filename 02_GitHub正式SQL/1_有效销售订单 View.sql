-- ==========================================
-- E-Commerce Sales Analysis Portfolio
-- View 01: Valid Sales Orders
-- ==========================================

USE ecommerce_portfolio;

CREATE OR REPLACE VIEW vw_valid_sales_orders AS

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,

    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS order_month,

    o.order_status,
    o.sales_channel,
    o.shipping_city,
    o.shipping_state,

    SUM(oi.quantity) AS units_sold,

    SUM(
        oi.quantity * oi.unit_price
    ) AS sales_revenue

FROM orders o

JOIN order_items oi
    ON o.order_id = oi.order_id

WHERE
    o.order_status IN ('Completed', 'Shipped')

    -- Must have a paid payment
    AND EXISTS (
        SELECT 1
        FROM payments p
        WHERE p.order_id = o.order_id
          AND p.payment_status = 'Paid'
    )

    -- Exclude refunded orders
    AND NOT EXISTS (
        SELECT 1
        FROM payments p
        WHERE p.order_id = o.order_id
          AND p.payment_status = 'Refunded'
    )

GROUP BY
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status,
    o.sales_channel,
    o.shipping_city,
    o.shipping_state;