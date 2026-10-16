
-- ==========================================
-- E-Commerce Sales Analysis Portfolio
-- View 03: Monthly Sales Analysis
-- ==========================================

USE ecommerce_portfolio;

CREATE OR REPLACE VIEW vw_monthly_sales AS

SELECT
    -- Year and month
    v.order_year,
    v.order_month,

    -- First day of the reporting month
    CAST(
        DATE_FORMAT(
            MIN(v.order_date),
            '%Y-%m-01'
        ) AS DATE
    ) AS month_start,

    -- Number of valid sales orders
    COUNT(*) AS total_orders,

    -- Number of unique customers
    COUNT(DISTINCT v.customer_id) AS total_customers,

    -- Total units sold
    SUM(v.units_sold) AS total_units,

    -- Total valid sales revenue
    ROUND(
        SUM(v.sales_revenue),
        2
    ) AS total_revenue,

    -- Average Order Value (AOV)
    ROUND(
        SUM(v.sales_revenue)
        / NULLIF(COUNT(*), 0),
        2
    ) AS aov

FROM vw_valid_sales_orders v

GROUP BY
    v.order_year,
    v.order_month;
