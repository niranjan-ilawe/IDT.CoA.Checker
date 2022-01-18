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
clean_idt_coa_file = function(file) {

  ext <- tools::file_ext(file)
  raw_df <- switch(ext,
                   csv = vroom::vroom(file, delim = ",", show_col_types = FALSE),
                   xlsx = readxl::read_excel(file),
                   validate("Invalid file; Please upload a .csv or .xlsx file")
  )

  raw_df <- raw_df %>%
    janitor::clean_names()

  return(raw_df)

}
