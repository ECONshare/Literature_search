#install.packages("httr2")
#install.packages("dplyr")
library(dplyr)
library(httr2)
# Get full dataset
get_openalex <- function(n_pages, articles_per_page, mailto, filter, select, remove_if_no_doi){
  if (articles_per_page > 200) {
    stop("No more than 200 articles per page")
  }
  if (select != "abstract_inverted_index, doi, title") {
    stop("This function can currently only select abstract_inverted_index, doi, title. Modify section 'Prepare dataframe for articles' and 'Put each article in its own row' in this function to change the variables to select")
  }
  # Handle nulls
  nulls_as_text <- function(x){
    if(is.null(x)){""}else{x}
  }
  # Loop over pages
  for (p in 1:n_pages) {
    # OpenAlex
    req <- request("https://api.openalex.org/works") %>%
      req_url_query(page = as.character(p),
                    `per-page` = as.character(articles_per_page),
                    filter = filter,
                    select = select,
                    mailto = mailto)
    resp <- req %>%
      req_perform()
    results <- resp %>%
      resp_body_json()
    # Number of results
    n_resp <- length(results$results)
    # Prepare dataframe for articles
    df <- data.frame(abstract = rep("", times = n_resp),
                     doi = rep("", times = n_resp),
                     title = rep("", times = n_resp),
                     included = rep(NA, times = n_resp)) %>%
      as_tibble()
    # Put each article in its own row
    for (i in 1:n_resp) {
      df[i,"abstract"] <- nulls_as_text(paste(names(results$results[[i]]$abstract_inverted_index), collapse = " "))
      df[i,"doi"] <- nulls_as_text(results$results[[i]]$doi)
      df[i,"title"] <- nulls_as_text(results$results[[i]]$title)
    }
    if (p == 1) {# Create new df if first iteration
      all_articles <- df
    }else{# All other iterations, append to all_articles
      all_articles <- rows_append(all_articles, df)
    }
    
  }
  # Should we remove articles with no doi
  if(remove_if_no_doi == TRUE){
    all_articles <- all_articles[all_articles$doi != "",]
  }
  # Remove duplicate doi (but not empty doi)
  all_articles <- all_articles[which(! (duplicated(all_articles$doi) & (all_articles$doi != "")) ),]
  # Return results
  return(all_articles)
}
