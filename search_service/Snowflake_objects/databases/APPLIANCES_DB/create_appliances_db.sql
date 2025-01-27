-- create a database
use role sysadmin;
create or alter database appliances_db;
grant usage on database appliances_db to role cortex_developer;
use role cortex_developer;
