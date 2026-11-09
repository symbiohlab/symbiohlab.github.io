# =============================================================================
# run_all.R
# Reproduces all tables and figures of the manuscript from the data in data/.
# Usage (from the repository root):  Rscript run_all.R
# Outputs are written to output/tables and output/figures.
# =============================================================================
source(file.path("R", "00_setup.R"))
pdf(NULL)   # send incidental base-graphics output (e.g. from vegan::rarecurve) to a null device
source(file.path("R", "01_data_import.R"))
source(file.path("R", "02_alpha_diversity.R"))
source(file.path("R", "03_beta_diversity.R"))
source(file.path("R", "04_marker_congruence.R"))
source(file.path("R", "05_taxonomic_composition.R"))

invisible(dev.off())
writeLines(capture.output(sessionInfo()), file.path("output", "session_info.txt"))
message("Done. Session information written to output/session_info.txt")
