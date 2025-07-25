use database dwh_db;
use role data_pipeline_developer;
create or replace table EX.CUSTOMER_EX as
select * from snowflake_sample_data.tpch_sf1.customer;
