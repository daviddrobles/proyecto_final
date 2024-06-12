with 

source as (

    select agente from {{ ref('base_proyecto_final__JUGADORES') }}

),

agente as (

    select distinct
        {{dbt_utils.generate_surrogate_key(['agente'])}} as id_agente,
        agente
    from source


)

select * from agente