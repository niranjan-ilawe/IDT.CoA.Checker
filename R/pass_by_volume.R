pass_by_volume = function(df) {

  # Fail if volume is different
  length_coa_file <- length(df %>% dplyr::filter(!is.na(sequence.coa)) %>% dplyr::pull(sequence.coa))

  no_of_matches <- length(df %>% dplyr::filter(vol_match) %>% dplyr::pull(sequence.coa))

  if(length_coa_file == no_of_matches) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}


