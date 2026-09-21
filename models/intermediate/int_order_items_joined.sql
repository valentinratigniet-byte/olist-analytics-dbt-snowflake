with items as (select * from {{ ref('stg_olist__order_items') }}),
product as (select * from {{ ref('stg_olist__products') }}),
sellers as (select * from {{ ref('stg_olist__sellers') }}),
translation as (select * from {{ ref('product_category_name_translation') }}),
joined as (
    select
        items.order_id,
        items.product_id,
        items.order_item_id,
        items.seller_id,
        items.item_price,
        items.freight_value,
        items.total_item_value,
        coalesce(translation.product_category_name_english, product.category_name, 'unknown') as category_name,
        product.weight_g,
        sellers.seller_city,
        sellers.seller_state
    from items
    left join product on items.product_id = product.product_id
    left join translation on product.category_name = translation.product_category_name
    left join sellers on items.seller_id = sellers.seller_id
)
select * from joined
