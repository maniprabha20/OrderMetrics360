with

orders as (

    select
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        order_estimated_delivery_date
    from {{ ref('stg_orders') }}

),

order_items as (

    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date,
        price,
        freight_value
    from {{ ref('stg_order_items') }}

),

payments as (

    select
        order_id,
        payment_type,
        payment_installments,
        payment_value
    from {{ ref('stg_order_payments') }}

),

customers as (

    select
        customer_id,
        customer_unique_id,
        customer_city,
        customer_state
    from {{ ref('stg_customers') }}

),

order_values as (

    select
        order_id,
        sum(price) as item_revenue,
        sum(freight_value) as freight_revenue
    from order_items
    group by order_id

),

payment_values as (

    select
        order_id,
        sum(payment_value) as total_payment_value
    from payments
    group by order_id

),

joined as (

    select
        orders.order_id,
        orders.customer_id,
        customers.customer_unique_id,
        customers.customer_city,
        customers.customer_state,

        orders.order_status,
        orders.order_purchase_timestamp,
        orders.order_approved_at,
        orders.order_delivered_carrier_date,
        orders.order_delivered_customer_date,
        orders.order_estimated_delivery_date,

        order_values.item_revenue,
        order_values.freight_revenue,
        payment_values.total_payment_value

    from orders

    left join customers
        on orders.customer_id = customers.customer_id

    left join order_values
        on orders.order_id = order_values.order_id

    left join payment_values
        on orders.order_id = payment_values.order_id

)

select * from joined