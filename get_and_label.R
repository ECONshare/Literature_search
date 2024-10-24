library(reticulate)
source("get_openalex.R")
source("openai_labeling.R")
# Extract all articles
all_articles <- get_openalex(n_pages = 10, 
                             articles_per_page = 200,
                             mailto = "INSERT_OWN_EMAIL",
                             filter = "default.search:PLS-SEM",
                             select = "abstract_inverted_index, doi, title",
                             remove_if_no_doi = TRUE) 
write.csv(all_articles, file = "no_label_pls_sem.csv")
# Label subset of articles
all_articles <- openai_labeling(all_articles = all_articles,
                                topic = "Paper with new original methodological 
                                         developments within PLS-SEM. The paper 
                                         should not be review of old methods, 
                                         but the original paper proposing the method",
                                n_labels = 50, # Maximum number of articles to label
                                n_positive = 5, # Desired number of positive matches
                                n_negative = 5, # Desired number of negative matches
                                api_key = "INSERT_OWN_OPENAI_API_KEY")

# Save results to .csv file for import to ASReview
write.csv(all_articles, file = "label_pls_sem.csv")