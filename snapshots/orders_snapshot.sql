{% snapshot orders_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='order_id',
        strategy='check',
        check_cols=['order_status']
    )
}}

select
    order_id,
    customer_id,
    order_status,
    ordered_at,
    approved_at,
    delivered_to_customer_at
from {{ ref('stg_olist__orders') }}

{% endsnapshot %}
