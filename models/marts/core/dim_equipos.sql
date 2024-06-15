{{
    config(
        materialized = "table"
    )
}}

with 

equipo as (

    select * from {{ ref('stg_proyecto_final_equipos') }}

),

final AS (

    select
        id_equipo,
        equipo
    from equipo
)

select * from final