order <- clean_idt_order_file("../../data/passing_eg1_order_file.xlsx", sheet_name = "PrimerMix Plate Order Form")

test_that("Can read IDT format 1", {
  expect_equal(nrow(order), 1536)
})

test_that("Getting correct columns IDT format 1", {
  expect_equal(colnames(order),c("plate_name","well_position","sequence_name","sequence",
                                 "final_concentration_m_m","final_volume_m_l","buffer"))
})

order1 <- clean_idt_order_file(file = "../../data/idt_ver2_order_file.xlsx", sheet_name = "Plate Order Form")
test_that("Can read IDT format 2", {
  expect_equal(nrow(order1), 1840)
})

test_that("Getting correct columns IDT format 2", {
  expect_equal(colnames(order1),c("plate_name","plate_type","plate_wells","well_position",
                                 "sequence_name","sequence","concentration_m_m","volume_m_l",
                                 "buffer"))
})
