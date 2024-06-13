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
        nombre,
        edad,
        altura,
        id_nacionalidad,
        id_lugar_nacimiento,
        id_posicion,
        numero_camiseta,
        id_pierna_habil,
        id_agente,
        id_sponsor,
        id_equipo

    from jugador
)

select * from final