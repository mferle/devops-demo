-- create a database
use role sysadmin;
create database home_appliances_db;
grant usage on database home_appliances_db to role cortex_developer;
use role cortex_developer;
