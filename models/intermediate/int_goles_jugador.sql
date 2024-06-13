with 

jugador as (

    select * from {{ ref('stg_proyecto_final_jugador') }}

),

eventos as (

    select * from {{ ref('stg_proyecto_final_eventos_partidos') }}
    
),

final as (

    select 
        j.id_jugador,
        j.nombre,
        count(tipo_evento) as numero_goles
        
    from jugador j
    join eventos e
    on j.id_jugador = e.id_jugador
    group by j.id_jugador, j.nombre
    order by numero_goles DESC
)

select * from final