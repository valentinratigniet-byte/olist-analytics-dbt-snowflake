with customers as (select * from {{ ref('stg_olist__customers') }}),
customer_orders as (
    select
        customer_unique_id,
        count(order_id) as number_orders,
        sum(total_paid) as lifetime_value,
        min(ordered_at) as first_order_at,
        max(ordered_at) as last_order_at,
        avg(max_review_score) as average_review_score
    from {{ ref('int_orders_enriched') }}
    group by 1
),
final as (
    select
        c.customer_unique_id,
        max(c.customer_state) as customer_state,
        co.number_orders,
        co.lifetime_value,
        co.first_order_at,
        co.last_order_at,
        co.average_review_score,
        case
            when co.number_orders >= 3 then 'loyal'
            when co.number_orders = 2 then 'repeat'
            else 'one_time'
        end as customer_segment
    from customers c
    left join customer_orders co on c.customer_unique_id = co.customer_unique_id
    group by c.customer_unique_id, co.number_orders, co.lifetime_value,
             co.first_order_at, co.last_order_at, co.average_review_score
)
select * from final
