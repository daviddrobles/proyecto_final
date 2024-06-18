with 

equipos as (

    select * from {{ ref('int_stats_equipos') }}

),

goles as (

    select * from {{ ref('int_goles_en_contra_equipos') }}

),

final as (

    select 
        e.*,
        goles_en_contra_l,
        goles_en_contra_v,
        goles_en_contra
    from equipos e
    join goles g
    on e.id_equipo = g.id_equipo
)

select * from final