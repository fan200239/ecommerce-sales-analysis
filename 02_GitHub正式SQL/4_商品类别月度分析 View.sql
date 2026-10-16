
-- ==========================================
-- E-Commerce Sales Analysis Portfolio
-- View 04: Category Monthly Sales Analysis
-- ==========================================

USE ecommerce_portfolio;

CREATE OR REPLACE VIEW vw_category_monthly_sales AS

SELECT
    -- Year and month
    v.order_year,
    v.order_month,

    -- First day of the reporting month
    (
        MAKEDATE(v.order_year, 1)
        + INTERVAL (v.order_month - 1) MONTH
    ) AS month_start,

    -- Product category
    v.category,

    -- Number of distinct valid orders
    COUNT(DISTINCT v.order_id) AS category_orders,

    -- Number of distinct customers
    COUNT(DISTINCT v.customer_id) AS category_customers,

    -- Total units sold
    SUM(v.quantity) AS units_sold,

    -- Total valid sales revenue
    ROUND(
        SUM(v.line_revenue),
        2
    ) AS sales_revenue,

    -- Average selling price per unit
    ROUND(
        SUM(v.line_revenue)
        / NULLIF(SUM(v.quantity), 0),
        2
    ) AS avg_selling_price

FROM vw_valid_sales_items v

GROUP BY
    v.order_year,
    v.order_month,
    v.category;
