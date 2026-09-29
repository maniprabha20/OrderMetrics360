# OrderMetrics360 — Business Insights Memo

## Executive Summary

OrderMetrics360 analyzes Brazilian e-commerce data across orders, customers, payments, deliveries, products, and reviews to identify key business opportunities. The analysis found a strong relationship between delivery timeliness and customer satisfaction, with delayed deliveries receiving substantially lower review scores. RFM analysis also revealed that most customers made only one purchase, highlighting a major customer-retention opportunity. Payment methods showed statistically detectable differences in satisfaction, although the differences were relatively small.

---

## Finding 1 — Delivery Delay & Customer Satisfaction

**Finding:** Delayed deliveries received a lower average review score (**2.27★**) compared with on-time or early deliveries (**4.29★**).

**Evidence:** A Mann–Whitney U test found a statistically significant difference in review scores between the two groups (**U = 467,423,734.5, p < 0.001**). This result indicates an association between delivery timeliness and review scores; it does not by itself prove that delivery delays cause lower ratings.

**Recommendation:** Prioritize delivery SLA improvements for sellers or routes with frequent delays and monitor customer review scores after improvements.

---

## Finding 2 — Customer Retention Opportunity

**Finding:** **96.96% of customers were one-time purchasers**, while only **3.04% were repeat customers**.

**Evidence:** RFM analysis of **94,989 scored customers** identified **92,102 one-time customers** and **2,888 repeat customers**.

**Recommendation:** Develop targeted retention campaigns for at-risk and high-value customers to encourage repeat purchases and increase customer lifetime value.

---

## Finding 3 — Payment Method & Customer Satisfaction

**Finding:** Customer satisfaction varied across payment methods, ranging from **77.45% to 81.25%**.

**Evidence:** A chi-square test found a statistically detectable association between payment method and satisfaction (**χ² = 8.96, p = 0.0298, df = 3**). However, the differences were relatively small, and the test does not establish causation.

**Recommendation:** Monitor payment-specific customer experience and investigate lower-satisfaction payment methods, while continuing to prioritize larger customer-experience drivers such as delivery performance.

---

## Supporting Analysis

The Power BI dashboard also includes a **Revenue vs Customer Satisfaction by Category** scatter analysis. This analysis helps explore how product-category revenue relates to average customer review scores and provides an additional view for category-level business investigation.

---

## Tools & Methods

- **SQL / BigQuery** — data querying and warehouse analysis
- **dbt** — staging, transformation, testing, and data modeling
- **Python / Pandas / SciPy** — RFM analysis and statistical hypothesis testing
- **Power BI / DAX** — interactive dashboard and business metrics
- **Excel / WPS** — stakeholder summary workbook
- **Git / GitHub / Git LFS** — version control and project documentation

---

## Business Takeaways

1. Delivery performance is strongly associated with customer satisfaction and should be monitored as a key customer-experience metric.
2. The very high proportion of one-time customers indicates a significant retention opportunity.
3. Payment-method satisfaction differences exist, but their relatively small range suggests they should be monitored alongside larger customer-experience factors.

---

*Project: OrderMetrics360 — Brazilian E-Commerce Analytics*
