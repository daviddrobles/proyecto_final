{{
    config(
        materialized = "table"
    )
}}

with 

posicion as (

    select * from {{ ref('stg_proyecto_final_posicion') }}

),

final AS (

    select
        id_posicion,
        posicion
    from posicion
)

select * from final