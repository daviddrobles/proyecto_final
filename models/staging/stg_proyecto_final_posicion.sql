with 

source as (

    select posicion from {{ ref('base_proyecto_final__JUGADORES') }}

),

pos as (

    select distinct
        {{dbt_utils.generate_surrogate_key(['posicion'])}} as id_posicion,
        posicion
    from source


)

select * from pos