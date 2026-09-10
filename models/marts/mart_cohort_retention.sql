with first_purchase as (

    select
        customer_unique_id,
        date_trunc(date(min(order_purchase_timestamp)), month) as cohort_month
    from {{ ref('int_orders_joined') }}
    where customer_unique_id is not null
    group by customer_unique_id

),

orders_with_cohort as (

    select
        o.customer_unique_id,
        f.cohort_month,
        date_trunc(date(o.order_purchase_timestamp), month) as order_month,
        date_diff(
            date_trunc(date(o.order_purchase_timestamp), month),
            f.cohort_month,
            month
        ) as months_since_first_purchase
    from {{ ref('int_orders_joined') }} o
    join first_purchase f
        on o.customer_unique_id = f.customer_unique_id
    where o.order_purchase_timestamp is not null

)

select
    cohort_month,
    months_since_first_purchase,
    count(distinct customer_unique_id) as active_customers
from orders_with_cohort
group by
    cohort_month,
    months_since_first_purchase
order by
    cohort_month,
    months_since_first_purchase