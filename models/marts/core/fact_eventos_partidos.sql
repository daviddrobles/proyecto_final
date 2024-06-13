{{
    config(
        materialized = "table"
    )
}}

with 

eventos as (

    select * from {{ ref('stg_proyecto_final_eventos_partidos') }}

),

final as (

    select 
        id_evento,
        id_partido,
        id_equipo,
        id_jugador,
        tipo_evento,
        minuto
    from eventos
)

select * from final