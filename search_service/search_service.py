import json
from snowflake.core import Root
from snowflake.snowpark.session import Session
from snowflake.cortex import complete

# connect to Snowflake
session = Session.builder.config("connection_name", "claude_connection").create()

# state the question
my_question = "How do I clean the water filter in the washing machine"
#my_question = "How do I make bread"
#my_question = "what is the power used by the oven at maximum temperature"

# instantiate the Root object
root = Root(session)

# configure the search_service object
search_service = (root
  .databases["home_appliances_db"]
  .schemas["manuals"]
  .cortex_search_services["manuals_search_service"]
)

# get the response: the search service returns the document(s) related to the question
resp = search_service.search(
  query=my_question,
  columns=["file_content", "appliance"],
  limit=1
)

results = json.loads(resp.to_json())["results"]
prompt_context = ""

# Build the context from the search results
for result in results:
    prompt_context += result["file_content"]
prompt_context = prompt_context.replace("'", "")

appliance = results[0]['appliance']

#print(prompt_context)
#print(appliance)

prompt = f"""
  Please answer the following question given the context.
  Question: {my_question}
  Context: {prompt_context}
  Provide the answer based only on the context. If the answer is not there, say so, and don't use external references. Use only the given context.
"""

summary = complete('claude-3-5-sonnet', prompt)

print(summary)

