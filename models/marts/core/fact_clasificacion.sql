{{
    config(
        materialized = "table"
    )
}}

with 

equipo as (

    select * from {{ ref('stg_proyecto_final_equipos') }}

),

victorias_equipos as (

    select * from {{ ref('int_victorias_equipos') }}

),

goles_equipos as (

    select * from {{ ref('int_goles_equipos') }}

),

partidos_equipos as (

    select * from {{ ref('int_partidos_equipos') }}

),

final as (

    select 
        e.equipo,
        pe.numero_partidos_total as partidos_jugados,
        ve.victorias_totales as victorias,
        empate,
        (partidos_jugados - victorias - empate) as derrotas,
        ge.goles_totales as goles_a_favor,
        --goles_en_contra,
        --diferencia_goles,
        (ve.victorias_totales*3) + (empate*1) as puntos

    from equipo e
    join victorias_equipos ve
    on e.id_equipo = ve.id_equipo
    join goles_equipos ge
    on e.id_equipo = ge.id_equipo
    join partidos_equipos pe
    on e.id_equipo = pe.id_equipo
    order by puntos DESC

)

select * from final