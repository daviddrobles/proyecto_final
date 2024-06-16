{% set ganador_ = ["Local", "Visitante", "Empate"] %}

with 

equipos as (

    select * from {{ ref('stg_proyecto_final_equipos') }}

),

resultados as (

    select * from {{ ref('stg_proyecto_final_resultados') }}
    
),

victorias as (

    select distinct
        e.equipo as equipo,
        e.id_equipo,
        {%- for ganador in ganador_  %}
        sum(case when ganador = '{{ganador}}' then 1 end) as {{ganador}}_amount
        {%- if not loop.last %},{% endif -%}
        {% endfor %}

    from equipos e
    join resultados r
    on e.id_equipo = r.id_equipo_local OR e.equipo = r.id_equipo_visitante
    group by e.equipo, e.id_equipo
),

final as (

    select
        equipo,
        id_equipo,
        IFF(equipo = 'Bayern Munich', (local_amount/2), local_amount)::INT as victorias_locales,
        IFF(equipo = 'Bayern Munich', (local_amount/2), visitante_amount)::INT as victorias_visitantes,
        empate_amount::INT as empate,
        (victorias_locales + victorias_visitantes)::INT as victorias_totales

    from victorias
)

select * from final