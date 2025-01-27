-- create a virtual warehouse
use role sysadmin;
create warehouse cortex_developer_wh with warehouse_size = 'xsmall';
grant usage on warehouse cortex_developer_wh to role cortex_developer;
use role cortex_developer;
