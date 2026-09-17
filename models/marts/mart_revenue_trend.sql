with monthly_orders as (

    select
        date_trunc(date(order_purchase_timestamp), month) as order_month,
        count(distinct order_id) as order_count,
        sum(item_revenue) as revenue

    from {{ ref('int_orders_joined') }}

    where order_status not in ('canceled', 'unavailable')

    group by 1

)

select
    order_month,
    order_count,
    revenue,
    safe_divide(revenue, order_count) as average_order_value

from monthly_orders

order by order_month
