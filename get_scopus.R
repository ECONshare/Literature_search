library(httr2)
library(tidyverse)

##########
# Remember to be logged into the AU network
##########


#########
# Scopus - Author
########
req <- request("https://api.elsevier.com") %>%
  req_url_path("content/search/author") %>%
  req_url_query(query = "authlast(Einstein) and authfirst(Albert)",
                apiKey = 'INSERT_OWN_SCOPUS_API_KEY') %>%
  req_headers('Accept' = 'application/json') 

resp <- req %>%
  req_perform()
results <- resp %>%
  resp_body_json()
# Inspect results
results$`search-results`$`opensearch:totalResults`
results$`search-results`$`opensearch:Query`
#########
# Scopus - abstract 
########
req <- request("https://api.elsevier.com") %>%
  req_url_path("content/search/abstract") %>%
  req_url_query(query = "PLS-SEM",
                apiKey = 'INSERT_OWN_SCOPUS_API_KEY') %>%
  req_headers('Accept' = 'application/json') 

results <- req %>%
  req_perform()
results <- resp %>%
  resp_body_json()
# Inspect results
length(results$`search-results`$`opensearch:totalResults`[[1]])
results$`search-results`$`opensearch:itemsPerPage`
results$`search-results`$`opensearch:startIndex`
results$`search-results`$entry[[1]]



