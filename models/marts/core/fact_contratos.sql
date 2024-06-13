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
        id_equipo,
        fecha_fichaje_equipo as fecha_inicio,
        fecha_expiracion_contrato

    from jugador
)

select * from final