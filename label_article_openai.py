import json
# Other libraries
from pydantic import BaseModel
from openai import OpenAI

#############
### System prompt
#############

system_prompt = """You are to review titles and abstracts of scientific articles 
to judge if the article is relevant for a literature review concerning:
{topic}
If the scientific article is relevant, return True, else return False.
"""
title_abstract = """
# This is the article title:
{title}
# This is the article abstract:
{abstract}
"""
class is_relevant(BaseModel):
    is_relevant: bool
#############
##### Function for sending the query
#############

def label_article_openai(topic, title, abstract, api_key, title_abstract = title_abstract, system_prompt = system_prompt):
    title_abstract = title_abstract.format(title = title, abstract = abstract)
    messages = [{"role": "user", "content": title_abstract}]
    # Define the system message
    system_prompt = system_prompt.format(topic = topic)
    system_message = {"role": "system", "content": system_prompt}
    # Insert the system message at the beginning of the messages list
    messages.insert(0, system_message)
  
    # The API call
    client = OpenAI(api_key = api_key)

    response = client.beta.chat.completions.parse(
      #model="gpt-4o-2024-08-06",
      model="gpt-4o-mini",
      messages=messages,
      response_format = is_relevant,
      temperature = 0,
      top_p = 1)

    # Check if any tools were called
    if response.choices[0].message.parsed:
        return response.choices[0].message.parsed.model_dump()
    else:
        # If no tools were called, return the general agent
        return is_relevant(
            is_relevant=False).model_dump()
  


