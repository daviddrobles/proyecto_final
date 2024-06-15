{{
    config(
        materialized = "table"
    )
}}

with 

nacionalidad as (

    select * from {{ ref('stg_proyecto_final_nacionalidad') }}

),

final AS (

    select
        id_nacionalidad,
        nacionalidad
    from nacionalidad
)

select * from final