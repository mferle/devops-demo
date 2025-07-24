-- create a DATABASE
use role sysadmin;
use database dwh_db;
create or alter schema stg;
grant all on schema stg to role data_pipeline_developer;