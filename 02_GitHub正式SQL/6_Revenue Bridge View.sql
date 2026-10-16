
-- ==========================================
-- E-Commerce Sales Analysis Portfolio
-- View 06: Revenue Bridge Analysis
-- ==========================================

USE ecommerce_portfolio;

CREATE OR REPLACE VIEW vw_revenue_bridge AS

-- Step 1: Calculate category-level yearly sales
WITH category_yearly AS (

    SELECT
        category,
        order_year,

        -- Total units sold
        SUM(quantity) AS units_sold,

        -- Total valid sales revenue
        SUM(line_revenue) AS revenue

    FROM vw_valid_sales_items

    WHERE
        order_year IN (2024, 2025)
        AND order_month BETWEEN 1 AND 11

    GROUP BY
        category,
        order_year
),

-- Step 2: Compare 2024 and 2025 by category
comparison AS (

    SELECT
        category,

        SUM(
            CASE
                WHEN order_year = 2024
                THEN units_sold
                ELSE 0
            END
        ) AS units_2024,

        SUM(
            CASE
                WHEN order_year = 2025
                THEN units_sold
                ELSE 0
            END
        ) AS units_2025,

        SUM(
            CASE
                WHEN order_year = 2024
                THEN revenue
                ELSE 0
            END
        ) AS revenue_2024,

        SUM(
            CASE
                WHEN order_year = 2025
                THEN revenue
                ELSE 0
            END
        ) AS revenue_2025

    FROM category_yearly

    GROUP BY category
),

-- Step 3: Calculate revenue and volume effects
effects AS (

    SELECT
        category,
        revenue_2024,
        revenue_2025,

        -- Total revenue change
        revenue_2025 - revenue_2024
            AS revenue_change,

        -- Volume effect based on 2024 category ASP
        (units_2025 - units_2024)
        *
        COALESCE(
            revenue_2024 / NULLIF(units_2024, 0),
            0
        ) AS volume_effect

    FROM comparison
),

-- Step 4: Calculate price/mix effect
-- and append a company-level TOTAL row
bridge AS (

    SELECT
        category,
        0 AS is_total,

        revenue_2024,
        revenue_2025,
        revenue_change,
        volume_effect,

        revenue_change - volume_effect
            AS price_mix_effect

    FROM effects

    UNION ALL

    SELECT
        'TOTAL' AS category,
        1 AS is_total,

        SUM(revenue_2024),
        SUM(revenue_2025),
        SUM(revenue_change),
        SUM(volume_effect),

        SUM(revenue_change - volume_effect)

    FROM effects
)

-- Step 5: Final Revenue Bridge output
SELECT
    category,
    is_total,

    ROUND(revenue_2024, 2)
        AS revenue_2024,

    ROUND(revenue_2025, 2)
        AS revenue_2025,

    ROUND(revenue_change, 2)
        AS revenue_change,

    ROUND(volume_effect, 2)
        AS volume_effect,

    ROUND(price_mix_effect, 2)
        AS price_mix_effect,

    -- Contribution of volume changes (%)
    ROUND(
        volume_effect
        / NULLIF(revenue_change, 0) * 100,
        2
    ) AS volume_contribution_pct,

    -- Contribution of price and product mix (%)
    ROUND(
        price_mix_effect
        / NULLIF(revenue_change, 0) * 100,
        2
    ) AS price_mix_contribution_pct

FROM bridge;
