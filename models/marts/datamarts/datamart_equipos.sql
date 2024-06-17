with 

equipos as (

    select * from {{ ref('int_stats_equipos') }}

),

final as (

    select *
    from equipos
)

select * from final