with 

jugador as (

    select * from {{ ref('stg_proyecto_final_jugador') }}

),

eventos as (

    select * from {{ ref('stg_proyecto_final_eventos_partidos') }}
    
),

resultados as (

    select * from {{ ref('stg_proyecto_final_resultados') }}
    
),

goles as (

    select 
        j.id_jugador::varchar(256) as id_jugador,
        j.nombre,
        j.id_equipo,
        count(tipo_evento)::INT as numero_goles,
        avg(minuto) as minuto,
        
    from jugador j
    join eventos e
    on j.id_jugador = e.id_jugador
    group by j.id_jugador, j.nombre, j.id_equipo
    order by numero_goles DESC
),

mvp as (

    select
        id_jugador::varchar(256) as id_jugador,
        id_equipo::varchar(256) as id_equipo,
        nombre,
        numero_goles,
        minuto as minuto_promedio_gol,
        count(mvp) as numero_mvp

    from goles g
    join resultados r
    on g.id_jugador = r.mvp
    group by id_jugador, nombre, numero_goles, minuto, id_equipo

)

select * from mvp