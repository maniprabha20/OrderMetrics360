with category_performance as (

    select
        coalesce(
            t.product_category_name_english,
            p.product_category_name,
            'unknown'
        ) as product_category,
        count(distinct i.order_id) as order_count,
        sum(i.item_revenue) as revenue,
        avg(r.review_score) as average_review_score
    from {{ ref('int_orders_joined') }} i
    left join {{ ref('stg_order_items') }} oi
        on i.order_id = oi.order_id
    left join {{ ref('stg_products') }} p
        on oi.product_id = p.product_id
    left join {{ ref('stg_product_category_translation') }} t
        on p.product_category_name = t.product_category_name
    left join {{ ref('stg_order_reviews') }} r
        on i.order_id = r.order_id
    group by 1

)

select
    product_category,
    order_count,
    revenue,
    average_review_score
from category_performance
order by revenue desc