--!jinja

create or alter table {{env}}_appliances_db.manuals.manuals_txt (
    file_name varchar,
    appliance varchar,
    file_content varchar
);
