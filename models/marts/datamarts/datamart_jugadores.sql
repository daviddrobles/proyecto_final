with 

stats_jugador as (

    select * from {{ ref('int_stats_jugador') }}

),

stats_equipos as (

    select * from {{ ref('int_stats_equipos') }}

),

final as (

    select
        j.id_jugador as id_jugador,
        j.id_equipo as id_equipo,
        j.nombre as nombre_jugador,
        j.numero_goles as numero_de_goles,
        j.minuto_promedio_gol as minuto_promedio_gol,
        j.numero_mvp as numero_de_mvp,
        (numero_goles / numero_partidos_total) as goles_por_partido

    from stats_jugador j
    join stats_equipos e
    on j.id_equipo = e.id_equipo

)

select * from final