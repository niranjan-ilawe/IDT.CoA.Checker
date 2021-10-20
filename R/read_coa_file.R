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
read_coa_file = function(file) {

  raw_df <- readr::read_csv(file,
                            col_types = list(
                              plate_name    = readr::col_character(),
                              well_position = readr::col_character(),
                              sequence_name = readr::col_character(),
                              sequence      = readr::col_character()
                            ))

  if(any(colnames(raw_df) == c("plate_name","well_position","sequence_name","sequence"))) {
    clean_df <- clean_plate_df(raw_df)
    return(clean_df)
  } else {
    print('The columns in the CoA file should be named "plate_name","well_position","sequence_name","sequence"')
    return(NULL)
  }

}
