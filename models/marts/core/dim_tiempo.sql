{{
    config(
        materialized = "table"
    )
}}
{{ dbt_date.get_date_dimension('2009-07-01', '2028-06-30') }}