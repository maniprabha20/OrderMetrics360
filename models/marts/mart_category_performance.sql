with item_categories as (

    select
        oi.order_id,
        oi.product_id,
        oi.price,
        coalesce(
            t.product_category_name_english,
            p.product_category_name,
            'unknown'
        ) as product_category
    from {{ ref('stg_order_items') }} oi
    left join {{ ref('stg_products') }} p
        on oi.product_id = p.product_id
    left join {{ ref('stg_product_category_translation') }} t
        on p.product_category_name = t.product_category_name

),

category_revenue as (

    select
        product_category,
        count(distinct order_id) as order_count,
        sum(price) as revenue
    from item_categories
    group by product_category

),

order_review_scores as (

    select
        order_id,
        avg(review_score) as review_score
    from {{ ref('stg_order_reviews') }}
    group by order_id

),

category_orders as (

    select distinct
        order_id,
        product_category
    from item_categories

),

category_reviews as (

    select
        co.product_category,
        avg(ors.review_score) as average_review_score
    from category_orders co
    left join order_review_scores ors
        on co.order_id = ors.order_id
    group by co.product_category

)

select
    cr.product_category,
    cr.order_count,
    cr.revenue,
    cv.average_review_score
from category_revenue cr
left join category_reviews cv
    on cr.product_category = cv.product_category
order by cr.revenue desc
