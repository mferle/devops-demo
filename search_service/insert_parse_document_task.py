from snowflake.snowpark import Session
from snowflake.core import Root
from snowflake.core.task import Task
from snowflake.core.task import Cron

# establish the session with Snowflake
session = Session.builder.config("connection_name", "demo_git_connection").create()

# create the root object
root = Root(session)

# create a task object
insert_parse_document_task = root.databases['APPLIANCES_DB'].schemas['MANUALS'].tasks['insert_parse_document_task'].fetch()
insert_parse_document_task.definition = "call insert_parse_document_sp()"
insert_parse_document_task.schedule = Cron("0 6 * * *", "UTC")

# create a task resource object
insert_parse_document_task_res = root.databases['APPLIANCES_DB'].schemas['MANUALS'].tasks['insert_parse_document_task']
insert_parse_document_task_res.suspend()
insert_parse_document_task_res.create_or_alter(insert_parse_document_task)

# comment and uncomment the following lines as needed
insert_parse_document_task_res.resume()
#insert_parse_document_task_res.execute()
