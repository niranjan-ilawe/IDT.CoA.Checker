test_that("Volume Passes", {
  coa <- read_csv_file("../../data/passing_eg1_coa_file.csv")
  order <- read_csv_file("../../data/passing_eg1_order_file.csv")
  df <- join_sequence_files(coa,order)
  expect_equal(pass_by_conc(df), TRUE)
})

test_that("Volume Fails", {
  coa <- read_csv_file("../../data/wrong_vol_conc_coa_file.csv")
  order <- read_csv_file("../../data/wrong_vol_conc_order_file.csv")
  df <- join_sequence_files(coa,order)
  expect_equal(pass_by_conc(df), FALSE)
})
