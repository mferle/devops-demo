define role DCM_PROJECT_{{role}}_READ;
grant role DCM_PROJECT_{{role}}_READ to user JSOMMERFELD;   -- replace with your user


grant USAGE on database DCM_PROJECT_{{db}}         to role DCM_PROJECT_{{role}}_READ;

grant USAGE on schema DCM_PROJECT_{{db}}.RAW       to role DCM_PROJECT_{{role}}_READ;
grant USAGE on schema DCM_PROJECT_{{db}}.ANALYTICS to role DCM_PROJECT_{{role}}_READ;
grant USAGE on schema DCM_PROJECT_{{db}}.SERVE     to role DCM_PROJECT_{{role}}_READ;
grant USAGE on warehouse DCM_PROJECT_WH_{{db}}     to role DCM_PROJECT_{{role}}_READ;



define warehouse DCM_PROJECT_WH_{{db}}
with 
    warehouse_size = '{{wh_size}}'
    auto_suspend = 5
    comment = 'For Quickstart Demo of DCM Projects PrPr'
;


    