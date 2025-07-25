use role data_pipeline_developer;
use database dwh_db;
create or replace table ex.customer_ex as select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;