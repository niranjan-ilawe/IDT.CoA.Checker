#' Title
#'
#' @param file
#' @param sheet_name
#'
#' @return
#' @export
#'
#' @examples
clean_lprobe_order_file <- function(file, sheet_name) {

  xl <- readxl::read_excel(file, sheet = sheet_name, col_names = FALSE, skip = 1) %>%
    janitor::clean_names()

  # set Column names
  colnames(xl) <- c("plate_name", 'well_position', 'sequence_name', 'sequence')


  xl <- xl %>%
    tidyr::drop_na() %>%
    dplyr::mutate(concentration = 0,
           volume = 0)

  return(xl)
}

