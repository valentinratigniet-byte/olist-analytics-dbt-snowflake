with source as (
    select * from {{ source('olist_raw', 'olist_order_payments') }}
),
renamed as (
    select
        order_id,
        payment_sequential,
        payment_type,
        try_to_number(payment_installments) as payment_installments,
        try_to_number(payment_value) as payment_value
    from source
)
select * from renamed
