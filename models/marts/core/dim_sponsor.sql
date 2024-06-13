{{
    config(
        materialized = "table"
    )
}}

with 

sponsor as (

    select * from {{ ref('stg_proyecto_final_sponsor') }}

),

final AS (

    select
        id_sponsor,
        sponsor
    from sponsor
)

select * from final