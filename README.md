# E-Commerce Sales Analysis | SQL + Power BI

## Project Overview

This project analyzes e-commerce sales performance using **MySQL 8.0 and Microsoft Power BI**.

The main objective is to investigate why sales revenue declined in 2025 compared with 2024, identify the product categories contributing to the decline, and distinguish the effects of sales volume from changes in average selling prices and product mix.

The analysis uses **synthetic e-commerce data** and focuses on valid paid sales from January through November of both years.

## Tools & Technologies

- **MySQL 8.0:** Data cleaning, joins, aggregations, CTEs, window functions, SQL Views, and revenue decomposition.
- **MySQL Workbench:** Query development and data validation.
- **Power BI:** Data modeling, KPI cards, trend analysis, category comparisons, and waterfall visualization.
- **DAX:** Supporting calculations and Revenue Bridge visualization.
- **GitHub:** Project documentation and portfolio presentation.

## Dataset

The synthetic dataset consists of five source tables:

| Table | Records | Description |
|---|---:|---|
| customers | 500 | Customer information |
| products | 100 | Product details and categories |
| orders | 2,000 | Order information |
| order_items | 5,000 | Product-level order details |
| payments | 2,000 | Payment transactions |

Valid sales are defined as orders with a `Completed` or `Shipped` status, at least one `Paid` payment record, and no `Refunded` payment record.

## Key Business Findings

### 1. Revenue declined by 48.24%

| KPI | Jan–Nov 2024 | Jan–Nov 2025 |
|---|---:|---:|
| Revenue | 604,750.19 | 313,019.62 |
| Orders | 520 | 274 |
| Customers | 211 | 144 |
| Units Sold | 2,631 | 1,408 |
| Average Order Value | 1,162.98 | 1,142.41 |

Revenue declined by **291,730.57**, representing a **48.24% year-over-year decrease**.

### 2. Sales volume was the dominant contributor

A category-level Revenue Bridge decomposes the revenue decline into:

| Component | Revenue Impact | Contribution |
|---|---:|---:|
| Volume Effect | -278,705.54 | 95.54% |
| Price/Mix Effect | -13,025.03 | 4.46% |
| Total Change | -291,730.57 | 100.00% |

Under this decomposition, changes in sales volume explain most of the observed revenue decline.

The price/mix component reflects changes in category-level average selling prices, including potential changes in product composition. These results are descriptive and do not establish causality.

### 3. All product categories experienced revenue declines

Electronics recorded the largest absolute revenue decline, followed by Sports, Beauty, Home, and Fashion.

The category comparison demonstrates that the decline was distributed across multiple product categories rather than being limited to one category.

## Power BI Dashboard

The interactive dashboard includes:

1. **KPI Cards:** Revenue, Orders, Customers, and Revenue YoY.
2. **Monthly Revenue Trend:** A comparison of 2024 and 2025 monthly revenue.
3. **Revenue by Product Category:** Sales comparisons across five categories.
4. **Revenue Bridge:** A waterfall visualization showing volume and price/mix effects.
5. **Key Business Insights:** A summary of the most important findings.

### Dashboard Preview

![E-Commerce Sales Dashboard](04_分析成果截图/Ecommerce_Dashboard_Overview.png)

## SQL Analysis Workflow

The analysis uses six SQL Views in the following dependency order:

| Order | SQL View | Purpose |
|---|---|---|
| 1 | vw_valid_sales_orders | Identify valid sales orders |
| 2 | vw_valid_sales_items | Create product-level sales records |
| 3 | vw_monthly_sales | Aggregate monthly performance |
| 4 | vw_category_monthly_sales | Analyze category-level performance |
| 5 | vw_dashboard_ytd_kpi | Calculate YTD KPIs and YoY metrics |
| 6 | vw_revenue_bridge | Decompose revenue changes |

The project demonstrates practical use of SQL joins, `EXISTS`, `NOT EXISTS`, `GROUP BY`, conditional aggregation, CTEs, and `LAG()` window functions.

## How to Reproduce

1. Install MySQL 8.0 or a compatible version.
2. Create the `ecommerce_portfolio` database.
3. Import the provided synthetic dataset, including its source table structure and data.
4. Execute the six SQL View scripts in the dependency order shown above.
5. Validate the resulting KPIs against the documented benchmarks.
6. Open the Power BI `.pbix` file and configure the local MySQL connection as needed.

**Validation note:** The original SQL Views and Power BI results have been cross-checked. The reformatted GitHub SQL scripts still require a complete independent execution test before reproducibility can be considered fully verified.

## Project Scope and Limitations

- The dataset is synthetic and does not represent a real e-commerce company.
- The year-over-year comparison covers January through November.
- Only valid paid, non-refunded orders are included.
- The Revenue Bridge provides an accounting decomposition, not proof of the underlying causes of revenue changes.
- The project focuses on descriptive sales analytics and business intelligence reporting.

## Project Outcome

This project demonstrates an end-to-end analytics workflow, from relational data processing and SQL validation to Power BI visualization and business interpretation.

**Skills demonstrated:** SQL, MySQL, data cleaning, data validation, business metrics, revenue analysis, Power BI, DAX, dashboard design, and analytical storytelling.
