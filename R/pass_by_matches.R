pass_by_matches = function(df) {
  ## Say Pass if all sequences in CoA match with Order file

  length_coa_file <- length(df %>% dplyr::filter(!is.na(sequence.coa)) %>% dplyr::pull(sequence.coa))

  no_of_matches <- length(df %>% dplyr::filter(is_match) %>% dplyr::pull(sequence.coa))

  if(length_coa_file == no_of_matches) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
