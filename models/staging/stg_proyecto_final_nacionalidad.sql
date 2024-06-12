with 

source as (

    select nacionalidad from {{ ref('base_proyecto_final__JUGADORES') }}

),

pais as (

    select distinct
        {{dbt_utils.generate_surrogate_key(['nacionalidad'])}} as id_nacionalidad,
        nacionalidad
    from source


)

select * from pais