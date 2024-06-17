{{ config (
    materialized='incremental',
    on_schema_change='fail'
    ) 
    }}

with 

jugador as (

    select * from {{ ref('stg_proyecto_final_jugador') }}

),

final AS (

    select
        id_jugador::varchar(256) as id_jugador,
        id_equipo,
        fecha_fichaje_equipo as fecha_inicio,
        fecha_expiracion_contrato,
        IFF(CURRENT_TIMESTAMP > fecha_expiracion_contrato, FALSE, TRUE)::BOOLEAN as activo,
        load_at

    from jugador
)

select * from final
{% if is_incremental() %}
  where load_at > (select max(load_at) from {{ this }})
{% endif %}