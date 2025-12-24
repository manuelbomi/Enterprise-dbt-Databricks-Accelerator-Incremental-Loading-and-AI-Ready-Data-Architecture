{# multiline comment. It will not be compiled #}

--this will be compiled

{% set list1 = ['last_name', 'customerID', 'gender'] %}

SELECT {% for item in list1 %}

           {{ item }}{% if not loop.last %}, {% endif %}

       {% endfor %}

FROM
    {{ source('bakehouse', 'sales_customers') }}