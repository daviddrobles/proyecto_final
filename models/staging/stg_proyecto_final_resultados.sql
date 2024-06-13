with 

source as (

    select * from {{ ref('base_proyecto_final__RESULTADOS')}}

),

partidos as (

    SELECT 
        id_partido,
        {{dbt_utils.generate_surrogate_key(['equipo_local'])}} as id_equipo_local,
        resultado,
        {{dbt_utils.generate_surrogate_key(['equipo_visitante'])}} as id_equipo_visitante,
        ganador,
        fecha,
        goles_local,
        goles_visitante,
        mvp

    from source
)

select * from partidos