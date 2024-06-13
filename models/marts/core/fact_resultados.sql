{{
    config(
        materialized = "table"
    )
}}

with 

resultados as (

    select * from {{ ref('stg_proyecto_final_resultados') }}

),

final AS (

    select
        id_partido,
        id_equipo_local,
        resultado,
        id_equipo_visitante,
        ganador,
        mvp,
        fecha
    from resultados
)

select * from final