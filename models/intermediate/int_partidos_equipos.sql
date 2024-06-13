with 

equipos as (

    select * from {{ ref('stg_proyecto_final_equipos') }}

),

resultados as (

    select * from {{ ref('stg_proyecto_final_resultados') }}
    
),

partidos as (

    select 
        e.equipo as equipo,
        e.id_equipo,
        count(r.id_equipo_local) as numero_partidos_locales,
        count(r.id_equipo_visitante) as numero_partidos_visitantes

    from equipos e
    join resultados r
    on e.id_equipo = r.id_equipo_local OR e.equipo = r.id_equipo_visitante
    group by e.equipo, id_equipo

),

victorias_arreglado as (

    select
        equipo,
        id_equipo,
        IFF(equipo = 'Bayern Munich', (numero_partidos_locales/2), numero_partidos_locales)::INT as numero_partidos_locales,
        IFF(equipo = 'Bayern Munich', (numero_partidos_locales/2), numero_partidos_visitantes)::INT as numero_partidos_visitantes

    from partidos
),

final as (

    select
        equipo,
        id_equipo,
        numero_partidos_locales,
        numero_partidos_visitantes,
        (numero_partidos_locales + numero_partidos_visitantes) as numero_partidos_total

    from victorias_arreglado
)

select * from final