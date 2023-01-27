#' Read general CoA files
#'
#' @param file
#'
#' @return A dataframe
#' @export
#'
#' @examples
#' df <- read_gen_coa(file = "data/eg1_coa.csv")
read_gen_coa <- function(file) {

  # read entire coa file, clean column names, extract relevant column names
  df <- vroom::vroom(file = file) %>%
    janitor::clean_names() %>%
    dplyr::select(dplyr::matches(c("sequence", "conc", "volume", "buffer"))) %>%
    tidyr::drop_na(sequence_name) %>%
    dplyr::mutate(conc = as.numeric(str_extract(conc,"[0-9]+")),
                  volume = as.numeric(str_extract(volume, "[0-9]+")))

  # generate filled sequence notes column if empty
  if(any(is.na(df$sequence_notes))) {
    df <- df %>%
      mutate(sequence_notes = str_extract(sequence_name, "^\\d+"),
             sequence_name = str_remove(sequence_name, "^\\d+,"),
             sequence_name = str_trim(sequence_name, side = "both"))
  }

  return(df)
}
