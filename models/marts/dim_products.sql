with items as (select * from {{ ref('int_order_items_joined') }}),
aggregated as (
    select
        product_id,
        max(category_name) as category_name,
        max(weight_g) as weight_g,
        count(*) as number_of_sales,
        sum(total_item_value) as total_revenue,
        avg(item_price) as average_item_price
    from items
    group by 1
)
select * from aggregated
