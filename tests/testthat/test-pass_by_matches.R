test_that("Passing works IDT version 1", {
  coa <- read_csv_file("../../data/passing_eg1_coa_file.csv")
  order <- read_csv_file("../../data/passing_eg1_order_file.csv")
  df <- join_sequence_files(coa,order)
  expect_equal(pass_by_matches(df), TRUE)
})

test_that("Failing works", {
  coa <- read_csv_file("../../data/failed_eg_coa_file.csv")
  order <- read_csv_file("../../data/failed_eg_order_file.csv")
  df <- join_sequence_files(coa,order)
  expect_equal(pass_by_matches(df), FALSE)
})
