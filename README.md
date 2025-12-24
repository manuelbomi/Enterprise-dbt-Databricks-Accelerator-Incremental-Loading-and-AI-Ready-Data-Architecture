# Enterprise dbt Databricks Accelerator: Incremental Loading & AI-Ready Data Architecture


[![Enterprise](https://img.shields.io/badge/Architecture-Enterprise_Scale-orange)
[![dbt](https://img.shields.io/badge/dbt-1.11.0-FF694B)](https://www.getdbt.com/)
[![Databricks](https://img.shields.io/badge/Databricks-Unity%20Catalog-FF3621)](https://databricks.com/)
[![Databricks](https://img.shields.io/badge/Strategy-Incremental_Merge-blue)
[![Apache](https://img.shields.io/badge/License-Apache_2.0-blue.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

### Production-Grade dbt Implementation with Incremental Loading and AI/ML Readiness for Global Enterprises

---

## Executive Summary
##### This repository demonstrates a complete enterprise data engineering implementation using dbt, Databricks Unity Catalog, and modern data architecture patterns. It showcases everything from foundational dbt setup to advanced incremental loading strategies and AI/ML-ready data products—all battle-tested with real-world troubleshooting and solutions.

<ins>Key Achievement</ins>: Successfully migrated from legacy Hive Metastore to modern Databricks Unity Catalog architecture while implementing production-grade incremental data processing patterns with dbt (Data Build Tool)

---

##  Quick Start for Enterprise Teams

```python
# Clone the repository
git clone https://github.com/manuelbomi/Enterprise-dbt-Databricks-Accelerator-Incremental-Loading-and-AI-Ready-Data-Architecture.git
cd dbt_databricks_incremental_load

# Set up environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install dbt-core dbt-databricks

# Configure your environment (use provided templates)
cp config/profiles.yml.example ~/.dbt/profiles.yml
cp config/environment-variables.example .env

# Initialize and test
dbt debug  # Verify connection
dbt run --select incremental_load  # Test incremental strategy
dbt test  # Validate data quality
dbt docs generate  # Generate documentation
dbt docs serve  # View at localhost:8080

```

## Core Features & Implementation

#### 1. <ins>Incremental Loading Strategies</ins>

##### Implemented production-grade incremental patterns as per dbt's incremental strategy documentation available here: https://docs.getdbt.com/docs/build/incremental-strategy

```python

-- models/example/incremental_load.sql
{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'merge',  -- Optimal for Databricks
        unique_key = 'deviceId',
        merge_update_columns = ['angle', 'rpm', 'status'],
        cluster_by = ['deviceId'],
        on_schema_change = 'append_new_columns'  -- Handle schema evolution
    )
}}

SELECT * FROM {{ref('data')}}
{% if is_incremental() %}
    WHERE timestamp > (SELECT date_sub(MAX(timestamp), 2) from {{this}})
{% endif %}

```

#### Why This Matters for Enterprises:

- <ins>Performance</ins>: Processes only new/changed data ( for example, enterprise with 65M+ daily transactions such as McDonald's)

- <ins>Cost Efficiency</ins>: Reduces compute costs by 60-80% vs full refreshes

- <ins>Freshness</ins>: Near-real-time data availability with sub-minute latency SLAs

- <ins>Schema Evolution</ins>: on_schema_change handles production schema migrations gracefully

---



#### 2. <ins>Unity Catalog Integration</ins>

#### Solved the critical UC_HIVE_METASTORE_DISABLED_EXCEPTION migration challenge:

```python

# Correct configuration for Databricks Free Edition with Unity Catalog
profiles.yml:
  outputs:
    dev:
      catalog: workspace  # Unity Catalog integration
      schema: dbt_databricks_proj_sch
      type: databricks

```

#### Migration Journey Documented:

- Initial error: UC_HIVE_METASTORE_DISABLED_EXCEPTION

- Solution: Proper Unity Catalog configuration

- Result: "All checks passed!" with enterprise-grade governance



#### 3. <ins>Data Quality Framework </ins>

##### Configurable testing with severity management:

```python
# models/example/schema.yml
models:
  - name: model1
    columns:
      - name: customerID
        tests:
          - not_null:
              severity: error  # Fails build
          - unique:
              severity: warn   # Warning only
      - name: gender
        tests:
          - accepted_values:
              values: ['male', 'female']
              severity: error
```



#### 4. <ins>Custom Macros & Jinja Templating </ins>

##### Advanced code reuse and dynamic SQL generation:

```python
-- macros/custom/dbt_databricks_proj_macro.sql
{%- macro dbt_databricks_proj_macro(column_name) -%}
     {{ column_name }} as macro_new_column
{%- endmacro -%}

-- models/example/model3.sql (Dynamic column selection)
{% set list1 = ['gender', 'customerID', 'first_name'] %}

SELECT {% for item in list1 %}
           {{ item }}{% if not loop.last %}, {% endif %}
       {% endfor %}
FROM {{ source('bakehouse', 'sales_customers') }}

```

---

## Architecture Patterns for Enterprise Scale

#### Incremental Strategy Selection Guide

##### Based on dbt's incremental strategies documentation, here's when to use each pattern:

| Strategy | Best For | Enterprise Use Case | Implementation |
|----------|----------|---------------------|----------------|
| merge | Updates & inserts, Databricks/Snowflake | Customer dimension updates | incremental_strategy = 'merge' |
| insert_overwrite | Partition replacement, BigQuery | Daily fact table refreshes | incremental_strategy = 'insert_overwrite' |
| append | Event streams, immutable data | Clickstream/telemetry data | incremental_strategy = 'append' |
| delete+insert | Simple overwrites, smaller datasets | Reference data updates | Legacy pattern, not recommended |


# dbt Incremental Materialization Strategies

## Strategy Comparison Matrix

| Strategy | Supported Platforms | Use Case | SQL Pattern | Performance | Data Integrity |
|----------|---------------------|----------|-------------|-------------|----------------|
| **`merge`** | Databricks, Snowflake, Spark, Redshift | SCD Type 2, customer dimensions | `MERGE INTO ... WHEN MATCHED ... WHEN NOT MATCHED` | Medium | ✅ **High** |
| **`insert_overwrite`** | BigQuery, Snowflake, Databricks | Partitioned fact tables | `CREATE OR REPLACE TABLE partition` | High | ✅ **High** |
| **`append`** | All platforms | Event streams, logs, telemetry | `INSERT INTO ... SELECT ...` | Very High | ✅ **High** |
| **`delete+insert`** | Legacy support | Small reference tables | `DELETE ...; INSERT ...` | Low | ⚠️ **Medium** |

## Implementation Examples

### 1. Merge Strategy (Recommended for Dimensions)
```sql
{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='customer_id'
) }}

SELECT 
    customer_id,
    customer_name,
    updated_at
FROM {{ ref('stg_customers') }}
WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
```

### 2. Insert Overwrite Strategy (BigQuery Partitioned Tables)
```sql
{{ config(
    materialized='incremental',
    incremental_strategy='insert_overwrite',
    partition_by={'field': 'date', 'data_type': 'date'}
) }}

SELECT 
    date,
    product_id,
    SUM(sales_amount) as daily_sales
FROM {{ ref('stg_transactions') }}
GROUP BY 1, 2
```

### 3. Append Strategy (Event Data)
```sql
{{ config(
    materialized='incremental',
    incremental_strategy='append'
) }}

SELECT 
    event_id,
    user_id,
    event_timestamp,
    event_type
FROM {{ ref('stg_events') }}
WHERE event_timestamp > (SELECT MAX(event_timestamp) FROM {{ this }})
```

## Selection Guidelines
- **Dimensional data:** Use `merge` with `unique_key`
- **Partitioned fact tables:** Use `insert_overwrite`
- **Append-only events:** Use `append`
- **Avoid:** `delete+insert` (legacy, inefficient)





