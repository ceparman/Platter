

run_query <- function(creds, input, selected_sample) {
  # Run a query for samples based on inputs

  headers <- c("Content-Type" = "application/json;odata.metadata=minimal", accept = "application/json;odata.metadata=full")


  switch(selected_sample,

    "TREATMENT" = {
      resource <- "TREATMENT"


      # parse inputs

      params <- list(
        TRT = c(
          as.numeric(str_split(input$trt_num, " ")[[1]]),
          as.numeric(str_split(input$trt_num, " ")[[2]])
        ),
        
        ACTIVE = input$active
      )


      
      
      # build query
      
      query <- paste0("?$filter=Sequence le ", params$TRT[2] +1 )
      
      query <- paste0(query, " and Sequence ge ", max(params$TRT[1]-1,0))
      
      if(params$ACTIVE) {
        query <- paste0(query, " and Active eq TRUE")
      }
      
      query <- paste0(query, "&$expand=SAMPLE_LOT")
      
      print(query)
      
      headers <- c("Content-Type" = "application/json;odata.metadata=minimal", accept = "application/json;odata.metadata=full")
      
      #needs to be fixed for over 100 samples at some point
      
      samples <- CoreAPIV2::apiGET(coreApi = creds, resource = resource, query = URLencode(query), headers = headers, useVerbose = TRUE)
      
      lots <- character()
      conc <- character()
      varied_comp <- character()
      small_mol_1 <- character()
      small_mol_2 <- character()
      small_mol_3 <- character()
      small_mol_4 <- character()
      
      for( i in 1:length(samples$content))
        
      {
        
        isample <- samples$content[[i]]
        
        
        for (j in 1:length(isample$SAMPLE_LOT))
          
        { jlot <- isample$SAMPLE_LOT[[j]]
        lots <- c(lots,jlot$Barcode)    
        #get the lot
        
        jfull_lot <- CoreAPIV2::getEntityByBarcode(creds,"TREATMENT_LOT",jlot$Barcode)$entity
        
        conc         <-c(conc,        ifelse(is.null(jfull_lot$FREQ_VARIED_COMPOUND_CONC),"NA",jfull_lot$FREQ_VARIED_COMPOUND_CONC))
        varied_comp <- c(varied_comp, ifelse(is.null(jfull_lot$FREQ_VARIED_COMPOUND_CONC),"NA", jfull_lot$FREQ_VARIED_COMPOUND_CONC ))
        small_mol_1 <- c(small_mol_1, ifelse(is.null(jfull_lot$FREQ_COMPOUND1),"NA", jfull_lot$FREQ_COMPOUND1))
        small_mol_2 <- c(small_mol_2, ifelse(is.null(jfull_lot$FREQ_COMPOUND2),"NA", jfull_lot$FREQ_COMPOUND2))
        small_mol_3 <- c(small_mol_3, ifelse(is.null(jfull_lot$FREQ_COMPOUND3),"NA",jfull_lot$FREQ_COMPOUND3 ))
        small_mol_4 <- c(small_mol_4, ifelse(is.null(jfull_lot$FREQ_COMPOUND4),"NA", jfull_lot$FREQ_COMPOUND4))
        
        
        
        }
        
      }
      
      
      
      sampledf <- data.frame(
        Barcode = lots,
        varied_comp = varied_comp,
        conc = conc,
        small_mol_1 = small_mol_1,
        small_mol_2 = small_mol_2,
        small_mol_3 = small_mol_3,
        small_mol_4 = small_mol_4,
        
        stringsAsFactors = F
      )
      
      
      
      
      
      
      
    },

    "BLANK" = {
      resource <- "BLANK"

  
      query <-"?$expand=SAMPLE_LOT"

      print(query)


      samples <- CoreAPIV2::apiGET(coreApi = creds, resource = resource, query = URLencode(query), headers = headers, useVerbose = TRUE)


      # determine which samples have lots and get first lot if available

      lots <- unlist(lapply(samples$content, function(x) {
        ifelse(length(x$SAMPLE_LOT) > 0, x$SAMPLE_LOT[[1]]$Barcode, NA)
      }))


      sampledf <- data.frame(
        Barcode = unlist(lapply(samples$content, function(x) x$Barcode))
      )
    }
  )





  sampledf
}
