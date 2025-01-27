-- create an internal stage
create or alter stage appliances_db.manuals.manuals_stg 
  directory = (enable = true)
  encryption = (type = 'SNOWFLAKE_SSE');
