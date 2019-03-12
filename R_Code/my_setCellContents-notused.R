

my_setCellContents <- function(creds, barcode, cellID, sampleLotID, amount, amountUnit, conc, concUnit, useVerbose = FALSE) {
  resource <- paste0("CONTAINER('", barcode, "')/pfs.Container.SetCellContents")


  body <- list()





  cells <-
    list(c(
      list(
        cellId = jsonlite::unbox(cellID),
        amount = jsonlite::unbox(amount),
        amountUnit = jsonlite::unbox(amountUnit),



        contents = list(c(
          list(
            lotId = jsonlite::unbox(sampleLotID),
            concentration = jsonlite::unbox(conc),
            concentrationUnit = jsonlite::unbox(concUnit)
          )
        ))
      )
    ))


  body[["cells"]] <- cells





  jsonlite::toJSON(body, pretty = TRUE, auto_unbox = T)



  header <- c("Content-Type" = "application/json")


  response <- CoreAPIV2::apiPOST(creds, resource, body, headers = header, encode = "json")

  list(entity = httr::content(response), response = response)
}
