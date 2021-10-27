test_that("able to read CoA csv file", {
  df <- read_coa_file("../../data/passing_eg1_coa_file.csv")

  expect_equal(nrow(df), 1536)
})

test_that("Errors on wrong col names", {
  expect_warning(read_coa_file("../../data/wrongly_named_columns.csv"), 'The columns in the CoA file should be named "plate_name","well_position","sequence_name","sequence"')
})

test_that("Able to read non UTF8 csv CoA file", {
  df <- read_coa_file("../../data/non_utf8_coa.csv")

  expect_equal(nrow(df), 5760)
})
