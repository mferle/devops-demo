--!jinja

-- create a database
use role sysadmin;
create or alter database {{env}}_appliances_db;
grant usage on database {{env}}_appliances_db to role cortex_developer;
use role cortex_developer;
