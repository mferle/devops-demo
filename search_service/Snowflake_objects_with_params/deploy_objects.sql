SET ENV = 'TST';

execute immediate from '../Snowflake_objects_with_params/databases/APPLIANCES_DB/create_appliances_db.sql' USING (env => $ENV);
execute immediate from '../Snowflake_objects_with_params/databases/APPLIANCES_DB/schemas/create_manuals.sql' USING (env => $ENV);
execute immediate from '../Snowflake_objects_with_params/databases/APPLIANCES_DB/schemas/MANUALS/stages/create_manuals_stg.sql' USING (env => $ENV);
execute immediate from '../Snowflake_objects_with_params/databases/APPLIANCES_DB/schemas/MANUALS/stages/create_snowpark_stg.sql' USING (env => $ENV);
execute immediate from '../Snowflake_objects_with_params/databases/APPLIANCES_DB/schemas/MANUALS/tables/create_manuals_txt.sql' USING (env => $ENV);

-- snow git fetch DEMO_REPO --database ADMIN_DB --schema GIT_INTEGRATION
-- snow git execute @DEMO_REPO/branches/main/search_service/Snowflake_objects_with_params/deploy_objects.sql --database ADMIN_DB --schema GIT_INTEGRATION
