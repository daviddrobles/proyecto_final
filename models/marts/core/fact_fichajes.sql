{{
    config(
        materialized = "table"
    )
}}

with 

jugador as (

    select * from {{ ref('stg_proyecto_final_jugador') }}

),

final AS (

    select
        id_jugador,
        id_agente,
        id_equipo,
        precio_millones,
        fecha_fichaje_equipo

    from jugador
)

select * from final