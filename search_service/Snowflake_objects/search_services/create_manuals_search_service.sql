create cortex search service if not exists manuals_search_service
on file_content
attributes appliance
warehouse = cortex_developer_wh
target_lag = '1 day'
embedding_model = 'snowflake-arctic-embed-l-v2.0'
as (
  select
    file_content,
    appliance
  from manuals_txt
);