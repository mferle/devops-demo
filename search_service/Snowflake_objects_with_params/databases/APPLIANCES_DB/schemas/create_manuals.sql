--!jinja

-- create a schema
use role sysadmin;
create or alter schema {{env}}_appliances_db.manuals;
grant all on schema {{env}}_appliances_db.manuals to role cortex_developer;
use role cortex_developer;
