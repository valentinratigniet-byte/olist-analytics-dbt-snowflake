with source as (
    select * from {{ source('olist_raw', 'olist_order_items') }}
),
renamed as (
    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        try_to_timestamp_ntz(shipping_limit_date) as shipping_limit_at,
        try_to_number(price) as item_price,
        try_to_number(freight_value) as freight_value,
        try_to_number(price) + try_to_number(freight_value) as total_item_value
    from source
)
select * from renamed
