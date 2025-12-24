{%- macro dbt_databricks_proj_macro(column_name) -%}
     {{ column_name }} as macro_new_column
{%- endmacro -%}