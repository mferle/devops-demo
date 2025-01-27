execute immediate from '../Snowflake_objects/databases/create_appliances_db.sql';
execute immediate from '../Snowflake_objects/databases/schemas/create_manuals.sql';
execute immediate from '../Snowflake_objects/databases/schemas/stages/create_manuals_stg.sql';
execute immediate from '../Snowflake_objects/databases/schemas/tables/create_manuals_txt.sql';

-- snow git fetch DEMO_REPO --database ADMIN_DB --schema GIT_INTEGRATION
-- snow git list-branches DEMO_REPO --database ADMIN_DB --schema GIT_INTEGRATION
-- snow git list-files @DEMO_REPO/branches/main/ --database ADMIN_DB --schema GIT_INTEGRATION
-- snow git execute @DEMO_REPO/branches/main//search_service/Snowflake_objects/deploy_objects.sql --database ADMIN_DB --schema GIT_INTEGRATION