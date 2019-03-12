

update_plate <- function(creds, plate_barcode, plate_df) {


  # create data.frame of unique lots

  lots <- as.list(as.vector(t(plate_df)))

  lots_list <- as.list(unique(as.vector(t(plate_df))))

  lots_list <- lots_list[lots_list != ""]


  # lookup lot entity values

  lots_ids <- lapply(lots_list, function(x) {
    c <- CoreAPIV2::getEntityByBarcode(creds, "ENTITY", x)$entity$Id
  })

  lots_df <- data.frame(lot_id = unlist(as.numeric(lots_ids)), barcode = unlist(lots_list), stringsAsFactors = F)

  # build full lot and ID df

  lots_full <- data.frame(cell = 1:96, barcode = as.vector(t(plate_df)))

  lots_full <- merge(lots_full, lots_df, all.x = T, by. = "barcode", by.y = "barcode")

  lots_full <- lots_full[order(lots_full$cell), ]
  row.names(lots_full) <- NULL

  # get plate info
  plate_type <- "96 WELL CELL CULTURE PLATE"



  resource <- plate_type


  headers <- c("Content-Type" = "application/json", accept = "application/json")


  query <- paste0("('", plate_barcode, "')?$expand=REV_IMPL_CONTAINER_CELL")


  print(query)


  plate <- CoreAPIV2::apiGET(coreApi = creds, resource = resource, query = URLencode(query), headers = headers, useVerbose = TRUE)

  # get cellIDs of new plate

  cell_ids <- lapply(plate$content$REV_IMPL_CONTAINER_CELL, function(x) x$Id)


  # create dataframe of cells and lot

  fills <- cbind(lots_full, cell_id = as.numeric(unlist(cell_ids)))

  d <- apply(fills, 1, function(x) {
    ifelse(x[1] == "",NA,

           my_updateCellContents(creds,resource, plate_barcode, as.numeric(x[4]),
                                 x[1], -1, "mL", -1000, "mM",useVerbose = FALSE)
           
    )
  })

  return(plate_barcode)
}
