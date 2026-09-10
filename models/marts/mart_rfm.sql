with customer_orders as (

    select
        customer_unique_id,
        order_id,
        date(order_purchase_timestamp) as order_date,
        total_payment_value
    from {{ ref('int_orders_joined') }}
    where customer_unique_id is not null
      and order_status not in ('canceled', 'unavailable')

),

customer_rfm as (

    select
        customer_unique_id,
        date_diff(
            (select max(order_date) from customer_orders),
            max(order_date),
            day
        ) as recency,
        count(distinct order_id) as frequency,
        sum(total_payment_value) as monetary
    from customer_orders
    group by customer_unique_id

)

select
    customer_unique_id,
    recency,
    frequency,
    monetary
from customer_rfm
order by monetary desc