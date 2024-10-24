library(reticulate)
source_python("label_article_openai.py")

openai_labeling <- function(all_articles, topic, n_labels, n_positive, n_negative, api_key){
  count_positive <- 0
  count_negative <- 0
  for (i in 1:n_labels) {
    # Stop if desired number of positive and negative articles are labelled
    if ((count_positive >= n_positive) & (count_negative >= n_negative) ) {
      break
    }
    # Label an article
    all_articles$included[[i]] <- label_article_openai(topic = topic, 
                                                     title = all_articles$title[i], 
                                                     abstract = all_articles$abstract[i], 
                                                     api_key = api_key)$is_relevant*1
    # Count positive and negative labelled articles
    if (all_articles$included[i]) {
      count_positive <- count_positive + 1
    }else{
      count_negative <- count_negative + 1
    }
    
    print(paste0(i, " articles labelled out of which ", count_positive, " have a match and ", count_negative, " do not have a match"))
    
  }
  return(all_articles)
}