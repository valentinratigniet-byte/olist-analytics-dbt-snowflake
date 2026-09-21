-- une commande ne peut être livrée avant qu'elle n'ait été passée
select
    order_id,
    ordered_at,
    delivered_to_customer_at
from {{ ref('fct_orders') }}
where delivered_to_customer_at < ordered_at
