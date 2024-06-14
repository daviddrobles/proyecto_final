{{
    config(
        materialized = "table"
    )
}}

with 

jugador_goles as (

    select * from {{ ref('int_goles_jugador') }}

),

final as (

    select
        ID_JUGADOR,
        NOMBRE,
        NUMERO_GOLES,
        MINUTO as minuto_mas_goleado,
        (numero_goles/90) as goles_por_partido
    
    from jugador_goles

)

select * from final