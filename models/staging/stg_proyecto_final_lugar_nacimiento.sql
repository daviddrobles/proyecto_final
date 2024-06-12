with 

source as (

    select lugar_nacimiento from {{ ref('base_proyecto_final__JUGADORES') }}

),

lugar as (

    select distinct
        {{dbt_utils.generate_surrogate_key(['lugar_nacimiento'])}} as id_lugar_nacimiento,
        lugar_nacimiento
    from source


)

select * from lugar