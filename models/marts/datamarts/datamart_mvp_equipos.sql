with 

mvp as (

    select * from {{ ref('int_mvp_jugador') }}

),

equipo as (

    select * from {{ ref('dim_equipos') }}

),

final as (

    select 
        e.id_equipo,
        e.equipo,
        count(NUMERO_MVP) as numero_mvps
    
    from equipo e
    join mvp m
    on e.id_equipo = m.id_equipo
    group by e.id_equipo, e.equipo
    order by numero_mvps DESC
)

select * from final