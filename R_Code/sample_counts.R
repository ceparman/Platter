
# account <- CoreAPIV2::coreAPI("Credentialsfreq.txt")
# 
# login <- CoreAPIV2::authBasic(account)
# creds<- login$coreApi
# 
# sample_list <- as.list(c("TREATMENT","BLANK"))
# 
# 
# counts <- sample_counts(creds,sample_list)
# 
# lo<-CoreAPIV2::logOut(creds)

sample_counts <-function(creds,sample_list)
{

  
  
get_count <- function(creds,sample_type){

  # r<-CoreAPIV2::apiGET(
  #   coreApi = creds,
  #   resource = sample_type,
  #   query = query,
  #   headers = headers,
  #   useVerbose = TRUE
  # )
  # 
  
  headers <- c('Content-Type' = "application/json;odata.metadata=minimal", accept = "application/json")
  query <- "?$count=true"
  
  
  cookie <-c(JSESSIONID = creds$jsessionId,AWSELB = creds$awselb)
  
  url <- CoreAPIV2::buildUrl(coreApi = creds,resource = sample_type,query = query)
  
  
  r<-httr::GET(url = url,httr::add_headers(headers),httr::set_cookies(cookie))
  
  
  
  r <- httr::content(r,as = "parsed")
  
  entity_count <- r$'@odata.count'
  
  entity_count
}  


counts <- unlist(lapply (sample_list, function(x) get_count(creds,x)))

data.frame (sample_type = unlist(sample_list),counts=counts)

}

