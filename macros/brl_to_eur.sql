{% macro brl_to_eur(column_name, rate=0.17) %}
    {{ column_name }} * {{ rate }}
{% endmacro %}
