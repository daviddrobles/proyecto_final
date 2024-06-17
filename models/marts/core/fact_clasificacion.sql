{{
    config(
        materialized = "table"
    )
}}

with 

equipo as (

    select * from {{ ref('stg_proyecto_final_equipos') }}

),

stats_equipos as (

    select * from {{ ref('int_stats_equipos') }}

),

final as (

    select 
        e.equipo,
        s.numero_partidos_total as partidos_jugados,
        s.victorias_totales as victorias,
        empate,
        (partidos_jugados - victorias - empate)::INT as derrotas,
        s.goles_totales as goles_a_favor,
        --goles_en_contra,
        --diferencia_goles,
        (s.victorias_totales*3) + (empate*1) as puntos

    from equipo e
    join stats_equipos s
    on e.id_equipo = s.id_equipo
    order by puntos DESC

)

select * from final