# Literature Search and Labeling with OpenAI

This repository provides tools to streamline literature search by labeling each article as *relevant* or *irrelevant* to a user-defined topic of interest. The labeling is based on article titles and abstracts, using OpenAI's API to assist in determining relevance.

## Contents

### 1. `get_and_label.R`
- **Purpose:** This is the primary script to run without needing to delve into other scripts' specifics.
- **Functionality:** It fetches metadata from a user-defined number of articles on OpenAlex (openalex.org), labels each article's relevance using OpenAI's API, and saves the output as a `.csv` file.
  
### 2. `examples_get_data.R`
- **Purpose:** Demonstrates usage of the repository functions.
- **Functionality:**
  - Shows how to fetch article metadata from OpenAlex’s API and transform the results into an R dataframe.
  - Provides examples of single and multiple label assignments to articles by calling OpenAI’s API (requires an OpenAI API key).

### 3. `get_openalex.R`
- **Purpose:** Function to fetch metadata from multiple pages of search results on OpenAlex.
- **Functionality:** Extracts metadata from OpenAlex across multiple pages for comprehensive literature gathering.

### 4. `label_article_openai.py`
- **Purpose:** Subfunction to label a single article.
- **Functionality:** This function constructs a prompt for OpenAI’s API, incorporating the user-defined topic of interest and the article’s title and abstract in the message thread. The output is a binary variable `is_relevant`, indicating relevance.

### 5. `label_article_openai2.py`
- **Purpose:** Enhanced version of `label_article_openai.py`.
- **Functionality:** Returns multiple variables—`is_relevant`, `relevance_certainty`, and `relevant_keywords`—providing finer granularity in labeling.

### 6. `openai_labeling.R`
- **Purpose:** Labels articles in bulk, using data stored in an R dataframe.
- **Functionality:** Processes an R dataframe, where each row contains an article’s title, abstract, and DOI. You can specify the maximum number of articles to label and set criteria for stopping based on the number of relevant/irrelevant articles identified.
