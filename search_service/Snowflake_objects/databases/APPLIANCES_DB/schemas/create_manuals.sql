-- create a schema
use role sysadmin;
create or alter schema appliances_db.manuals;
grant all on schema manuals to role cortex_developer;
use role cortex_developer;
