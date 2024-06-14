with 

mvp as (

    select * from {{ ref('int_mvp_jugador') }}

),

final as (

    select
        ID_JUGADOR,
        nombre,
        NUMERO_MVP
    from mvp
)

select * from final