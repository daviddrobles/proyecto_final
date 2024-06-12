with 

source as (

    select pierna_habil from {{ ref('base_proyecto_final__JUGADORES') }}

),

pierna as (

    select distinct
        {{dbt_utils.generate_surrogate_key(['pierna_habil'])}} as id_pierna_habil,
        pierna_habil
    from source


)

select * from pierna