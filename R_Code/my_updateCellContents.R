
# containerBarcode <- "96W152"
# containerType <-  "96 WELL PLATE"
# containerCellNum <- 25064734
# amount <- -1
# amountUnit <- "ml"
# concentration <- -1000
# concentrationUnit <- "mM"
# sampleLotBarcode <- "RE1-1"
# 
# account <- CoreAPIV2::coreAPI("account-BA-full.json")
# 
# login <- CoreAPIV2::authBasic(account)
# creds <- login$coreApi
# 


my_updateCellContents<-function (creds,containerType, containerBarcode, containerCellNum,
                                 sampleLotBarcode, amount, amountUnit, concentration, concentrationUnit,useVerbose = FALSE)
  
{
  
  
  
  sdkCmd<-jsonlite::unbox("update-cell")
  
  data<-list()
  
  
  data[["amount"]] <-jsonlite::unbox(amount)
  
  data[["amountUnit"]] <- jsonlite::unbox(amountUnit)
  
  data[["concentration"]] <- jsonlite::unbox(concentration)
  
  data[["concentrationUnit"]] <- jsonlite::unbox(concentrationUnit)
  
  
  
  
  data[["cellRefs"]] <- list(c(list(cellNum = jsonlite::unbox(""), containerRef = list(barcode =jsonlite::unbox(containerBarcode)),
                                    cellId = jsonlite::unbox(containerCellNum)) ) )
  
  
  data[["lotRef"]] <-list(barcode =jsonlite::unbox(sampleLotBarcode) )
  
  
  
  
  responseOptions<-c("CONTEXT_GET","MESSAGE_LEVEL_WARN","INCLUDE_CONTAINER_CELL_CONTENTS")
  
  
  
  
  logicOptions<-list()
  
  typeParam <- jsonlite::unbox(containerType)
  
  
  
  
  
  request<-list(request=list(sdkCmd=sdkCmd,data=data,typeParam =typeParam,
                             responseOptions=responseOptions,
                             logicOptions=logicOptions))
  
#  print(jsonlite::toJSON(request,pretty = T))
  
 # sdk_url <-  CoreAPI::buildUrl(creds)
 # sdk_url <- "http://na1test.platformforscience.com//sdk;jsessionid=223F687CE110EAE43A936D18A7B50149"
  
  sdk_url <- paste0(creds$scheme,"://",creds$coreUrl,"//sdk;jsessionid=",creds$jsessionId)
  
  cookie <-
    c(JSESSIONID = creds$jsessionId,
      AWSELB = creds$awselb)
  
  headers <- c(
    'Content-Type' = "application/json;x-www-form-urlencoded",
    Accept = "*/*"
  )
  
  
  
  # response<- CoreAPI::apiCall(coreApi,request,"json",useVerbose=useVerbose)
  
  response<-httr::POST(sdk_url,body = request, encode="json", httr::set_cookies(cookie),httr::add_headers(headers),
                                 httr::verbose(data_out = useVerbose, data_in = useVerbose,
                                               info = useVerbose, ssl = useVerbose)
  )
  
  
  list(entity=httr::content(response)$response$data,response=response)
  
}
