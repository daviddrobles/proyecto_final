{{
    config(
        materialized = "table"
    )
}}

with 

lugar_nacimiento as (

    select * from {{ ref('stg_proyecto_final_lugar_nacimiento') }}

),

final AS (

    select
        id_lugar_nacimiento,
        lugar_nacimiento
    from lugar_nacimiento
)

select * from final