test_that("able to join passing order and coa files", {
  coa_df <- read_coa_file("../../data/passing_eg1_coa_file.csv")
  order_df <- read_order_file("../../data/passing_eg1_order_file.xlsx")

  df <- join_sequence_files(coa_df, order_df)

  expect_equal(nrow(df), 1536)
  expect_equal(df %>% dplyr::filter(seq_match) %>% dplyr::pull(seq_match) %>% sum(), 1536)
})

test_that("able to join failing order and coa files", {
  coa_df <- read_coa_file("../../data/failed_eg_coa_file.csv")
  order_df <- read_order_file("../../data/failed_eg_order_file.xlsx")

  df <- join_sequence_files(coa_df, order_df)

  expect_equal(nrow(df), 3839)
  expect_equal(df %>% dplyr::filter(seq_match) %>% dplyr::pull(seq_match) %>% sum(), 1)
})
