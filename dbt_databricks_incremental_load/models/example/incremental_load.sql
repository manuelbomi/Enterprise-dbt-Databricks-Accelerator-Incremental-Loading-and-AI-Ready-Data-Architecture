{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'merge',
        unique_key = 'deviceId',
        merge_update_columns = ['angle', 'rpm', 'status'],
        cluster_by = ['deviceId'],
        on_schema_change = 'sync_all_columns'
    )
}}

SELECT * FROM {{ref('data')}}
{% if is_incremental() %}
    WHERE timestamp > (SELECT date_sub(MAX(timestamp), 2) from {{this}})

{% endif %}