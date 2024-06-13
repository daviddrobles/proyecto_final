{% macro obtener_tipo_eventos() %}
{{ return(["Local", "Visitante", "Empate"]) }}
{% endmacro %}