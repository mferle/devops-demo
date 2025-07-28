-- ### DCM PROJECTS - PRIVATE PREVIEW - QUICKSTART ### 

-- #1 WORKSPACE SETUP
-- explore the content of the manifest file and the various definition FILES
-- The Manifest file contains the path to the definitions folder
-- The definition files contain various DEFINE statements for new entities, as well as GRANTS

-- Tip: use the split-screen to keep manifest and definition files left and this commands file on the right



-- #2 PROJECT OBJECT SETUP

-- ensure you are running version 9.20.x !!! for the following SQL commands
select current_version();


create database if not exists DCM_DEMO;
create schema if not exists DCM_DEMO.PROJECTS;

    
create dcm project if not exists DCM_DEMO.PROJECTS.DCM_PROJECT_DEV
    comment = 'for testing new project versions'
;
    
create dcm project if not exists DCM_DEMO.PROJECTS.DCM_PROJECT_PROD
;



alter project DCM_DEMO.PROJECTS.DCM_PROJECT_DEV 
    add version My_workspace_V1     --alias is optional (otherwise just doing version+1 with alias = NULL)
    from
    -- my workspace live version
    'snow://workspace/USER$.PUBLIC.DEFAULT$/versions/live/DCM_Project_Quickstart_1'

    -- workspace repo live version
    -- 'snow://workspace/USER$.PUBLIC."dex-demo-internal"/versions/live/DCM Projects/DCM_Project_Quickstart_1'
    
    -- repo clone    
    -- '@DCM_DEMO.PROJECTS.MY_GIT_REPO/branches/main/DCM_Project_Quickstart_1'    
;



-- #3A DRY_RUN: Test the latest version of project definitions with the DEV configuration (with json output)
execute dcm project DCM_DEMO.PROJECTS.DCM_PROJECT_DEV 
    plan
    using configuration DEV
    -- with version My_workspace_V1     --optional (otherwise using latest version)
;


-- #3B DRY_RUN with flow operator for tabular format of change log 
execute dcm project DCM_DEMO.PROJECTS.DCM_PROJECT_DEV 
    plan
    using configuration DEV

 -- flatten json output to table
    ->> with JSON_INPUT as (
            select parse_json($1) as OPERATIONS from $1) 
        select
            f.INDEX ::number as INDEX,
            f.value:operationType ::string as OPERATION_TYPE,
            coalesce( f.value:objectDomain, f.value:association) ::string as OBJECT_TYPE,
            coalesce( f.value:objectName, f.value:target:objectName) ::string as OBJECT_NAME,
            coalesce( f.value:details:properties, concat(f.value:subject:objectPrivilege,' on ',f.value:subject:objectName)) ::string as PROPERTIES,
            f.value:details:columns ::string as COLUMNS,
            f.value ::string as VALUE
        from
            JSON_INPUT,
            LATERAL FLATTEN(input => JSON_INPUT.OPERATIONS)f
        order by
            INDEX
;


-- #3C DRY_RUN with flow operator for AI-summarized change log 

execute dcm project DCM_DEMO.PROJECTS.DCM_PROJECT_DEV 
    plan
    using configuration DEV

    ->> select AI_COMPLETE(
            'CLAUDE-3-5-SONNET',
            concat('summarize these database changes: <review>', $1, '</review>')
            ) 
        from $1
        ;

    

-- #4 DEPLOY: Deploy the initial version of the demo project with the DEV configuration 
execute dcm project DCM_DEMO.PROJECTS.DCM_PROJECT_DEV 
    deploy
    using configuration DEV    

    -- flatten json output to table
    ->> with JSON_INPUT as (
            select parse_json($1) as OPERATIONS from $1) 
        select
            f.INDEX ::number as INDEX,
            f.value:operationType ::string as OPERATION_TYPE,
            coalesce( f.value:objectDomain, f.value:association) ::string as OBJECT_TYPE,
            coalesce( f.value:objectName, f.value:target:objectName) ::string as OBJECT_NAME,
            coalesce( f.value:details:properties, concat(f.value:subject:objectPrivilege,' on ',f.value:subject:objectName)) ::string as PROPERTIES,
            f.value:details:columns ::string as COLUMNS,
            f.value ::string as VALUE
        from
            JSON_INPUT,
            LATERAL FLATTEN(input => JSON_INPUT.OPERATIONS)f
        order by
            INDEX
;



-- #5 EDIT: Make changes to the project definitions 
    -- add a comment, change a schedule, remove a table, change the configuration values, etc. 
    -- then create a new version and run PLAN again to see the impact of your changes 

