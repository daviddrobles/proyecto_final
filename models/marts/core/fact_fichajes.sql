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
        id_jugador as id_jugador,
        id_agente,
        id_equipo,
        precio_millones,
        fecha_fichaje_equipo,
        load_at

    from jugador
)

select * from final
{% if is_incremental() %}
  where load_at > (select max(load_at) from {{ this }})
{% endif %}