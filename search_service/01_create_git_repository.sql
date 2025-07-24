use role SYSADMIN;
create database ADMIN_DB;
create schema GIT_INTEGRATION;

-- continue to use the SYSADMIN role to keep the exercise simple
-- otherwise, create a custom role and grant it the CREATE GIT REPOSITORY ON SCHEMA privilege

-- create a Git repository using the API integration and the secret
create git repository DEVOPS_DEMO_REPO
  api_integration = DEVOPS_GIT_INTEGRATION
  ORIGIN = 'https://github.com/mferle/devops-demo'; 

-- fetch the latest from the Git repository
alter git repository DEVOPS_DEMO_REPO fetch;

-- show branches in the Git repository
show git branches in DEVOPS_DEMO_REPO;

-- list the files in the repository main branch
ls @DEVOPS_DEMO_REPO/branches/main;
