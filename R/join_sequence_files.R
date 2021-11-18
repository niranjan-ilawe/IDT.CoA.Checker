join_sequence_files <- function(coa_df, order_df) {

  df <- dplyr::full_join(coa_df, order_df, by = c("plate_name", "sequence_name", "well_row", "well_col"), suffix = c(".coa", ".order")) %>%
    dplyr::mutate(seq_match = dplyr::if_else(tolower(sequence.order) == tolower(sequence.coa), TRUE, FALSE),
                  vol_match = dplyr::if_else(volume.coa >= volume.order & volume.coa <= volume.order + 20, TRUE, FALSE),
                  conc_dev = abs((concentration.coa-concentration.order)/concentration.order)*100,
                  conc_match = dplyr::if_else(conc_dev < 20, TRUE, FALSE)) %>%
    dplyr::select(plate_name, sequence_name, well_position.coa, sequence.coa,
           well_position.order, sequence.order, seq_match, concentration.coa,
           concentration.order, conc_match, volume.coa, volume.order, vol_match)

  return(df)
}
