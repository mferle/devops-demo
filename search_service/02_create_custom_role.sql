-- create a custom role
use role useradmin;
create or alter role cortex_developer;

-- grant the role to SYSADMIN to preserve the role hierarchy
grant role cortex_developer to role SYSADMIN;

-- grant privileges that allow the cortex_developer role to use the GIT integration
use role SYSADMIN;
grant usage on database ADMIN_DB to role cortex_developer;
grant usage on schema ADMIN_DB.GIT_INTEGRATION to role cortex_developer;
grant read on git repository ADMIN_DB.GIT_INTEGRATION.DEMO_REPO to role cortex_developer;
grant write on git repository ADMIN_DB.GIT_INTEGRATION.DEMO_REPO to role cortex_developer;

-- create a warehouse for the cortex_developer role
create warehouse cortex_developer_wh with warehouse_size = 'xsmall';
grant usage on warehouse cortex_developer_wh to role cortex_developer;
