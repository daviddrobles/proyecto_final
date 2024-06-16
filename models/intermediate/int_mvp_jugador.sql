with 

jugador as (

    select * from {{ ref('stg_proyecto_final_jugador') }}

),

resultados as (

    select * from {{ ref('stg_proyecto_final_resultados') }}
    
),

final as (

    select 
        j.id_jugador,
        j.nombre,
        count(r.mvp)::INT as numero_mvp,
        j.id_equipo
        
    from jugador j
    join resultados r
    on j.id_jugador = r.mvp
    group by j.id_jugador, j.nombre, j.id_equipo
    order by numero_mvp DESC
)

select * from final