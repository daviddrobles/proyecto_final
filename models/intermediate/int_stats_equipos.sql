{% set ganador_ = ["Local", "Visitante", "Empate"] %}

with 

equipos as (

    select * from {{ ref('stg_proyecto_final_equipos') }}

),

resultados as (

    select * from {{ ref('stg_proyecto_final_resultados') }}
    
),

partidos as (

    select 
        e.equipo as equipo,
        e.id_equipo,
        count(r.id_equipo_local) as numero_partidos_locales,
        count(r.id_equipo_visitante) as numero_partidos_visitantes,
        {%- for ganador in ganador_  %}
        sum(case when ganador = '{{ganador}}' then 1 end) as {{ganador}}_amount
        {%- if not loop.last %},{% endif -%}
        {% endfor %}

    from equipos e
    join resultados r
    on e.id_equipo = r.id_equipo_local OR e.equipo = r.id_equipo_visitante
    group by e.equipo, id_equipo

),

victorias_arreglado as (

    select
        equipo,
        id_equipo,
        IFF(equipo = 'Bayern Munich', (numero_partidos_locales/2), numero_partidos_locales)::INT as numero_partidos_locales,
        IFF(equipo = 'Bayern Munich', (numero_partidos_locales/2), numero_partidos_visitantes)::INT as numero_partidos_visitantes,
        IFF(equipo = 'Bayern Munich', (local_amount/2), local_amount)::INT as victorias_locales,
        IFF(equipo = 'Bayern Munich', (local_amount/2), visitante_amount)::INT as victorias_visitantes,
        empate_amount::INT as empate,
        (victorias_locales + victorias_visitantes)::INT as victorias_totales

    from partidos
),

goles_equipos as (

    select
        equipo,
        id_equipo,
        numero_partidos_locales::INT as numero_partidos_locales,
        numero_partidos_visitantes::INT as numero_partidos_visitantes,
        (numero_partidos_locales + numero_partidos_visitantes)::INT as numero_partidos_total,
        victorias_locales,
        victorias_visitantes,
        empate,
        victorias_totales,
        sum(goles_local) as goles_locales_total,
        sum(goles_visitante) as goles_visitantes_total

    from victorias_arreglado va
    join resultados r
    on va.id_equipo = r.id_equipo_local OR va.equipo = r.id_equipo_visitante
    group by all

),

goles_arreglado as (

    select
        equipo,
        id_equipo,
        numero_partidos_locales::INT as numero_partidos_locales,
        numero_partidos_visitantes::INT as numero_partidos_visitantes,
        numero_partidos_total,
        victorias_locales,
        victorias_visitantes,
        empate,
        victorias_totales,
        IFF(equipo = 'Bayern Munich', (goles_locales_total/2), goles_locales_total)::INT as goles_locales_total,
        IFF(equipo = 'Bayern Munich', (goles_locales_total/2), goles_visitantes_total)::INT as goles_visitantes_total,
        -- (goles_locales_total + goles_visitantes_total)::INT as goles_totales

    from goles_equipos
),

final as (

    select
        equipo,
        id_equipo,
        numero_partidos_locales::INT as numero_partidos_locales,
        numero_partidos_visitantes::INT as numero_partidos_visitantes,
        numero_partidos_total,
        victorias_locales,
        victorias_visitantes,
        empate,
        victorias_totales,
        goles_locales_total,
        goles_visitantes_total,
        (goles_locales_total + goles_visitantes_total)::INT as goles_totales

    from goles_arreglado

)

select * from final