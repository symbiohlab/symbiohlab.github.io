# =============================================================================
# 01_data_import.R
# Read OTU tables, taxonomy and metadata; build phyloseq objects; rarefy.
# Produces: Table S2 (per-sample reads and OTUs), Table S3 (OTUs by class),
#           Figure 1 (taxonomic assignment rates), Figure S1 (rarefaction curves).
# =============================================================================
if (!exists("MARKERS")) source(file.path("R", "00_setup.R"))

message("01 - importing data")

# (named read_tsv_file to avoid masking readr::read_tsv if readr is attached)
read_tsv_file <- function(file) {
  read.table(file, header = TRUE, sep = "\t", check.names = FALSE,
             comment.char = "", quote = "", stringsAsFactors = FALSE)
}

metadata <- read_tsv_file(file.path(DATA_DIR, "sample_metadata.tsv"))
rownames(metadata) <- metadata$SampleID
metadata$Location <- factor(metadata$Location)
metadata$Habitat  <- factor(metadata$Habitat, levels = c("Wetland", "Upland"))

build_phyloseq <- function(marker) {
  otu <- read_tsv_file(file.path(DATA_DIR, paste0(marker, "_otu_table.tsv")))
  tax <- read_tsv_file(file.path(DATA_DIR, paste0(marker, "_taxonomy.tsv")))
  otu_mat <- as.matrix(otu[, -1]); rownames(otu_mat) <- otu$OTU_ID
  tax_mat <- as.matrix(tax[, -1]); rownames(tax_mat) <- tax$OTU_ID
  common_otus <- intersect(rownames(otu_mat), rownames(tax_mat))
  ps <- phyloseq(otu_table(otu_mat[common_otus, rownames(metadata)], taxa_are_rows = TRUE),
                 tax_table(tax_mat[common_otus, ]),
                 sample_data(metadata))
  prune_taxa(taxa_sums(ps) > 0, ps)
}

rarefy_ps <- function(ps, depth) {
  r <- rarefy_even_depth(ps, sample.size = depth, rngseed = SEED,
                         replace = FALSE, trimOTUs = TRUE, verbose = FALSE)
  prune_taxa(taxa_sums(r) > 0, r)
}

ps_raw    <- setNames(lapply(MARKERS, build_phyloseq), MARKERS)                       # unrarefied
ps_marker <- setNames(lapply(MARKERS, function(m) rarefy_ps(ps_raw[[m]], RARE_DEPTH[[m]])), MARKERS)  # marker-specific depth
ps_common <- setNames(lapply(MARKERS, function(m) rarefy_ps(ps_raw[[m]], COMMON_DEPTH)), MARKERS)     # common depth

# ---- Table S2: per-sample reads and OTUs ------------------------------------
table_s2 <- map_dfr(MARKERS, function(m) {
  raw <- otu_matrix(ps_raw[[m]]); rar <- otu_matrix(ps_marker[[m]])
  tax <- taxonomy_df(ps_marker[[m]]); pin <- tax$Class %in% "Pinopsida"   # %in% is NA-safe
  md  <- sample_info(ps_marker[[m]])
  tibble(Marker = m, SampleID = rownames(rar), Location = md$Location, Habitat = md$Habitat,
         Reads_raw = rowSums(raw[rownames(rar), ]), OTUs_raw = rowSums(raw[rownames(rar), ] > 0),
         Rarefaction_depth = RARE_DEPTH[[m]], OTUs_rarefied = rowSums(rar > 0),
         Pinopsida_OTUs = rowSums(rar[, pin, drop = FALSE] > 0),
         Pinopsida_reads_percent = round(100 * rowSums(rar[, pin, drop = FALSE]) / rowSums(rar), 1))
})
write_table(table_s2, "TableS2_per_sample_reads_OTUs")

