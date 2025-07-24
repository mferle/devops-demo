use database dwh_db;
use role data_pipeline_developer;
create or replace view STG.CUSTOMER_STG as
select
    hash(c_custkey) as customer_hsh,
    c_custkey as ext_ref,
    c_name as customer_name,
    c_address as customer_address,
    c_nationkey,
    c_phone,
    c_acctbal,
    c_mktsegment,
    current_timestamp() as load_ts 
from DWH_DB.EX.CUSTOMER_EX;
