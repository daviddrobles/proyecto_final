# DOCUMENTO EXPLICATIVO DEL PROYECTO

## Plataformas utilizadas y contexto

El proyecto ha sido realizado en DBT (Data Build Tool) sobre un .csv que recopilaba información en una ÚNICA TABLA llamada "JUGADORES" acerca de los jugadores de la Bundesliga (Liga Alemana de fútbol) como sus nombres, dorsales, edad, equipos... que se importó a Snowflake donde consideré que la información almacenada en ese fichero era insuficiente y apenas podría crear algo sobre ella.

Debido a esto, decidí crear tablas adicionales generadas de manera aleatoria a partir de la información ya existente, es decir, creé una tabla de clasificación simulando una temporada entera a partir de los equipos recopilados en la tabla "JUGADORES" y la llamé "RESULTADOS", y, además, creé una tabla generada de manera aleatoria a partir de la tabla "RESULTADOS" que llamé "EVENTOS_PARTIDOS" para así poder tener estadísticas a nivel de jugador y equipo.

(En el siguiente punto explicaré cada tabla detalladamente)

Se ha seguido una arquitectura medallion para realizar el proyecto, esto quiere decir que estas tablas nombradas estaban almacenadas en mi capa BRONZE de Snowflake.

Y, por último, el proyecto está COMPLETAMENTE documentado (en DBT) y testeado.

## Tablas principales

Como se ha mencionado anteriormente, el proyecto partió de un .csv original llamado "JUGADORES" que no fue suficiente para la idea que tenía en mente.
Estaban almacenadas en mi capa BRONZE de Snowflake y se importaron a DBT a mi carpeta "STAGING"

### La tabla "JUGADORES" contenía exactamente las siguientes columnas:

- id = El identificador único asignado a cada jugador que diferenciaba a cada uno de ellos.
- name = El nombre conocido de cada jugador.
- full_name = El nombre COMPLETO de cada jugador. ***Esto supuso un problema más adelante***
- age = La edad de cada jugador.
- height = La altura de cada jugador.
- nationality = La nacionalidad de cada jugador.
- place_of_birth = El lugar exacto de nacimiento de cada jugador.
- price = El precio de mercado del jugador.
- max_price = El precio de mercado máximo alcanzado por el jugador.
- position = La posición en el campo de cada jugador.
- shirt_nr = El dorsal de cada jugador.
- foot = La pierna hábil de cada jugador.
- club = El equipo al que pertenece el jugador.
- contract_expires = La fecha de expiración del contrato de cada jugador.
- joined_club = La fecha en la que cada jugador fichó por el equipo.
- player_agent = El agente de cada jugador.
- outfitter = El patrocinador de cada jugador.
- LOAD_AT = ***Campo generado***. La fecha de carga de cada dato. ***Esta columna generada nos servirá más adelante para crear Snapshots***

### La tabla "RESULTADOS" contenía exactamente las siguientes columnas:

- id_partido = El identificador único de cada partido jugado.
- equipo_local = El nombre del equipo que juega como local.
- resultado = El resultado del partido con el siguiente formato (resultado de ejemplo) " 2 - 0 ".
- equipo_visitante = El nombre del equipo que juega como visitante.
- fecha = La fecha en la que se jugó el partido.
- ganador = Indica si el ganador es el equipo local o el visitante o si el partido acabó en empate.
- goles_local = El número de goles marcados por el local. Este campo se generó a partir de la columna de "resultado" separando el resultado en 2 partes.
- goles_visitante = El número de goles marcados por el visitante. Este campo se generó a partir de la columna de "resultado" separando el resultado en 2 partes.
- mvp = El jugador más valioso del partido.

### La tabla "EVENTOS_PARTIDOS" contenía exactamente las siguientes columnas:

- id_evento = El identificador único de cada evento existente en toda la temporada.
- id_partido = El identificador único del partido en el que ocurre el evento.
- equipo = El nombre del equipo al que pertenece el evento.
- id_jugador = El identificador único del jugador que realiza el evento.
- nombre_jugador = El nombre del jugador que realiza el evento.
- tipo_evento = Indica qué evento específico ha ocurrido.
- minuto = El minuto en el que ocurre el evento.

## Snapshot

Antes de nada, *¿qué es una Snapshot?* pues bien, una Snapshot es una funcionalidad utilizada para capturar el histórico de una tabla. Esto nos permite llevar un control de versiones y detectar modificaciones en los registros. 

Y, *¿cómo funciona?* 

DBT compara la tabla de origen con la información ya existente, y si un registro insertado tiene un "id" diferente, se insertará con normalidad, pero si ese "id" ya existe en la tabla y el "LOAD_AT" ha cambiado, se generará una nueva versión de ese registro en la tabla.

*Por ejemplo: El jugador con id "1" ya existe en nuestra tabla desde 2020 y es "David". En 2025 insertamos el jugador con id "2" llamado "Pedro" y volvemos a insertar el jugador con "id" 1 pero con nombre "Pablo".
Cuando DBT compare la información ya existente (el jugador 1) con la información que está siendo ingestada (el jugador 1 y 2), insertará con normalidad al jugador 2, puesto que no existe, pero con el jugador 1 deberá versionarlo ya que ha cambiado su LOAD_AT y deberán existir 2 versiones de ese jugador 1, la que existió (David) desde 2020 hasta 2024 y la que existe actualmente (Pablo) desde 2024.*

Y, *¿para qué?* 

Creé una Snapshot en DBT llamada "jugadores_snapshot_cambios" para poder rastrear los cambios en la tabla de "JUGADORES" a partir del campo "LOAD_AT" considerando que ha habido un cambio cuando ese campo es modificado.
Esta Snapshot me sirvió para estar al tanto y saber si algún jugador ha cumplido años y su edad ha cambiado, si han fichado por otro equipo o si su posición el campo ha cambiado.
