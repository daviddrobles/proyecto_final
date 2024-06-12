with 

source as (

    select equipo from {{ ref('base_proyecto_final__JUGADORES') }}

),

club as (

    select distinct
        {{dbt_utils.generate_surrogate_key(['equipo'])}} as id_equipo,
        equipo
    from source


)

select * from club