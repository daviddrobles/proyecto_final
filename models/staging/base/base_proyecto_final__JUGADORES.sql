with 

source as (
    
    select * from {{ source('snapshots', 'JUGADORES_SNAPSHOT_CAMBIOS') }}

),

renamed as (

    select
        id::INT as id_jugador,
        name::varchar(256) as nombre,
        IFF(full_name IS null, 'Desconocido', full_name)::varchar(256) as nombre_completo,
        age::NUMBER(38,0) as edad,
        height::NUMBER(38,2) as altura,
        nationality::varchar(256) as nacionalidad,
        IFF(place_of_birth IS NULL, 'Desconocido', place_of_birth)::varchar(256) as lugar_nacimiento,
        IFF(price IS NULL, '0', price)::NUMBER(38,3) as precio_millones,
        IFF(max_price IS NULL, '0', max_price)::NUMBER(38,2) as precio_maximo__millones_historico,
        position::varchar(256) as posicion,
        shirt_nr::INT as numero_camiseta,
        IFF(foot IS NULL, 'Desconocido', foot)::varchar(256) as pierna_habil,
        club::varchar(256) as equipo,
        contract_expires::DATE as fecha_expiracion_contrato,
        joined_club::DATE as fecha_fichaje_equipo,
        IFF(player_agent IS NULL, 'Sin_agente', player_agent)::varchar(256) as agente,
        IFF(outfitter IS NULL, 'Sin sponsor', outfitter)::varchar(256) as sponsor,
        load_at,
        DBT_SCD_ID,
        DBT_UPDATED_AT,
        DBT_VALID_FROM,
        DBT_VALID_TO

    from source

)

select * from renamed
