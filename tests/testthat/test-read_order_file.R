test_that("able to read Order excel file", {
  df <- read_order_file("../../data/passing_eg1_order_file.xlsx")

  expect_equal(nrow(df), 1536)
})