# ---- Table S3: OTUs and reads by plant class (rarefied) ---------------------
table_s3 <- map_dfr(MARKERS, function(m) {
  rar <- otu_matrix(ps_marker[[m]]); tax <- taxonomy_df(ps_marker[[m]])
  tibble(Marker = m, Class = tax$Class, Reads = colSums(rar)) %>%
    group_by(Marker, Class) %>% summarise(OTUs = n(), Reads = sum(Reads), .groups = "drop") %>%
    mutate(OTU_percent = round(100 * OTUs / sum(OTUs), 1), Read_percent = round(100 * Reads / sum(Reads), 1)) %>%
    arrange(desc(OTUs))
})
write_table(table_s3, "TableS3_OTUs_by_class")

# ---- Figure 1: taxonomic assignment rates (OTU-based and read-weighted) -----
assignment <- map_dfr(MARKERS, function(m) {
  rar <- otu_matrix(ps_marker[[m]]); tax <- taxonomy_df(ps_marker[[m]]); reads <- colSums(rar)
  map_dfr(c("Order", "Family", "Genus"), function(rank) {
    ok <- is_assigned(tax[[rank]])
    tibble(Marker = m, Rank = rank,
           OTUs = length(ok), Assigned_OTUs = sum(ok), OTU_based_percent = 100 * mean(ok),
           Reads = sum(reads), Assigned_reads = sum(reads[ok]), Read_weighted_percent = 100 * sum(reads[ok]) / sum(reads))
  })
})
write_table(assignment %>% mutate(across(ends_with("percent"), ~ round(.x, 2))), "Figure1_assignment_rates")

fmt_percent <- function(x) ifelse(round(x, 1) >= 100 & x < 100, ">99.9", sprintf("%.1f", x))
fig1_df <- assignment %>%
  select(Marker, Rank, OTU_based_percent, Read_weighted_percent) %>%
  pivot_longer(-c(Marker, Rank), names_to = "Type", values_to = "Percent") %>%
  mutate(Type = recode(Type, OTU_based_percent = "OTU-based", Read_weighted_percent = "Read-weighted"),
         Marker = factor(Marker, MARKERS), Rank = factor(Rank, c("Order", "Family", "Genus")))
fig1 <- ggplot(fig1_df, aes(Rank, Percent, fill = Marker)) +
  geom_col(position = position_dodge(0.75), width = 0.65) +
  geom_text(aes(label = fmt_percent(Percent)), position = position_dodge(0.75), vjust = -0.4, size = 3) +
  facet_wrap(~ Type) +
  scale_fill_manual(values = COL_MARKER) +
  scale_y_continuous(limits = c(0, 110), breaks = seq(0, 100, 25), labels = function(x) paste0(x, "%")) +
  labs(x = "Taxonomic rank", y = "Assignment rate (%)", fill = "Marker") +
  theme_pub(12)
save_figure(fig1, "Figure1_assignment_rates", 9, 5)

# ---- Figure S1: rarefaction curves (unrarefied data) ------------------------
rare_curves <- map_dfr(MARKERS, function(m) {
  raw <- otu_matrix(ps_raw[[m]])
  pdf(NULL)   # rarecurve() always draws; discard the plot (also when this script is sourced on its own)
  curves <- suppressWarnings(rarecurve(raw, step = 300, label = FALSE))
  invisible(dev.off())
  map_dfr(seq_along(curves), function(i) {
    tibble(Marker = m, SampleID = rownames(raw)[i], Reads = attr(curves[[i]], "Subsample"), Richness = as.numeric(curves[[i]]))
  })
}) %>% mutate(Marker = factor(Marker, MARKERS))
depth_lines <- tibble(Marker = factor(MARKERS, MARKERS), Depth = RARE_DEPTH[MARKERS])
figS1 <- ggplot(rare_curves, aes(Reads, Richness, group = SampleID)) +
  geom_line(alpha = 0.5, linewidth = 0.4, colour = "grey40") +
  geom_vline(data = depth_lines, aes(xintercept = Depth), linetype = "dashed", colour = "firebrick") +
  facet_wrap(~ Marker, scales = "free_x") +
  labs(x = "Reads", y = "Observed OTU richness") +
  theme_pub(12)
save_figure(figS1, "FigureS1_rarefaction_curves", 11, 4.5)
