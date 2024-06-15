{{
    config(
        materialized = "table"
    )
}}

with 

agente as (

    select * from {{ ref('stg_proyecto_final_agente') }}

),

final AS (

    select
        id_agente,
        agente
    from agente
)

select * from final