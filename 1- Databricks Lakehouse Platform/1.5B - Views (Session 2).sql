-- Databricks notebook source
USE CATALOG hive_metastore;

-- COMMAND ----------

SHOW TABLES;

-- COMMAND ----------

SHOW TABLES IN global_temp;

-- COMMAND ----------

SELECT * FROM global_temp.global_temp_view_latest_phones;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC ## Dropping Views

-- COMMAND ----------

use catalog hive_metastore;

-- COMMAND ----------

show tables;

-- COMMAND ----------

show tables in global_temp;

-- COMMAND ----------

select * from global_temp.global_temp_view_latest_phones

-- COMMAND ----------

drop table smartphones;

-- COMMAND ----------

show tables in global_temp;
