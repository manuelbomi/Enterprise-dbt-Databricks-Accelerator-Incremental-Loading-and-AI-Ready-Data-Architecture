with source as (select * from {{ source('bakehouse', 'sales_transactions') }})

select customerID, product, quantity  from source