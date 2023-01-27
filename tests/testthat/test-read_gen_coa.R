df <- read_gen_coa(file="../../data/oligo_coa/3000450, 451, 452, 454, 455, 459, 460, 462, 463, 465, 467, 469_coa.csv")

test_that("files with missing sequences notes column are read", {
  expect_equal(read_gen_coa(file="../../data/oligo_coa/3000008_coa.csv") %>% pull(sequence_notes), "3000008")
})

test_that("empty rows are dropped", {
  expect_equal(nrow(df), 12)
})

test_that("columns with special characters are cleaned", {
  expect_equal(sum(df$conc), 2400)
})
