 {{config( materialized='table', severity='warn', tags = ["proj_tag"])}}

with source as (select * from {{ source('bakehouse', 'sales_customers') }})

select customerID, first_name, last_name, gender, {{ dbt_databricks_proj_macro('first_name') }} from source