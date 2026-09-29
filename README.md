# OrderMetrics360

E-commerce Business Analytics using BigQuery, dbt, Python, and Power BI.

## Overview

OrderMetrics360 is an end-to-end e-commerce analytics project built using the Olist Brazilian E-Commerce Public Dataset.

The project transforms raw e-commerce data into business-ready analytical models and dashboards to understand revenue, customer behavior, retention, delivery performance, and customer satisfaction.

## Business Problem

E-commerce businesses need to understand:

- How revenue and order volume change over time
- Which customers are valuable and likely to return
- How delivery performance affects customer satisfaction
- How product categories perform
- Whether customer satisfaction differs across payment methods

OrderMetrics360 addresses these questions using SQL, Python, statistical analysis, dbt, and Power BI.

## Architecture

```text
Olist Raw Dataset
       |
       v
   BigQuery
       |
       v
   dbt Staging
       |
       v
   dbt Intermediate
       |
       v
   dbt Marts
       |
       +------------------+
       |                  |
       v                  v
    Python             Power BI
 Pandas / SciPy       Dashboard
       |
       v
 RFM + Statistical
    Analysis
       |
       v
 Business Insights
## Dataset

Olist Brazilian E-Commerce Public Dataset containing approximately 100K orders across multiple related tables.

Dataset source: Kaggle — Olist Brazilian E-Commerce Public Dataset

## Key Findings

- Delayed deliveries had an average review score of 2.27★, compared with 4.29★ for on-time or early deliveries.
- 96.96% of customers were one-time purchasers, while only 3.04% were repeat customers.
- Customer satisfaction differed slightly across payment methods, with satisfaction rates ranging from 77.45% to 81.25%.
- Statistical tests were used to identify whether observed differences were significant.

## Tech Stack

- BigQuery — Data warehouse and SQL analysis
- dbt — Data transformation, testing, documentation, and data modeling
- Python — Pandas and SciPy for analysis and statistical testing
- Power BI — Interactive dashboards and business reporting
- Git & GitHub — Version control

## Analytical Models

| Model | Purpose |
|---|---|
| mart_rfm | Customer RFM segmentation |
| mart_cohort_retention | Customer retention analysis |
| mart_delivery_reviews | Delivery performance vs review scores |
| mart_revenue_trend | Revenue and order trends |
| mart_category_performance | Category-level business performance |

## Project Structure

```text
OrderMetrics360/
├── models/
│   ├── staging/
│   └── marts/
├── notebooks/
├── data/
├── BUSINESS_MEMO.md
├── OrderMetrics360.pbix
├── README.md
└── dbt_project.yml
