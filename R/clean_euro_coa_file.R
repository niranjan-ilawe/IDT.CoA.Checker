#' Read the raw CoA File
#'
#'
#'
#' @param file
#'
#' @return
#' @export
#'
#' @examples
clean_euro_coa_file = function(file) {

  ext <- tools::file_ext(file)
  raw_df <- switch(ext,
                   csv = vroom::vroom(file, delim = ",", show_col_types = FALSE),
                   xlsx = readxl::read_excel(file),
                   xls = readxl::read_excel(file),
                   validate("Invalid file; Please upload a .csv or .xlsx file")
  )

  raw_df <- raw_df %>%
    janitor::clean_names() %>%
    dplyr::rename(sequence_name = seq_name,
                  sequence = seq_5_to_3,
                  well_position = well)

  return(raw_df)

}
