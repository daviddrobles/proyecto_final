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
        count(r.mvp) as numero_mvp
        
    from jugador j
    join resultados r
    on j.id_jugador = r.mvp
    group by j.id_jugador, j.nombre
    order by numero_mvp DESC
)

select * from final