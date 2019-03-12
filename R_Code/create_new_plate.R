# account <- CoreAPIV2::coreAPI("Credentialsfreq.txt")

# login <- CoreAPIV2::authBasic(account)
# creds<- login$coreApi


# plate_df <- read.csv2("plate_template.csv",sep=",",stringsAsFactors = F)[,-1]

#lo <- CoreAPIV2::logOut(creds)

create_new_plate <- function(creds, plate_df) {


  # create data.frame of unique lots

  lots <- as.list(as.vector(t(plate_df)))

  lots_list <- as.list(unique(as.vector(t(plate_df))))

  lots_list <- lots_list[lots_list != ""]

  lots_list <- Filter(Negate(is.null), lots_list)
 
 # login <- CoreAPIV2::authBasic(account)
  

 # creds <- login$coreApi
  
  
  # lookup lot entity values

  lots_ids <- lapply(lots_list, function(x) {
    CoreAPIV2::getEntityByBarcode(creds, "ENTITY", x)$entity$Id
  })
  

  lots_df <- data.frame(lot_id = unlist(as.numeric(lots_ids)), barcode = unlist(lots_list), stringsAsFactors = F)

  # build full lot and ID df

  lots_full <- data.frame(cell = 1:96, barcode = as.vector(t(plate_df)))

  lots_full <- merge(lots_full, lots_df, all.x = T, by. = "barcode", by.y = "barcode")

  lots_full <- lots_full[order(lots_full$cell), ]
  row.names(lots_full) <- NULL

  # create new plate
  new_plate_type <- "96 WELL CELL CULTURE PLATE"

  new_plate <- CoreAPIV2::createEntity(creds, new_plate_type, body = NULL)

  # get full plate data

  new_plate_barcode <- new_plate$entity$Barcode

  resource <- new_plate_type


  headers <- c("Content-Type" = "application/json", accept = "application/json")


  query <- paste0("('", new_plate_barcode, "')?$expand=REV_IMPL_CONTAINER_CELL")


  print(query)


  new_plate <- CoreAPIV2::apiGET(coreApi = creds, resource = resource, query = URLencode(query), headers = headers, useVerbose = TRUE)

#  lo <- CoreAPIV2::logOut(creds)
  
  # get cellIDs of new plate

  cell_ids <- lapply(new_plate$content$REV_IMPL_CONTAINER_CELL, function(x) x$Id)


  # create dataframe of cells and lot

  fills <- cbind(lots_full, cell_id = as.numeric(unlist(cell_ids)))
  
  
  #account <- CoreAPI::coreAPI("Credentialsfreq.txt")

  
  #login<- CoreAPI::authBasic(account)
  #creds <- login$coreApi
  
  

  d <- apply(fills, 1, function(x) {
    ifelse(x[1] == "", NA,

          { c<- my_updateCellContents(creds,resource, new_plate_barcode, as.numeric(x[4]),
                                 x[1], -1, "mL", -1000, "mM",useVerbose = FALSE)
          Sys.sleep(.1)
          print(paste(x[4],x[1],httr::content(c$response)))
          
          c
          }
      )
  })

  
  
  
  d <- apply(fills, 1, function(x) {
    ifelse(x[1] == "", NA,
           
          print(paste(x[4],x[1]))
    )
  })
  
  
  

  
  return(new_plate_barcode)
}
