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

*Por ejemplo: El jugador con id "1" ya existe en nuestra tabla desde 2020 y es "David". En 2024 insertamos el jugador con id "2" llamado "Pedro" y volvemos a insertar el jugador con "id" 1 pero con nombre "Pablo".
Cuando DBT compare la información ya existente (el jugador 1) con la información que está siendo ingestada (el jugador 1 y 2), insertará con normalidad al jugador 2, puesto que no existe, pero con el jugador 1 deberá versionarlo ya que ha cambiado su LOAD_AT y deberán existir 2 versiones de ese jugador 1, la que existió (David) desde 2020 hasta 2024 y la que existe actualmente (Pablo) desde 2024.*

Y, *¿para qué?* 

Creé una Snapshot en DBT llamada "jugadores_snapshot_cambios" para poder rastrear los cambios en la tabla de "JUGADORES" a partir del campo "LOAD_AT" considerando que ha habido un cambio cuando ese campo es modificado.
Esta Snapshot me sirvió para estar al tanto y saber si algún jugador ha cumplido años y su edad ha cambiado, si han fichado por otro equipo o si su posición en el campo ha cambiado.

## Macros

Crear macros te simplifica bastante el trabajo y es mucho más fácil realizar algunas tareas complejas.
Por eso creé dos macros:

### ObtenerValores.sql

Esta macro es sencilla, lo único que hace es obtener los valores únicos que existen en una tabla. Realmente lo que ejecuta es un "SELECT DISTINCT" con el fin de obtener todos los registros diferentes existentes.

Esto puede ser útil si queremos saber cuántos registros diferentes hay en una columna, por ejemplo, todos los equipos que existen o todas las nacionalidades diferentes.
A la hora de normalizar tablas, esta macro vendrá bastante bien.

### ObtenerVictorias.sql

La segunda y última macro que utilicé se utilizó para contar el número de veces de victorias locales, visitantes o empates.

## STAGING

La carpeta Staging es la primera carpeta en la que se trabaja con los datos en DBT. 
Se reciben los datos raw para proceder a realizar una primera limpieza con el fin de trabajar con unos datos legibles o correctos.
En esta carpeta se realizan las primeras transformaciones, traducciones y organizaciones.

Sin embargo, existe una carpeta BASE dentro de Staging.

### BASE 

Como he mencionado anteriormente, en la carpeta Staging se empieza con las primeras transformaciones y, en mi caso, comencé a normalizar la tabla de "JUGADORES".
Para facilitar el trabajo y no tener que estar modificando el dato constantemente o renombrando cada columna, utilicé carpeta BASE donde realicé los primeros cambios importantes para, posteriormente, trabajar cómodamente con la tabla ya "arreglada".

**Todos los modelos de BASE tienen como source una tabla existente en Snowflake, a partir de esta, ya se referencian entre ellos en DBT para crear el linaje**

- base_proyecto_final__EVENTOS_PARTIDOS.sql

En esta primera base trabajo sobre la tabla "EVENTOS_PARTIDOS" de Snowflake y lo que realizo son transformaciones a INT (tipo de dato entero) y a varchar (tipo de dato texto) estableciendo los tipos correctos para poder realizar operaciones sobre ellos mas adelante.

- base_proyecto_final__RESULTADOS.sql

En esta segunda base trabajo sobre la tabla "RESULTADOS" de Snowflake y aquí ya realizo una limpieza algo más complicada.

Nuevamente corrijo los tipos de datos, en este caso INT y DATE (fecha).
Y, por otro lado, tenía que introducir el nombre correcto del equipo, así que utilicé un IFF() para modificar su nombre y que esté correctamente escrito.

- base_proyecto_final__JUGADORES.sql

Por último, la tercera base, realizada sobre la tabla "JUGADORES".

En esta base tuve que realizar más operaciones y una limpieza aún mayor, ya que esta tabla era la original del .csv y tenía algunos campos vacíos y tipos de datos que no correspondían.
Volví a corregir los tipos de datos a varchar, date e INT.

Apareció uno de los primeros problemas, muchos campos estaban vacíos, es decir, NULL.
Utilicé una función condicional IFF() para reemplazar los NULL de cada campo por un "Desconocido" o algún otro como "Sin_agente" para evitar errores mas adelante con los campos vacíos.

### RESTO DE MODELOS DE STAGING

Después de haber realizado esos cambios generales en la carpeta BASE para no tener que realizarlos en cada modelo de Staging, normalicé la tabla de JUGADORES generando un modelo para cada equipo, agente, jugador, pierna habil, lugar de nacimiento, nacionalidad, posicion y sponsor.

Referenciando el modelo creado en BASE a partir de la tabla en BRONZE de Snowflake de "JUGADORES" traje toda la información que necesitaba para cada modelo/tabla y generé un identificador único para poder relacionar los modelos entre sí y que cada id exista en todas las tablas que debe aparecer.

