with 

source as (

    select sponsor from {{ ref('base_proyecto_final__JUGADORES') }}

),

patrocinador as (

    select distinct
        {{dbt_utils.generate_surrogate_key(['sponsor'])}} as id_sponsor,
        sponsor
    from source


)

select * from patrocinador