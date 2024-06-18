with 

equipos as (

    select * from {{ ref('stg_proyecto_final_equipos') }}

),

resultados as (

    select * from {{ ref('stg_proyecto_final_resultados') }}
    
),

local as (

        select 
        e.equipo as equipo,
        e.id_equipo as id_equipo,
        sum(goles_local) as goles_en_contra_l

    from equipos e
    join resultados r
    on e.id_equipo = r.id_equipo_visitante
    group by e.equipo, id_equipo

)

-- select * from local

,

visitante as (

    select 
        e.equipo as equipo,
        e.id_equipo as id_equipo,
        sum(goles_visitante) as suma,
        IFF(e.equipo = 'Bayern Munich', (suma/2), suma)::INT as goles_en_contra_v

    from equipos e
    join resultados r
    on e.id_equipo = r.id_equipo_local
    group by e.equipo, id_equipo

)

-- select * from visitante

,

sumas as (

    select
        v.equipo,
        v.id_equipo,
        IFF(v.equipo = 'Bayern Munich', (suma/2), goles_en_contra_l)::INT as goles_en_contra_l,
        goles_en_contra_v

    from local l
    right join visitante v 
    on l.id_equipo = v.id_equipo

),

final as (

    select
        equipo,
        id_equipo,
        goles_en_contra_l,
        goles_en_contra_v,
        (goles_en_contra_l + goles_en_contra_v) as goles_en_contra
    from sumas
)

select * from final