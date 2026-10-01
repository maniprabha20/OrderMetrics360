import streamlit as st
import pandas as pd
import plotly.express as px
from google.cloud import bigquery

st.set_page_config(
    page_title="OrderMetrics360",
    page_icon="📊",
    layout="wide"
)

# BigQuery connection
client = bigquery.Client.from_service_account_json(
    "/Users/student/Downloads/ordermetrics360-1b2c7e064813.json",
    project="ordermetrics360"
)


@st.cache_data
def load_data(query):
    return client.query(query).to_dataframe()


# --------------------------------------------------
# Page title
# --------------------------------------------------

st.title("OrderMetrics360")
st.caption("E-commerce Business Analytics — BigQuery + dbt + Python + Power BI")


# --------------------------------------------------
# Load Revenue Data
# --------------------------------------------------

revenue_df = load_data("""
    SELECT *
    FROM `ordermetrics360.ordermetrics360.mart_revenue_trend`
    ORDER BY order_month
""")


# --------------------------------------------------
# KPI calculations
# --------------------------------------------------

total_revenue = revenue_df["revenue"].sum()
total_orders = revenue_df["order_count"].sum()

if total_orders > 0:
    avg_order_value = total_revenue / total_orders
else:
    avg_order_value = 0


# --------------------------------------------------
# KPI cards
# --------------------------------------------------

col1, col2, col3 = st.columns(3)

col1.metric(
    "Total Revenue",
    f"₹{total_revenue:,.0f}"
)

col2.metric(
    "Total Orders",
    f"{total_orders:,.0f}"
)

col3.metric(
    "Average Order Value",
    f"₹{avg_order_value:,.2f}"
)


# --------------------------------------------------
# Monthly Revenue Trend
# --------------------------------------------------

st.subheader("Monthly Revenue Trend")

revenue_chart_df = revenue_df.copy()
revenue_chart_df["order_month"] = pd.to_datetime(
    revenue_chart_df["order_month"]
)

fig_revenue = px.line(
    revenue_chart_df,
    x="order_month",
    y="revenue",
    markers=True,
    labels={
        "order_month": "Month",
        "revenue": "Revenue"
    }
)

fig_revenue.update_layout(height=450)

st.plotly_chart(
    fig_revenue,
    use_container_width=True
)


# --------------------------------------------------
# RFM Customer Segmentation
# --------------------------------------------------

st.subheader("RFM Customer Segmentation")

rfm_df = load_data("""
    SELECT *
    FROM `ordermetrics360.ordermetrics360.mart_rfm`
""")


# Calculate RFM scores
rfm_df["R_score"] = pd.qcut(
    rfm_df["recency"],
    4,
    labels=[4, 3, 2, 1],
    duplicates="drop"
).astype(int)

rfm_df["F_score"] = pd.qcut(
    rfm_df["frequency"].rank(method="first"),
    4,
    labels=[1, 2, 3, 4],
    duplicates="drop"
).astype(int)

rfm_df["M_score"] = pd.qcut(
    rfm_df["monetary"].rank(method="first"),
    4,
    labels=[1, 2, 3, 4]
)

rfm_df["M_score"] = rfm_df["M_score"].fillna(1).astype(int)


def assign_segment(row):

    r = row["R_score"]
    f = row["F_score"]
    m = row["M_score"]

    if r >= 4 and f >= 4 and m >= 4:
        return "Champions"

    elif r >= 3 and f >= 3:
        return "Loyal"

    elif r <= 2 and f >= 2:
        return "At Risk"

    elif r <= 2 and f <= 2:
        return "Lost"

    else:
        return "Others"


rfm_df["segment"] = rfm_df.apply(
    assign_segment,
    axis=1
)

segment_counts = (
    rfm_df["segment"]
    .value_counts()
    .reset_index()
)

segment_counts.columns = [
    "segment",
    "customers"
]

fig_rfm = px.bar(
    segment_counts,
    x="segment",
    y="customers",
    labels={
        "segment": "Customer Segment",
        "customers": "Customers"
    }
)

fig_rfm.update_layout(height=400)

st.plotly_chart(
    fig_rfm,
    use_container_width=True
)


# --------------------------------------------------
# Cohort Retention Heatmap
# --------------------------------------------------

st.subheader("Cohort Retention Heatmap")

cohort_df = load_data("""
    SELECT *
    FROM `ordermetrics360.ordermetrics360_marts.mart_cohort_retention`
""")


cohort_pivot = cohort_df.pivot(
    index="cohort_month",
    columns="months_since_first_purchase",
    values="active_customers"
)

cohort_pivot.index = pd.to_datetime(
    cohort_pivot.index
).strftime("%Y-%m")


fig_cohort = px.imshow(
    cohort_pivot,
    labels={
        "x": "Months Since First Purchase",
        "y": "Cohort Month",
        "color": "Active Customers"
    },
    aspect="auto"
)

fig_cohort.update_layout(height=550)

st.plotly_chart(
    fig_cohort,
    use_container_width=True
)


# --------------------------------------------------
# Category Performance
# --------------------------------------------------

st.subheader("Category Performance")

category_df = load_data("""
    SELECT *
    FROM `ordermetrics360.ordermetrics360.mart_category_performance`
""")

category_df = (
    category_df
    .sort_values("revenue", ascending=False)
    .head(10)
)

fig_category = px.bar(
    category_df,
    x="revenue",
    y="product_category",
    orientation="h",
    labels={
        "revenue": "Revenue",
        "product_category": "Category"
    }
)

fig_category.update_layout(
    height=500,
    yaxis={"categoryorder": "total ascending"}
)

st.plotly_chart(
    fig_category,
    use_container_width=True
)


# --------------------------------------------------
# Delivery Delay vs Review Score
# --------------------------------------------------

st.subheader("Delivery Delay vs Review Score")

delivery_df = load_data("""
    SELECT *
    FROM `ordermetrics360.ordermetrics360.mart_delivery_reviews`
""")


delivery_df["on_time"] = (
    delivery_df["delivery_delay_days"] <= 0
)


delivery_df["Delivery Status"] = delivery_df[
    "on_time"
].map({
    True: "On Time / Early",
    False: "Delayed"
})


fig_delivery = px.box(
    delivery_df,
    x="Delivery Status",
    y="review_score",
    labels={
        "Delivery Status": "Delivery Status",
        "review_score": "Review Score"
    }
)

fig_delivery.update_layout(
    height=450
)

st.plotly_chart(
    fig_delivery,
    use_container_width=True
)

st.caption(
    "Mann–Whitney U test: p < 0.001. "
    "Delayed deliveries were associated with lower review scores."
)


# --------------------------------------------------
# Footer
# --------------------------------------------------

st.divider()

st.caption(
    "OrderMetrics360 | BigQuery • dbt • Python • Streamlit • Power BI"
)
