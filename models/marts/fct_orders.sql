with orders as (select * from {{ ref('int_orders_enriched') }}),
final as (
    select
        order_id,
        customer_unique_id,
        payment_type,
        customer_state,
        ordered_at,
        delivered_to_customer_at,
        estimated_delivery_at,
        total_paid,
        max_installments,
        delivery_days,
        delivery_vs_estimate_days,
        max_review_score,
        case when delivery_vs_estimate_days >= 0 then true else false end as is_on_time,
        case when order_status = 'delivered' then true else false end as is_delivered
    from orders
)
select * from final
