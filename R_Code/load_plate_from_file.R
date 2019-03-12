
# file_path <- "plate_template.csv"

# load_plate_from_file(file_path)

load_plate_from_file <- function(file_path) {
  raw_data <- read.csv2(file = file_path, header = T, stringsAsFactors = F, sep = ",")

  # create dataframe to hold results

  DF <- raw_data[, -1]

  # make all empties ""

  DF <- apply(DF, 2, function(x) {
    ifelse(is.na(x), "", x)
  })

  if (nrow(DF) * ncol(DF) != 96) stop("Did not read plate file properly, pleae chech you file")
  print(DF)

  # return data frame

  DF
}
