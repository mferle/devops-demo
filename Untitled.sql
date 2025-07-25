USE SECONDARY ROLES ALL;

USE ROLE ENV_DATA_ENGINEER;
USE WAREHOUSE ENV_DATA_ENGINEER_WH;
USE DATABASE ENV_DWH_DB;
USE SCHEMA STG;

create stage ws_internal;

CREATE OR REPLACE PROJECT MF_DATA_PROJECT;

ALTER PROJECT MF_DATA_PROJECT
ADD VERSION V1
FROM
'@ENV_DWH_DB.STG.DEMO_REPO/branches/main';

EXECUTE PROJECT MF_DATA_PROJECT
using configuration dev
dry_run = true;

show projects;

show stages;

use role accountadmin;
select * from snowflake.account_usage.stages order by created desc;

use role accountadmin;

grant role accountadmin to user "MAJA.FERLE@IN516HT.COM";

show users;

alter user "MAJA.FERLE@IN516HT.COM" set default_secondary_roles = ('ALL');

select current_secondary_roles();

show users;

show grants to user "MAJA.FERLE@IN516HT.COM";

show grants to role JOKERJI;

use secondary roles all;

