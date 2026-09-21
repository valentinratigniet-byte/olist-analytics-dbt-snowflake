{{
    config(
        materialized='incremental',
        unique_key='order_item_pk',
        on_schema_change='append_new_columns'
    )
}}

with items as (
    select * from {{ ref('int_order_items_joined') }}
),
orders as (
    select order_id, ordered_at, customer_unique_id, order_status
    from {{ ref('int_orders_enriched') }}
),
final as (
    select
        {{ dbt_utils.generate_surrogate_key(['items.order_id', 'items.order_item_id']) }} as order_item_pk,
        items.order_id,
        items.order_item_id,
        items.product_id,
        items.seller_id,
        orders.customer_unique_id,
        items.category_name,
        items.seller_state,
        orders.order_status,
        orders.ordered_at,
        items.item_price,
        items.freight_value,
        items.total_item_value
    from items
    inner join orders on items.order_id = orders.order_id
)
select * from final
{% if is_incremental() %}
    where ordered_at > (select max(ordered_at) from {{ this }})
{% endif %}
