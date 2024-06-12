with 

source as (

    select * from {{ ref('base_proyecto_final__JUGADORES') }}

),

base as (

    select 
        id_jugador,
        nombre,
        edad,
        altura,
        {{dbt_utils.generate_surrogate_key(['nacionalidad'])}} as id_nacionalidad,
        {{dbt_utils.generate_surrogate_key(['lugar_nacimiento'])}} as id_lugar_nacimiento,
        precio_millones,
        precio_maximo__millones_historico,
        {{dbt_utils.generate_surrogate_key(['posicion'])}} as id_posicion,
        numero_camiseta,
        {{dbt_utils.generate_surrogate_key(['pierna_habil'])}} as id_pierna_habil,
        {{dbt_utils.generate_surrogate_key(['equipo'])}} as id_equipo,
        fecha_expiracion_contrato,
        fecha_fichaje_equipo,
        {{dbt_utils.generate_surrogate_key(['agente'])}} as id_agente,
        {{dbt_utils.generate_surrogate_key(['sponsor'])}} as id_sponsor

    from source
)

select * from base