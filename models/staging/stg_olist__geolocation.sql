with source as (
    select * from {{ source('olist_raw', 'olist_geolocation') }}
),
renamed as (
    select
        geolocation_zip_code_prefix,
        try_to_number(geolocation_lat) as latitude,
        try_to_number(geolocation_lng) as longitude,
        geolocation_city,
        geolocation_state
    from source
)
select * from renamed
