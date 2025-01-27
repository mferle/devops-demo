-- create an internal stage
create stage appliances_db.manuals.manuals_stg 
  directory = (enable = true)
  encryption = (type = 'SNOWFLAKE_SSE');
