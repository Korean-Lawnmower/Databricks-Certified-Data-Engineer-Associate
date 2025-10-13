-- Databricks notebook source
-- MAGIC %md-sandbox
-- MAGIC
-- MAGIC <div  style="text-align: center; line-height: 0; padding-top: 9px;">
-- MAGIC   <img src="https://raw.githubusercontent.com/derar-alhussein/Databricks-Certified-Data-Engineer-Associate/main/Includes/images/bookstore_schema.png" alt="Databricks Learning" style="width: 600">
-- MAGIC </div>

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Querying JSON 

-- COMMAND ----------

-- MAGIC %run ../Includes/Copy-Datasets

-- COMMAND ----------

-- MAGIC %python
-- MAGIC files = dbutils.fs.ls(f"{dataset_bookstore}/customers-json")
-- MAGIC display(files)

-- COMMAND ----------

SELECT * FROM json.`${dataset.bookstore}/customers-json/export_001.json`

-- COMMAND ----------

SELECT * FROM json.`${dataset.bookstore}/customers-json/export_*.json`

-- COMMAND ----------

SELECT * FROM json.`${dataset.bookstore}/customers-json`

-- COMMAND ----------

SELECT count(*) FROM json.`${dataset.bookstore}/customers-json`

-- COMMAND ----------

 SELECT *,
    input_file_name() source_file
  FROM json.`${dataset.bookstore}/customers-json`;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Querying text Format

-- COMMAND ----------

SELECT * FROM text.`${dataset.bookstore}/customers-json`

-- COMMAND ----------

-- MAGIC %md 
-- MAGIC ## Querying binaryFile Format

-- COMMAND ----------

SELECT * FROM binaryFile.`${dataset.bookstore}/customers-json`

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC ## Querying CSV 

-- COMMAND ----------

SELECT * FROM csv.`${dataset.bookstore}/books-csv`

-- COMMAND ----------

drop table books_csv

-- COMMAND ----------

CREATE TABLE books_csv
  (book_id STRING, title STRING, author STRING, category STRING, price DOUBLE)
USING CSV
OPTIONS (
  header = "true",
  delimiter = ";"
)
LOCATION "${dataset.bookstore}/books-csv"

-- COMMAND ----------

SELECT * FROM books_csv

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC ## Limitations of Non-Delta Tables

-- COMMAND ----------

DESCRIBE EXTENDED books_csv

-- COMMAND ----------

-- MAGIC %python
-- MAGIC files = dbutils.fs.ls(f"{dataset_bookstore}/books-csv")
-- MAGIC display(files)

-- COMMAND ----------

-- MAGIC %python
-- MAGIC (spark.read
-- MAGIC         .table("books_csv")
-- MAGIC       .write
-- MAGIC         .mode("append")
-- MAGIC         .format("csv")
-- MAGIC         .option('header', 'true')
-- MAGIC         .option('delimiter', ';')
-- MAGIC         .save(f"{dataset_bookstore}/books-csv"))

-- COMMAND ----------

-- MAGIC %python
-- MAGIC files = dbutils.fs.ls(f"{dataset_bookstore}/books-csv")
-- MAGIC display(files)

-- COMMAND ----------

SELECT COUNT(*) FROM books_csv

-- COMMAND ----------

REFRESH TABLE books_csv

-- COMMAND ----------

SELECT COUNT(*) FROM books_csv

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## CTAS Statements

-- COMMAND ----------

CREATE TABLE customers AS
SELECT * FROM json.`${dataset.bookstore}/customers-json`;

DESCRIBE EXTENDED customers;

-- COMMAND ----------

CREATE TABLE books_unparsed AS
SELECT * FROM csv.`${dataset.bookstore}/books-csv`;

SELECT * FROM books_unparsed;

-- COMMAND ----------

drop view books_tmp_vw;
drop table books;

-- COMMAND ----------

CREATE TEMP VIEW books_tmp_vw
   (book_id STRING, title STRING, author STRING, category STRING, price DOUBLE)
USING CSV
OPTIONS (
  path = "${dataset.bookstore}/books-csv/export_*.csv",
  header = "true",
  delimiter = ";"
);

CREATE TABLE books AS
  SELECT * FROM books_tmp_vw;
  
SELECT * FROM books

-- COMMAND ----------

DESCRIBE EXTENDED books

-- COMMAND ----------

-- MAGIC %md
-- MAGIC # hands on

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dataset_bookstore

-- COMMAND ----------

-- MAGIC %python
-- MAGIC files = dbutils.fs.ls(f"{dataset_bookstore}/customers-json")
-- MAGIC display(files)

-- COMMAND ----------

select * from json.`${dataset.bookstore}/customers-json/export_001.json`

-- COMMAND ----------

 select * from json.`dbfs:/mnt/demo-datasets/bookstore/customers-json` order by customer_id desc;

-- COMMAND ----------

select _metadata.* as source_file
from json.`${dataset.bookstore}/customers-json`

-- COMMAND ----------

select * from text.`${dataset.bookstore}/customers-json`

-- COMMAND ----------

create table books_csv
  (book_id int, title string, author string, category string, price double)
  using csv
  options (
    header "true",
    delimiter ";"
  )
  location "${datasets.bookstore}/books_csv"

-- COMMAND ----------

-- MAGIC %fs ls "dbfs:/mnt/demo-datasets/bookstore/books-csv"

-- COMMAND ----------

create table books_csv
  (book_id STRING, title STRING, author STRING, category STRING, price DOUBLE)
  using csv
  options (
    header "true",
    delimiter ";"
  )
  location "${datasets.bookstore}/books_csv"

-- COMMAND ----------

select *, _metadata.file_path as source_file
from csv.`dbfs:/mnt/demo-datasets/bookstore/books-csv`

-- COMMAND ----------

select * from books_csv;

-- COMMAND ----------

drop table books_csv;

-- COMMAND ----------

select * from books_csv

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dataset_bookstore

-- COMMAND ----------

-- # spark api for reading files

%python

(spark.read
  .table("books.csv")
  .write
  .mode("append")
  .format("csv")
  .option('header', 'true')
  .option('delimiter', ';')
  .save(f"{dataset_bookstore}/books_csv")
  )

-- COMMAND ----------

select count(*) from books_csv

-- COMMAND ----------

drop table customers;

-- COMMAND ----------

create table customers as
select * from json.`${dataset.bookstore}/customers-json`;

-- COMMAND ----------

-- 1. read temp view

create temp view books_tmp_vw
  (book_id string, title string, author string, category string, price double)
using csv
options(
  path = "${dataset.bookstore}/books-csv/export_*.csv",
  header = "true",
  delimiter = ";"
);

-- 2. create ctas from the view -> onto delta table
create table books as
select * from books_tmp_vw

-- COMMAND ----------

select * from books_tmp_vw

-- COMMAND ----------

show tables;

-- COMMAND ----------

describe extended books_unparsed
;

-- COMMAND ----------

create table easier_ctas_books as
select * from read_files(
  '${dataset.bookstore}/books-csv/export_*.csv',
  format => 'csv',
  header => 'true',
  delimiter => ';'
);

-- COMMAND ----------

select * from easier_ctas_books

-- COMMAND ----------


