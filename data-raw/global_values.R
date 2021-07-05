## code to prepare `global_values` dataset goes here


sub_categories <- c("Additive", "Pesticide", "Veterinary Drug Residue", "Contaminant", "Genotoxic-Carcinogen")
sub_ref_type <- c("Acceptable Intake", "Tolerable Intake", "Provisional Maximum Tolerable Intake", "Benchmark Dose Level (BMDL)")
sub_frequency <- c("DAILY"  =  1, "WEEKLY"  = 7)






usethis::use_data(
  sub_categories,
  sub_ref_type,
  sub_frequency
  , internal = TRUE
  #, internal = FALSE
  , overwrite = TRUE)

