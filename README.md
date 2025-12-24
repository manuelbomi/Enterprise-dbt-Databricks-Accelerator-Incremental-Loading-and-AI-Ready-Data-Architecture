# Enterprise dbt Databricks Accelerator: Incremental Loading & AI-Ready Data Architecture

https://img.shields.io/badge/dbt-1.11.0-FF694B

https://img.shields.io/badge/Databricks-Unity_Catalog-FF3621

https://img.shields.io/badge/Strategy-Incremental_Merge-blue

https://img.shields.io/badge/License-Apache_2.0-blue.svg

https://img.shields.io/badge/Architecture-Enterprise_Scale-orange

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
cd enterprise-dbt-databricks-accelerator

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





