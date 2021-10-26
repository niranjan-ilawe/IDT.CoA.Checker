read_order_file <- function(file,
                            sheet_name = "PrimerMix Plate Order Form",
                            skip_rows = 34) {

  ext <- tools::file_ext(file)
  raw_df <- switch(ext,
         csv = vroom::vroom(file, delim = ",", show_col_types = FALSE),
         xlsx = readxl::read_excel(file,sheet = sheet_name,skip = skip_rows),
         validate("Invalid file; Please upload a .csv or .tsv file")
  )

  clean_df <- clean_plate_df(raw_df)

  return(clean_df)
}
