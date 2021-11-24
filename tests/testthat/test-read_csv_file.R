test_that("able to read CoA csv file", {
  df <- read_csv_file("../../data/passing_eg1_coa_file.csv")

  expect_equal(nrow(df), 1536)
})

test_that("Errors on wrong col names", {
  expect_warning(read_csv_file("../../data/wrongly_named_columns.csv"), 'Expected columns not found')
})

test_that("Able to read non UTF8 csv CoA file", {
  df <- read_csv_file("../../data/non_utf8_coa.csv")

  expect_equal(nrow(df), 5760)
})

test_that("Errors on missing cols in IDT version 2", {
  expect_warning(read_csv_file("../../data/idt_ver2_coa_file.csv"), 'Expected columns not found')
})

test_that("able to read Order csv file", {
  df <- read_csv_file("../../data/passing_eg1_order_file.csv")

  expect_equal(nrow(df), 1536)
})
