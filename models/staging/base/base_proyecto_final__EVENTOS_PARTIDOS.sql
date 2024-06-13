with 

source as (

    select * from {{ source('proyecto_final', 'EVENTOS_PARTIDOS') }}

),

renamed as (

    select
        id_evento::INT as id_evento,
        id_partido::INT as id_partido,
        equipo::varchar(256) as equipo,
        id_jugador::INT as id_jugador,
        nombre_jugador::varchar(256) as nombre_jugador,
        tipo_evento::varchar(256) as tipo_evento,
        minuto::INT as minuto

    from source

)

select * from renamed