Por ejemplo: stg_proyecto_final_equipos.sql > selecciono únicamente la columna "equipo" (en lugar de *) de mi BASE de "JUGADORES" para optimizar la consulta y genero una id única a partir del nombre de cada equipo con {{dbt_utils.generate_surrogate_key(['equipo'])}} as id_equipo

***Nota: utilizar dbt_utils.generate_surrogate_key puede no ser la mejor práctica***

Realicé este mismo proceso en todos mis modelos de Staging.

## INTERMEDIATE 

La carpeta intermediate de DBT es utilizada para obtener campos calculados y operaciones evitando tener que realizarlas más adelante. Esta carpeta no es obligatoria y se utiliza para crear modelos intermedios.

## int_goles_en_contra_equipos.sql

En este modelo intermedio tengo como objetivo calcular los goles en contra que recibe cada equipo, tanto de local como de visitante.
Para ello traigo todo el contenido de las tablas "EQUIPOS" y "RESULTADOS" referenciando mi Staging. 

- Creo una primera CTE con el nombre del equipo, su id y los goles en contra jugando de local uniendo las tablas mediante un join.
- Creo una segunda CTE haciendo lo mismo pero a la inversa, obteniendo los goles en contra jugando de visitante.

***En esta CTE tuve que solucionar un problema. Cuando generé la tabla "RESULTADOS" aleatoriamente, no me generó partidos del FC Bayern Munich actuando de visitante, así que tuve que dividir los datos interpretando que ha jugado la mitad de los partidos como visitante***

- Creé una tercera CTE solucionando este mismo problema con los goles locales y uniendo ambos campos, goles locales y visitantes en una misma "tabla".
- Y, por último, creé una cuarta CTE con el mismo contenido de la anterior y añadiendo una nueva columna que sume los goles locales y visitantes como totales.

## int_stats_equipos.sql

Para este modelo intermedio quería conseguir estadísticas a nivel de equipo como sus partidos como locales, visitantes y totales; victorias como locales, visitantes y totales; goles como locales, visitantes y totales...
Traje todo el contenido de mi tabla "EQUIPOS" y "RESULTADOS" referenciando mi Staging.

Antes de realizar nada, establezco una variable "ganador_" que busque resultados de victorias "Local", "Visitante" o "Empates".

- Creo una primera CTE que cuenta el numero de partidos como local y visitante y utilizo un bucle para crear 3 columnas adicionales que añadan el número de victorias locales, visitantes o empates de cada equipo uniendo las tablas mediante un join.
- Creo una segunda CTE corrigiendo el mismo error anteriormente citado acerca del equipo FC Bayern Munich. Además, cambio el nombre de las columnas, ya que con el bucle utilizado se creaban las columnas con el nombre de "local_amount", "visitante_amount" y "empate_amount", corrijo sus tipos de dato y añado un nuevo campo calculado sumando las victorias locales y visitantes para obtener el número total.
- Creo una tercera CTE añadiendo los goles locales y visitantes de cada equipo y corregí los nombres y tipos de dato de varias columnas
- Creo una cuarta CTE corrigiendo el mismo error anteriormente citado acerca del equipo FC Bayern Munich.
- Y, por último, creo una quinta CTE arreglando algunos tipos de dato y añadiendo el último campo calculado sumando los goles locales y visitantes para obtener los totales

## int_stats_jugador.sql

En este modelo intermedio almacené estadísticas a nivel de jugador (como en el anterior modelo intermedio) como sus goles, su número de mvp's y su minuto promedio de gol.
Traje todo el contenido de mi tabla "JUGADOR", "RESULTADOS" y "EVENTOS_PARTIDOS" referenciando mi Staging.

- Creé una primera CTE modificando algunos tipos de dato, renombrando algunas columnas y obteniendo el número de goles y el minuto promedio de gol de cada jugador uniendo las tablas "JUGADOR" y "EVENTOS_PARTIDOS".
- Creé una segunda CTE uniendo la anterior CTE creada con "RESULTADOS" mediante un join para obtener el número de mvp's de cada jugador.

## /int_stats_partidos.sql

Finalmente, en mi último modelo intermedio busco almacenar estadísticas pero ahora a nivel de partidos como el numero de partidos totales, el numero de goles totales, locales y visitantes, el promedio de goles por partido, locales y visitantes, numero de victorias, locales y visitantes y número de empates.
Traje todo el contenido de mi tabla "RESULTADOS" referenciando mi Staging.

Nuevamente, antes de realizar nada, volví a establecer la variable "ganador_" para volver a contar el numero de "Local", "Visitante" y "Empates".

- Creé una primera CTE contando el número de registros como el número de partidos, obtuve los goles locales y visitantes, dividiendo el número de goles totales por el número de partidos totales obtuve el promedio de goles por partido, obtuve el promedio de goles locales y visitantes por partido y obtuve el número de victorias locales, visitantes y empates.
- Creé una segunda CTE corrigiendo los tipos de dato y renombrando las columnas.
