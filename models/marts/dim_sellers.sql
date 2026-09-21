with items as (select * from {{ ref('int_order_items_joined') }}),
aggregated as (
    select
        seller_id,
        max(seller_city) as seller_city,
        max(seller_state) as seller_state,
        count(*) as number_of_sales,
        sum(total_item_value) as total_revenue
    from items
    group by 1
)
select * from aggregated
