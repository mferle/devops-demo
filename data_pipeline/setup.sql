-- create a custom role
use role useradmin;
create role data_pipeline_developer;

-- grant the role to SYSADMIN to preserve the role hierarchy
grant role data_pipeline_developer to role SYSADMIN;

-- create a warehouse for the data_pipeline_developer role
use role sysadmin;
create warehouse data_pipeline_developer_wh with warehouse_size = 'xsmall';
grant usage on warehouse data_pipeline_developer_wh to role data_pipeline_developer;
