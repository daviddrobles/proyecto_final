with 

equipos as (

    select * from {{ ref('stg_proyecto_final_equipos') }}

),

resultados as (

    select * from {{ ref('stg_proyecto_final_resultados') }}
    
),

goles as (

    select distinct
        e.equipo,
        e.id_equipo,
        sum(goles_local) as goles_locales_total,
        sum(goles_visitante) as goles_visitantes_total

    from equipos e
    join resultados r
    on e.id_equipo = r.id_equipo_local OR e.equipo = r.id_equipo_visitante
    group by e.equipo, e.id_equipo
),

goles_arreglado as (

    select
        equipo,
        id_equipo,
        IFF(equipo = 'Bayern Munich', (goles_locales_total/2), goles_locales_total)::INT as goles_locales_total,
        IFF(equipo = 'Bayern Munich', (goles_locales_total/2), goles_visitantes_total)::INT as goles_visitantes_total
    from goles
),

final as(

    select
        equipo,
        id_equipo,
        goles_locales_total::INT as goles_locales_total,
        goles_visitantes_total::INT as goles_visitantes_total,
        (goles_locales_total + goles_visitantes_total)::INT as goles_totales
    from goles_arreglado
)

select * from final