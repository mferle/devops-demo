use role sysadmin;
use database dwh_db;
create or alter schema ex;
grant all on schema ex to role data_pipeline_developer;