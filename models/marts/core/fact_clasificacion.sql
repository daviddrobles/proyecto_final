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

goles as (

    select * from {{ ref('int_goles_en_contra_equipos') }}

),

tabla as (

    select 
        e.equipo,
        s.numero_partidos_total as partidos_jugados,
        s.victorias_totales as victorias,
        empate,
        (partidos_jugados - victorias - empate)::INT as derrotas,
        s.goles_totales as goles_a_favor,
        goles_en_contra,
        (goles_a_favor - goles_en_contra) as diferencia_goles,
        (s.victorias_totales*3) + (empate*1) as puntos,
        (puntos*100) + (diferencia_goles + victorias + empate - derrotas) as numero

    from equipo e
    join stats_equipos s
    on e.id_equipo = s.id_equipo
    join goles g
    on e.id_equipo = g.id_equipo
    order by numero DESC

)

-- select * from tabla
,

final as (

    select
        RANK () OVER (ORDER BY numero DESC) as puesto,
        equipo,
        puntos,
        partidos_jugados,
        victorias,
        empate,
        derrotas,
        goles_a_favor,
        goles_en_contra,
        diferencia_goles

    from tabla
)

select * from final