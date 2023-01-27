#' Title
#'
#' @param file1
#' @param file2
#'
#' @return
#' @export
#'
#' @examples
clean_lprobe_coa_file <- function(file1, file2) {
  ext <- tools::file_ext(file1)
  raw_df1 <- switch(ext,
                   csv = vroom::vroom(file1, delim = ",", show_col_types = FALSE, skip = 3),
                   xlsx = readxl::read_excel(file1, skip = 3),
                   xls = readxl::read_excel(file1, skip = 3),
                   validate("Invalid file; Please upload a .csv or .xlsx file")
  )
  raw_df2 <- switch(ext,
                    csv = vroom::vroom(file2, delim = ",", show_col_types = FALSE, skip = 3),
                    xlsx = readxl::read_excel(file2, skip = 3),
                    xls = readxl::read_excel(file2, skip = 3),
                    validate("Invalid file; Please upload a .csv or .xlsx file")
  )

  plate_name1 <- switch(ext,
                    xls = readxl::read_excel(file1),
                    validate("Invalid file; Please upload a .csv or .xlsx file")
  )

  plate_name1 <- plate_name1 %>%
    janitor::clean_names() %>%
    dplyr::select(x10x_genomics_inc) %>%
    head(1) %>%
    dplyr::pull(x10x_genomics_inc)

  plate_name2 <- switch(ext,
                    xls = readxl::read_excel(file2),
                    validate("Invalid file; Please upload a .csv or .xlsx file")
  )
  plate_name2 <- plate_name2 %>%
    janitor::clean_names() %>%
    dplyr::select(x10x_genomics_inc) %>%
    head(1) %>%
    dplyr::pull(x10x_genomics_inc)

  raw_df1 <- raw_df1 %>%
    janitor::clean_names() %>%
    dplyr::rename(sequence_name = name,
                  well_position = loc) %>%
    dplyr::select(sequence_name, sequence, well_position) %>%
    dplyr::mutate(plate_name = plate_name1)

  raw_df2 <- raw_df2 %>%
    janitor::clean_names() %>%
    dplyr::rename(sequence_name = name,
                  well_position = loc) %>%
    dplyr::select(sequence_name, sequence, well_position) %>%
    dplyr::mutate(plate_name = plate_name2)

  raw_df <- dplyr::bind_rows(raw_df1, raw_df2) %>%
    tidyr::drop_na(sequence) %>%
    dplyr::mutate(concentration = 0,
           volume = 0,
           sequence_name = paste0(sequence_name, 'c_3DO'))

  return(raw_df)
}
