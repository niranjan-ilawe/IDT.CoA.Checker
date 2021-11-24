clean_idt_order_file <- function(file, sheet_name) {

  xl <- readxl::read_excel(file, sheet = sheet_name, col_names = FALSE)

  # Get column names from the row that has the Sequence string
  sequence_row <- xl %>% dplyr::filter_all(dplyr::any_vars(. == "Sequence"))
  # Set columns names from above to the df
  colnames(xl) <- sequence_row

  xl <- xl %>%
    janitor::clean_names() %>%
    # Choose only column names of interest. This is necessary since in the next step we want to drop partially empty rows
    dplyr::select(dplyr::matches(c("plate", "well", "sequence", "conc", "volume", "buffer"))) %>%
    tidyr::drop_na() %>%
    # The row with column names is repeated so drop first row
    dplyr::slice(2:dplyr::n())

  return(xl)
}

