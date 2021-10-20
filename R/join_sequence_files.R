join_sequence_files <- function(coa_df, order_df) {

  df <- dplyr::full_join(coa_df, order_df, by = c("plate_name", "sequence_name", "well_row", "well_col"), suffix = c(".coa", ".order")) %>%
    dplyr::mutate(is_match = dplyr::if_else(tolower(sequence.order) == tolower(sequence.coa), TRUE, FALSE))

  return(df)
}
