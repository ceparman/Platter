# account <- CoreAPIV2::coreAPI("account-BA.json")

# login <- CoreAPIV2::authBasic(account)
# creds<- login$coreApi


# plate_barcode <- "96W137"


load_plate <- function(creds, plate_barcode) {



  # get plate with sample


  resource <- "96 WELL CELL CULTURE PLATE"


  headers <- c("Content-Type" = "application/json", accept = "application/json")




  query <- paste0("('", plate_barcode, "')?$expand=REV_IMPL_CONTAINER_CELL($expand=CONTENT($expand=IMPL_SAMPLE_LOT))")



  plate <- CoreAPIV2::apiGET(coreApi = creds, resource = resource, query = URLencode(query), headers = headers, useVerbose = TRUE)

  # extract sample lots



  lots <- lapply(plate$content$REV_IMPL_CONTAINER_CELL, function(x) {
    ifelse(length(x$CONTENT) == 0, "",
      x$CONTENT[[1]]$IMPL_SAMPLE_LOT$Barcode
    )
  })


  # create dataframe to hold results

  DF <- as.data.frame(matrix(unlist(lots), nrow = 8, ncol = 12, byrow = TRUE), stringsAsFactors = F)

  # return data frame

  DF
}
