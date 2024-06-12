with 

source as (

    select * from {{ ref('base_proyecto_final__JUGADORES') }}

),

base as (

select
    id_jugador,
    nombre as nombre_conocido,
    left(nombre_completo, CHARINDEX(' ', nombre_completo)) as nombre_jugador,
    substring(nombre_completo, CHARINDEX(' ', nombre_completo)+1, len(nombre_completo)-(CHARINDEX(' ', nombre_completo)-1)) as apellido_jugador,
FROM source

),

-- select * from base

base2 as (

    select 
        id_jugador,
        nombre_conocido,
        nombre_jugador,
        left(apellido_jugador, CHARINDEX(' ', apellido_jugador)) as primer_apellido,
        substring(apellido_jugador, CHARINDEX(' ', apellido_jugador)+1, len(apellido_jugador)-(CHARINDEX(' ', apellido_jugador)-1)) as segundo_apellido
FROM base
),

base3 as (

    select
        id_jugador,
        nombre_conocido,
        IFF(nombre_jugador = '', 'Desconocido', nombre_jugador) as nombre_jugador,
        IFF(primer_apellido = '', 'Desconocido', primer_apellido) as primer_apellido,
        IFF(segundo_apellido = '', 'Desconocido', segundo_apellido) as segundo_apellido

    from base2
)

select * from base3

-- ,

-- base4 as (

--         select
--         id_jugador,
--         nombre_conocido,
--         IFF(nombre_jugador = 'Desconocido', left(nombre_conocido, CHARINDEX(' ', nombre_conocido)), nombre_jugador) as nombre_jugador,
--         primer_apellido,
--         segundo_apellido

--     from base3

-- )

-- select * from base4