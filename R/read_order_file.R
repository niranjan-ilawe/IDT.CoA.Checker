read_order_file <- function(file,
                            sheet_name = "PrimerMix Plate Order Form",
                            skip_rows = 34) {

  raw_df <- readxl::read_excel(file,
                               sheet = sheet_name,
                               skip = skip_rows)

  clean_df <- clean_plate_df(raw_df)

  return(clean_df)
}
