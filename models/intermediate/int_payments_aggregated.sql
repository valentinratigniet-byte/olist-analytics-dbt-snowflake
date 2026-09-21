with payments as (
    select * from {{ ref('stg_olist__order_payments') }}
),
aggregated as (
    select
        order_id,
        sum(payment_value) as total_paid,
        count(*) as number_of_payment_lines,
        max(payment_installments) as max_installments,
        max(payment_type) as payment_type_sample
    from payments
    group by 1
)
select * from aggregated
