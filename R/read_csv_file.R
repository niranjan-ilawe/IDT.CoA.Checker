#' Read the user created CoA File
#'
#'
#'
#' @param file
#'
#' @return
#' @export
#'
#' @examples
read_csv_file = function(file) {

  raw_df <- vroom::vroom(file, delim = ",", .name_repair = janitor::make_clean_names, show_col_types = FALSE)

  if(all(c("plate_name","well_position","sequence_name","sequence") %in% colnames(raw_df))) {
    clean_df <- clean_plate_df(raw_df)
    return(clean_df)
  } else {
    warning('Expected columns not found.')
    return(NULL)
  }

}