-- Note! breaking changes (like changing a column data type) are not supported in DEFINE statements.
    -- to implement breaking changes you can copy the new definition and run it as "create or replace ..." command outside of your project. 


alter project DCM_DEMO.PROJECTS.DCM_PROJECT_DEV 
    add version My_workspace_V2
    from 'snow://workspace/USER$.PUBLIC.DEFAULT$/versions/live/DCM_Project_Quickstart_1'
;

-- dry-run the new version
execute dcm project DCM_DEMO.PROJECTS.DCM_PROJECT_DEV 
    plan
    using configuration DEV
    with version My_workspace_V2
;

-- deploy the changes
execute dcm project DCM_DEMO.PROJECTS.DCM_PROJECT_DEV 
    deploy    
    using configuration DEV
    with version My_workspace_V2    -- specify the version to ensure definition state matches PLAN
;




-- #6 PLAN AND DEPLOY TO PROD 
-- dry-run the new version with the PROD configuration 

execute dcm project DCM_DEMO.PROJECTS.DCM_PROJECT_PROD 
    plan
    using configuration PROD    -- now with PROD config
    with version My_workspace_V2

    -- flatten json output to table
    ->> with JSON_INPUT as (
            select parse_json($1) as OPERATIONS from $1) 
        select
            f.INDEX ::number as INDEX,
            f.value:operationType ::string as OPERATION_TYPE,
            coalesce( f.value:objectDomain, f.value:association) ::string as OBJECT_TYPE,
            coalesce( f.value:objectName, f.value:target:objectName) ::string as OBJECT_NAME,
            coalesce( f.value:details:properties, concat(f.value:subject:objectPrivilege,' on ',f.value:subject:objectName)) ::string as PROPERTIES,
            f.value:details:columns ::string as COLUMNS,
            f.value ::string as VALUE
        from
            JSON_INPUT,
            LATERAL FLATTEN(input => JSON_INPUT.OPERATIONS)f
        order by
            INDEX
;

-- replace the PLAN keyword with DEPLOY and run again 




--- #7 SET OBJECTS FREE: unset an object from a project (without dropping it)

alter table DCM_PROJECT_DEV.RAW.ALL_ITEMS
    unset dcm project;

-- now remove TABLE_A from your project definition files before you deploy it again. 
-- Otherwise it will be re-integrated into the project



-- #8 DROP ALL ENTITIES: beware that removing definitions of existing objects will drop them
    -- edit the manifest file to include only definitions from "  - no_definitions/.* "
    -- now the project points to an empty folder, causing all existing objects to be dropped! 

-- always use dry-run to preview the outcome of a new deployment  
execute dcm project DCM_DEMO.PROJECTS.DCM_PROJECT_DEV 
    plan
    using configuration DEV

    -- flatten json output to table
    ->> with JSON_INPUT as (
            select parse_json($1) as OPERATIONS from $1) 
        select
            f.INDEX ::number as INDEX,
            f.value:operationType ::string as OPERATION_TYPE,
            coalesce( f.value:objectDomain, f.value:association) ::string as OBJECT_TYPE,
            coalesce( f.value:objectName, f.value:target:objectName) ::string as OBJECT_NAME,
            coalesce( f.value:details:properties, concat(f.value:subject:objectPrivilege,' on ',f.value:subject:objectName)) ::string as PROPERTIES,
            f.value:details:columns ::string as COLUMNS,
            f.value ::string as VALUE
        from
            JSON_INPUT,
            LATERAL FLATTEN(input => JSON_INPUT.OPERATIONS)f
        order by
            INDEX
;



-- #9 listing existing DCM projects and versions 

show dcm projects in database DCM_DEMO;

desc dcm project DCM_DEMO.PROJECTS.DCM_PROJECT_DEV;

show versions in dcm project DCM_DEMO.PROJECTS.DCM_PROJECT_DEV;



-- #10 DEMO CLEAN UP: 
    -- if you drop the project all defined and deployed entities will be "set free"
    -- to ensure all created demo entities (including warehouse and role) are removed from the account
    -- you can FIRST deploy the project with the NO_DEFINITIONS folder (for both DEV and PROD) before you drop the project itself

drop dcm project if exists DCM_DEMO.PROJECTS.DCM_PROJECT_DEV;

drop dcm project if exists DCM_DEMO.PROJECTS.DCM_PROJECT_PROD;

drop database if exists DCM_DEMO;


