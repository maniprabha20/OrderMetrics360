with reviews as (

    select
        order_id,
        review_score,
        row_number() over (
            partition by order_id
            order by review_score desc
        ) as review_rank
    from {{ ref('stg_order_reviews') }}

),

delivery_reviews as (

    select
        i.order_id,
        i.customer_unique_id,
        i.order_purchase_timestamp,
        i.order_delivered_customer_date,
        i.order_estimated_delivery_date,
        r.review_score,
        date_diff(
            date(i.order_delivered_customer_date),
            date(i.order_estimated_delivery_date),
            day
        ) as delivery_delay_days

    from {{ ref('int_orders_joined') }} i

    left join reviews r
        on i.order_id = r.order_id
        and r.review_rank = 1

    where i.order_delivered_customer_date is not null
      and i.order_estimated_delivery_date is not null

)

select *
from delivery_reviews