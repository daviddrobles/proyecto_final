with 

source as (

    select * from {{ ref('base_proyecto_final__EVENTOS_PARTIDOS') }}

),

base as (

    select 
        id_evento,
        id_partido,
        {{dbt_utils.generate_surrogate_key(['equipo'])}} as id_equipo,
        id_jugador,
        nombre_jugador,
        tipo_evento,
        minuto
    from source
)

select * from base