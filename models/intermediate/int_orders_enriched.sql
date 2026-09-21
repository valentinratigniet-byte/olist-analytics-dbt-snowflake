with orders as (select * from {{ ref('stg_olist__orders') }}),
customers as (select * from {{ ref('stg_olist__customers') }}),
payments as (select * from {{ ref('int_payments_aggregated') }}),
reviews as (
    select order_id, max(review_score) as max_review_score
    from {{ ref('stg_olist__order_reviews') }}
    group by 1
),
enriched as (
    select
        orders.order_id,
        customers.customer_unique_id,
        customers.customer_city,
        customers.customer_state,
        orders.order_status,
        orders.ordered_at,
        orders.approved_at,
        orders.delivered_to_customer_at,
        orders.estimated_delivery_at,
        datediff(day, orders.ordered_at, orders.delivered_to_customer_at) as delivery_days,
        datediff(day, orders.estimated_delivery_at, orders.delivered_to_customer_at) as delivery_vs_estimate_days,
        payments.total_paid,
        payments.max_installments,
        payments.payment_type_sample as payment_type,
        reviews.max_review_score
    from orders
    left join customers on orders.customer_id = customers.customer_id
    left join payments on orders.order_id = payments.order_id
    left join reviews on orders.order_id = reviews.order_id
)
select * from enriched
