coa <- clean_idt_coa_file("../../data/passing_eg1_coa_file.csv")

test_that("Can read IDT format 1", {
  expect_equal(nrow(coa), 1537)
})

test_that("Getting all expected columns IDT format 1", {
  expect_equal(colnames(coa), c("plate_name","payment_method","plate_barcode","sales_order_number",
                                "reference_number","well_position","sequence_name","sequence",
                                "manufacturing_id","measured_molecular_weight","calculated_molecular_weight","od260",
                                "nmoles","mg","measured_concentration_m_m","final_volume_m_l",
                                "extinction_coefficient_l_mole_cm","tm","well_barcode"))
})


test_that("Can read IDT format 2", {
  coa1 <- clean_idt_coa_file(file = "../../data/idt_ver2_coa_file.csv")
  expect_equal(nrow(coa1), 1840)
})
