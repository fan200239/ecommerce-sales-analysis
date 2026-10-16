
-- ==========================================
-- E-Commerce Sales Analysis Portfolio
-- View 05: Dashboard YTD KPI
-- ==========================================

USE ecommerce_portfolio;

CREATE OR REPLACE VIEW vw_dashboard_ytd_kpi AS

-- Step 1: Calculate annual KPIs for Jan-Nov
WITH yearly AS (

    SELECT
        order_year,

        -- Number of valid sales orders
        COUNT(*) AS total_orders,

        -- Number of unique customers
        COUNT(DISTINCT customer_id) AS total_customers,

        -- Total units sold
        SUM(units_sold) AS total_units,

        -- Total valid sales revenue
        SUM(sales_revenue) AS total_revenue

    FROM vw_valid_sales_orders

    WHERE
        order_year IN (2024, 2025)
        AND order_month BETWEEN 1 AND 11

    GROUP BY
        order_year
),

-- Step 2: Retrieve previous-year KPI values
comparison AS (

    SELECT
        order_year,
        total_orders,
        total_customers,
        total_units,
        total_revenue,

        LAG(total_revenue) OVER (
            ORDER BY order_year
        ) AS previous_revenue,

        LAG(total_orders) OVER (
            ORDER BY order_year
        ) AS previous_orders,

        LAG(total_customers) OVER (
            ORDER BY order_year
        ) AS previous_customers,

        LAG(total_units) OVER (
            ORDER BY order_year
        ) AS previous_units

    FROM yearly
)

-- Step 3: Calculate final dashboard metrics
SELECT
    order_year,

    'Jan-Nov' AS comparison_period,

    -- Revenue and operating KPIs
    ROUND(total_revenue, 2) AS total_revenue,

    total_orders,
    total_customers,
    total_units,

    -- Average Order Value (AOV)
    ROUND(
        total_revenue
        / NULLIF(total_orders, 0),
        2
    ) AS aov,

    -- Average selling price per unit
    ROUND(
        total_revenue
        / NULLIF(total_units, 0),
        2
    ) AS avg_selling_price,

    -- Revenue year-over-year growth (%)
    ROUND(
        (total_revenue - previous_revenue)
        / NULLIF(previous_revenue, 0) * 100,
        2
    ) AS revenue_yoy_pct,

    -- Orders year-over-year growth (%)
    ROUND(
        (total_orders - previous_orders)
        / NULLIF(previous_orders, 0) * 100,
        2
    ) AS orders_yoy_pct,

    -- Customers year-over-year growth (%)
    ROUND(
        (total_customers - previous_customers)
        / NULLIF(previous_customers, 0) * 100,
        2
    ) AS customers_yoy_pct,

    -- Units sold year-over-year growth (%)
    ROUND(
        (total_units - previous_units)
        / NULLIF(previous_units, 0) * 100,
        2
    ) AS units_yoy_pct

FROM comparison;
