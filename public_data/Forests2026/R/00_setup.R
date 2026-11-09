# =============================================================================
# 00_setup.R
# Shared settings, packages, and helper functions for all analysis scripts.
# Source this file first (run_all.R does this automatically).
# =============================================================================

# ---- Packages ---------------------------------------------------------------
# Install any missing packages: phyloseq from Bioconductor, the rest from CRAN.
# pbkrtest is required by lmerTest for Kenward-Roger degrees of freedom.
CRAN_PKGS <- c("vegan", "permute", "lme4", "lmerTest", "pbkrtest", "emmeans",
               "dplyr", "tidyr", "purrr", "tibble", "ggplot2", "patchwork")
BIOC_PKGS <- c("phyloseq")
installed <- rownames(installed.packages())
missing_cran <- setdiff(CRAN_PKGS, installed)
if (length(missing_cran)) {
  message("Installing from CRAN: ", paste(missing_cran, collapse = ", "))
  install.packages(missing_cran, repos = "https://cloud.r-project.org")
}
missing_bioc <- setdiff(BIOC_PKGS, installed)
if (length(missing_bioc)) {
  if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager", repos = "https://cloud.r-project.org")
  message("Installing from Bioconductor: ", paste(missing_bioc, collapse = ", "))
  BiocManager::install(missing_bioc, ask = FALSE, update = FALSE)
}
rm(installed, missing_cran, missing_bioc)

suppressPackageStartupMessages({
  library(phyloseq)
  library(vegan)
  library(permute)
  library(lme4)
  library(lmerTest)
  library(emmeans)
  library(dplyr)
  library(tidyr)
  library(purrr)
  library(tibble)
  library(ggplot2)
  library(patchwork)
})

# ---- Reproducibility --------------------------------------------------------
SEED <- 123
set.seed(SEED)
options(contrasts = c("contr.sum", "contr.poly"))   # Type III tests in mixed models

# ---- Paths ------------------------------------------------------------------
# All paths are relative to the repository root (the folder containing run_all.R).
if (!dir.exists("data") || !dir.exists("R"))
  stop("Set the working directory to the repository root (the folder containing run_all.R), e.g. setwd(\"...\")")
DATA_DIR  <- "data"
TABLE_DIR <- file.path("output", "tables")
FIG_DIR   <- file.path("output", "figures")
dir.create(TABLE_DIR, showWarnings = FALSE, recursive = TRUE)
dir.create(FIG_DIR,   showWarnings = FALSE, recursive = TRUE)

# ---- Analysis constants -----------------------------------------------------
MARKERS      <- c("rbcL", "trnL", "ITS2")
RARE_DEPTH   <- c(rbcL = 10000, trnL = 21000, ITS2 = 17000)  # marker-specific depths (all 24 samples retained)
COMMON_DEPTH <- 10000                                        # common depth used in sensitivity analyses
N_PERM_ADONIS <- 999      # PERMANOVA and PERMDISP
N_PERM_MANTEL <- 9999     # Mantel and PROTEST
N_PERM_INDIC  <- 999      # location-restricted permutation test for indicator genera
MIN_PREVALENCE <- 0.10    # genera tested as indicators must occur in >= 10% of samples
PRESENCE_PREVALENCE <- 0.05  # a taxon counts as detected by a marker if present in >= 5% of its samples (Figure S2)

# ---- Plot settings ----------------------------------------------------------
COL_HABITAT <- c(Wetland = "#2166AC", Upland = "#D6604D")
SHAPE_LOCATION <- c(BH = 16, HC = 17)
COL_MARKER  <- c(rbcL = "#4E9ABA", trnL = "#73B741", ITS2 = "#E06B2F")

theme_pub <- function(base_size = 11) {
  theme_bw(base_size = base_size) +
    theme(strip.text = element_text(face = "bold"),
          strip.background = element_rect(fill = "grey95"),
          panel.grid.minor = element_blank())
}

# ---- Small helpers ----------------------------------------------------------
write_table <- function(x, name) {
  dir.create(TABLE_DIR, showWarnings = FALSE, recursive = TRUE)   # in case the working directory changed
  write.csv(x, file.path(TABLE_DIR, paste0(name, ".csv")), row.names = FALSE)
  message("  table : ", name, ".csv")
}

save_figure <- function(p, name, width, height) {
  dir.create(FIG_DIR, showWarnings = FALSE, recursive = TRUE)
  ggsave(file.path(FIG_DIR, paste0(name, ".pdf")), p, width = width, height = height)
  ggsave(file.path(FIG_DIR, paste0(name, ".png")), p, width = width, height = height, dpi = 300)
  message("  figure: ", name, ".pdf / .png")
}

p_stars <- function(p) {
  ifelse(is.na(p), "", ifelse(p < 0.001, "***", ifelse(p < 0.01, "**", ifelse(p < 0.05, "*", "ns"))))
}

# A taxon name counts as assigned unless it is empty, "unassigned"-like, or a
# placeholder of the form "<ParentTaxon>_un" produced by the classifier.
is_assigned <- function(x) {
  x <- as.character(x)
  !is.na(x) & x != "" &
    !grepl("(_un|_unclassified|_unassigned)$", x) &
    !(tolower(x) %in% c("unassigned", "unclassified", "unknown", "na"))
}

# Cliff's delta: P(upland > wetland) - P(upland < wetland); positive = higher in upland
cliff_delta <- function(upland, wetland) {
  mean(outer(upland, wetland, function(a, b) sign(a - b)))
}

# ---- Data access helpers (work on phyloseq objects) -------------------------
otu_matrix <- function(ps) {
  # samples in rows, OTUs in columns
  m <- as(otu_table(ps), "matrix")
  if (taxa_are_rows(ps)) m <- t(m)
  m
}

rel_abundance <- function(ps) {
  m <- otu_matrix(ps)
  m / rowSums(m)
}

sample_info <- function(ps) {
  # metadata in the same row order as otu_matrix(ps)
  md <- data.frame(sample_data(ps), stringsAsFactors = FALSE)
  md[rownames(otu_matrix(ps)), , drop = FALSE]
}

taxonomy_df <- function(ps) {
  as.data.frame(as(tax_table(ps), "matrix"), stringsAsFactors = FALSE)
}

bray_dist <- function(ps) vegdist(rel_abundance(ps), method = "bray")

# PCoA scores on Bray-Curtis dissimilarity (Lingoes correction for negative eigenvalues).
# k = NULL returns all axes with positive eigenvalues.
pcoa_scores <- function(d, k = NULL) {
  ord <- wcmdscale(d, eig = TRUE, add = "lingoes")
  pts <- ord$points
  if (!is.null(k)) pts <- pts[, seq_len(k), drop = FALSE]
  attr(pts, "eig") <- ord$eig
  pts
}
