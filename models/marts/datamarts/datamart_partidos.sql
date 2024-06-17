with 

partidos as (

    select * from {{ ref('int_stats_partidos') }}

),

final as (

    select *
    from partidos
)

select * from final