{{
    config(
        materialized = "table"
    )
}}

with 

pierna_habil as (

    select * from {{ ref('stg_proyecto_final_pierna_habil') }}

),

final AS (

    select
        id_pierna_habil,
        pierna_habil
    from pierna_habil
)

select * from final