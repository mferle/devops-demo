-- create a schema
use role sysadmin;
create or alter schema appliances_db.manuals;
grant all on schema appliances_db.manuals to role cortex_developer;
use role cortex_developer;
