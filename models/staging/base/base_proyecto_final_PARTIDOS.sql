with 

source as (

    select * from {{ source('proyecto_final', 'RESULTADOS') }}

),

partidos as (

    SELECT 
        id_partido::INT as id_partido,
        IFF(equipo_local = '1.FC Koln', '1.FC Köln', equipo_local) as equipo_local,
        resultado,
        IFF(equipo_visitante = '1.FC Koln', '1.FC Köln', equipo_visitante) as equipo_visitante,
        ganador,
        fecha::DATE as fecha,
        goles_local::INT as goles_local,
        goles_visitante::INT as goles_visitante,
        mvp

    from source
)

select * from partidos