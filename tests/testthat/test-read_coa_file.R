test_that("able to read CoA csv file", {
  df <- read_coa_file("../../data/passing_eg1_coa_file.csv")

  expect_equal(nrow(df), 1536)
})

test_that("Errors on wrong col names", {
  df <- read_coa_file("../../data/wrongly_named_columns.csv")

  expect_equal(df, NULL)
})
