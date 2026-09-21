with source as (
    select * from {{ source('olist_raw', 'olist_order_reviews') }}
),
renamed as (
    select
        review_id,
        order_id,
        try_to_number(review_score) as review_score,
        review_comment_title,
        review_comment_message,
        try_to_timestamp_ntz(review_creation_date) as review_created_at,
        try_to_timestamp_ntz(review_answer_timestamp) as review_answered_at
    from source
)
select * from renamed
