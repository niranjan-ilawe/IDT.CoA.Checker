test_that("able to join lprobe order and coa files", {
  coa_df <- clean_lprobe_coa_file("../../../Downloads/9198744_3000971_15_PL_01.xls", "../../../Downloads/9198744_3000971_15_PL_02.xls")
  write_csv(coa_df, "data/lprobe_coa_sample1.csv")

  order_df <- clean_lprobe_order_file("../../../Downloads/3000971_RM, L-Probe Pool Cycle 15_Eurofins Order Form.xlsx",
                                      sheet_name = "3000971_RM, L-Probe Pool Cycle ")
  write_csv(order_df, "data/lprobe_order_sample1.csv")

  coa_df <- read_csv_file("data/lprobe_coa_sample1.csv")
  order_df <- read_csv_file("data/lprobe_order_sample1.csv")

  df <- join_sequence_files(coa_df, order_df)

  expect_equal(nrow(df), 171)
  expect_equal(df %>% dplyr::filter(seq_match) %>% dplyr::pull(seq_match) %>% sum(), 169)
})
