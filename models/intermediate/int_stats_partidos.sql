{% set ganador_ = ["Local", "Visitante", "Empate"] %}

with 

partidos as (

    select * from {{ ref('stg_proyecto_final_resultados') }}
    
),

stats as (

    select
        count(*) as numero_partidos,
        sum(goles_local) as numero_de_goles_locales,
        sum(goles_visitante) as numero_de_goles_visitantes,
        (numero_de_goles_locales + numero_de_goles_visitantes) as numero_de_goles_totales,
        (numero_de_goles_totales / numero_partidos) as promedio_goles_por_partido,
        avg(goles_local) as promedio_goles_local_por_partido,
        avg(goles_visitante) as promedio_goles_visitante_por_partido,
        {%- for ganador in ganador_  %}
        sum(case when ganador = '{{ganador}}' then 1 end) as {{ganador}}_amount
        {%- if not loop.last %},{% endif -%}
        {% endfor %}
    from partidos

),

final as (

    select
        numero_partidos::INT as numero_partidos,
        numero_de_goles_totales::INT as numero_de_goles_totales,
        numero_de_goles_locales::INT as numero_de_goles_locales,
        numero_de_goles_visitantes::INT as numero_de_goles_visitantes,
        promedio_goles_por_partido as promedio_goles_por_partido,
        promedio_goles_local_por_partido as promedio_goles_local_por_partido,
        promedio_goles_visitante_por_partido as promedio_goles_visitante_por_partido,
        local_amount::INT as numero_victorias_locales,
        visitante_amount::INT as numero_victorias_visitante,
        empate_amount::INT as numero_empates

    from stats
)

select * from final