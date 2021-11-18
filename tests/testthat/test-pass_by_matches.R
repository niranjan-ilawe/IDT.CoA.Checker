test_that("Passing works", {
  coa <- read_coa_file("../../data/passing_eg1_coa_file.csv")
  order <- read_order_file("../../data/passing_eg1_order_file.xlsx")
  df <- join_sequence_files(coa,order)
  expect_equal(pass_by_matches(df), TRUE)
})

test_that("Failing works", {
  coa <- read_coa_file("../../data/failed_eg_coa_file.csv")
  order <- read_order_file("../../data/failed_eg_order_file.xlsx")
  df <- join_sequence_files(coa,order)
  expect_equal(pass_by_matches(df), FALSE)
})
