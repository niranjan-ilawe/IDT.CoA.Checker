clean_plate_df <- function(df) {
  df <- df %>%
    janitor::clean_names() %>%
    # choose relevant columns
    dplyr::select(dplyr::matches(c("plate", "well", "sequence", "conc", "volume"))) %>%
    # compress the sequences i.e. remove all spaces
    dplyr::mutate(sequence = stringr::str_replace_all(sequence, " ", ""),
                  # replace (N1) by (N)
                  sequence = stringr::str_replace_all(sequence, "N1", "N"),
                  # replace brackets
                  # sequence = stringr::str_replace_all(sequence, "\\(|\\)", "")) %>%
    ) %>%
    # convert well_position to rows and columns
    # since sometimes the well_position is recorder as A01 and sometimes A1
    # standardizing how data is stored
    dplyr::mutate(well_row = stringr::str_extract(well_position, pattern = "[aA-zZ]"),
                  well_col = as.numeric(stringr::str_extract(well_position, pattern = "[0-9]+"))) %>%
    #dplyr::select(-well_position) %>%
    dplyr::filter(!is.na(sequence))

  conc_name <- stringr::str_subset(colnames(df), "conc")
  vol_name <- stringr::str_subset(colnames(df), "volume")
  df <- df %>%
    dplyr::rename(concentration = conc_name,
                  volume = vol_name)

  return(df)
}
