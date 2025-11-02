-- Databricks notebook source
-- MAGIC %md-sandbox
-- MAGIC
-- MAGIC <div  style="text-align: center; line-height: 0; padding-top: 9px;">
-- MAGIC   <img src="https://raw.githubusercontent.com/derar-alhussein/Databricks-Certified-Data-Engineer-Associate/main/Includes/images/bookstore_schema.png" alt="Databricks Learning" style="width: 600">
-- MAGIC </div>

-- COMMAND ----------

-- MAGIC %run ../Includes/Copy-Datasets

-- COMMAND ----------

SELECT * FROM orders

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC ## Filtering Arrays

-- COMMAND ----------

SELECT
  order_id,
  books,
  FILTER (books, i -> i.quantity >= 3) AS multiple_copies
FROM orders

-- COMMAND ----------

SELECT order_id, multiple_copies
FROM (
  SELECT
    order_id,
    FILTER (books, i -> i.quantity >= 2) AS multiple_copies
  FROM orders)
WHERE size(multiple_copies) > 0;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC ## Transforming Arrays

-- COMMAND ----------

select
  order_id,
  transform(
    books, b -> b.withField('subtotal', 100)
  ) as books_updated
from orders;

-- COMMAND ----------

SELECT
  order_id,
  books,
  TRANSFORM (
    books,
    b -> CAST(b.subtotal * 0.8 AS INT)
  ) AS subtotal_after_discount
FROM orders;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## User Defined Functions (UDF)

-- COMMAND ----------

CREATE OR REPLACE FUNCTION get_url(email STRING)
RETURNS STRING

RETURN concat("https://www.", split(email, "@")[1])

-- COMMAND ----------

create or replace temp function get_url(email string)
returns string
return concat("https://www.", split(email, "@")[1])

-- COMMAND ----------

describe function extended get_url

-- COMMAND ----------

SELECT email, get_url(email) as domain
FROM customers

-- COMMAND ----------

DESCRIBE FUNCTION get_url

-- COMMAND ----------

DESCRIBE FUNCTION EXTENDED get_url

-- COMMAND ----------

create function website_sorter(email string)
returns string
return case
  when email like "%.com" then "Commercial"
  when email like "%.org" then "non-profit"
  when email like "%.edu" then "educational"
  else
    concat("unknown type for : ", split(email, "@")[1])
  end;


-- COMMAND ----------

CREATE FUNCTION site_type(email STRING)
RETURNS STRING
RETURN CASE 
          WHEN email like "%.com" THEN "Commercial business"
          WHEN email like "%.org" THEN "Non-profits organization"
          WHEN email like "%.edu" THEN "Educational institution"
          ELSE concat("Unknow extenstion for domain: ", split(email, "@")[1])
       END;

-- COMMAND ----------

SELECT email, website_sorter(email) as domain_category
FROM customers

-- COMMAND ----------

show user functions

-- COMMAND ----------


