from snowflake.snowpark import Session
from snowflake.snowpark.functions import sproc

# establish the session with Snowflake
#session = Session.builder.config("connection_name", "demo_git_connection").create()

# register a permanent stored procedure
@sproc(is_permanent=True, 
       name="insert_parse_document_sp", 
       replace=True, 
       stage_location="@appliances_db.manuals.snowpark_stg", 
       packages=['snowflake-snowpark-python==1.24.0'])
def insert_parse_document(session: Session) -> str:
    mode_str = r"{'mode': 'OCR'}"
    session.sql(f"""
        insert into appliances_db.manuals.manuals_txt (file_name, appliance, file_content)
        select
            relative_path as file_name,
            regexp_substr(relative_path, '^[a-z]*') as appliance,
            SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
                @manuals_stg,
                relative_path,
                {mode_str}):content::varchar as file_content
            from directory(@appliances_db.manuals.manuals_stg)
    """).collect()
    return("Success")

#df = session.sql("call insert_parse_document_sp()")
#df.show()

#session.close()