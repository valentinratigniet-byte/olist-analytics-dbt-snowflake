with source as (
    select * from {{ source('olist_raw', 'olist_products') }}
),
renamed as (
    select
        product_id,
        product_category_name as category_name,
        try_to_number(product_photos_qty) as photos_qty,
        try_to_number(product_weight_g) as weight_g,
        try_to_number(product_lenght_cm) as length_cm,
        try_to_number(product_height_cm) as height_cm,
        try_to_number(product_width_cm) as width_cm
    from source
)
select * from renamed
