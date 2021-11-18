test_that("Volume Passes", {
  coa <- read_coa_file("../../data/passing_eg1_coa_file.csv")
  order <- read_order_file("../../data/passing_eg1_order_file.xlsx")
  df <- join_sequence_files(coa,order)
  expect_equal(pass_by_volume(df), TRUE)
})

test_that("Volume Fails", {
  coa <- read_coa_file("../../data/wrong_vol_conc_coa_file.csv")
  order <- read_order_file("../../data/wrong_vol_conc_order_file.xlsx")
  df <- join_sequence_files(coa,order)
  expect_equal(pass_by_volume(df), FALSE)
})
