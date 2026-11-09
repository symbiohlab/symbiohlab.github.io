# =============================================================================
# 02_alpha_diversity.R
# Alpha diversity (observed richness, Shannon diversity, evenness), linear mixed
# models, contrasts, residual diagnostics and sensitivity analyses.
# Produces: Table 1, Table 3 (alpha correlations), Table S4 (a-c), Figure 2, Figure S5.
# =============================================================================
if (!exists("ps_marker")) source(file.path("R", "01_data_import.R"))

message("02 - alpha diversity")

# ---- Per-sample metrics -----------------------------------------------------
alpha_metrics <- function(ps, marker, dataset) {
  m <- otu_matrix(ps); tax <- taxonomy_df(ps); md <- sample_info(ps)
  non_pin <- !(tax$Class %in% "Pinopsida")   # %in% is NA-safe
  observed <- rowSums(m > 0)
  shannon  <- diversity(m, index = "shannon")
  tibble(Dataset = dataset, Marker = marker, SampleID = rownames(m),
         Location = md$Location, Habitat = md$Habitat,
         Observed   = observed,                                  # Hill number q = 0
         Shannon    = shannon,                                   # q = 1 (as H')
         Evenness   = ifelse(observed > 1, shannon / log(observed), NA_real_),   # Pielou's J'
         Genus_richness  = apply(m > 0, 1, function(p) length(unique(tax$Genus[p][is_assigned(tax$Genus[p])]))),
         Observed_nonPinopsida = rowSums(m[, non_pin, drop = FALSE] > 0),
         Shannon_nonPinopsida  = diversity(m[, non_pin, drop = FALSE], index = "shannon"))
}

alpha <- bind_rows(
  map_dfr(MARKERS, ~ alpha_metrics(ps_marker[[.x]], .x, "marker_depth")),
  map_dfr(MARKERS, ~ alpha_metrics(ps_common[[.x]], .x, "common_10k"))
) %>% mutate(Marker = factor(Marker, MARKERS))
write_table(alpha, "TableS4_alpha_per_sample")

METRICS <- c("Observed", "Shannon", "Evenness", "Genus_richness", "Observed_nonPinopsida", "Shannon_nonPinopsida")

# ---- Linear mixed model: Alpha ~ Habitat * Marker + Location + (1 | SampleID) -
fit_alpha_lmm <- function(data, metric) {
  d <- data %>% mutate(Alpha = .data[[metric]]) %>% filter(!is.na(Alpha))
  fit <- lmer(Alpha ~ Habitat * Marker + Location + (1 | SampleID), data = d)
  anova_tab <- anova(fit, type = 3, ddf = "Kenward-Roger") %>% as.data.frame() %>% rownames_to_column("Term") %>%
    transmute(Metric = metric, Term, df1 = NumDF, df2 = round(DenDF, 1), F = round(`F value`, 2), P = signif(`Pr(>F)`, 3))
  contrasts <- emmeans(fit, ~ Habitat | Marker) %>% pairs(adjust = "none") %>% as.data.frame() %>%
    transmute(Metric = metric, Marker, Contrast = contrast, Estimate = round(estimate, 3), SE = round(SE, 3),
              df = round(df, 1), t = round(t.ratio, 2), P = signif(p.value, 3))
  r <- resid(fit); groups <- interaction(d$Habitat, d$Marker)
  diagnostics <- tibble(Metric = metric,
                        Shapiro_P = signif(shapiro.test(r)$p.value, 3),
                        Fligner_Killeen_P = signif(fligner.test(r ~ groups)$p.value, 3))
  list(anova = anova_tab, contrasts = contrasts, diagnostics = diagnostics)
}

lmm_marker <- map(METRICS, ~ fit_alpha_lmm(filter(alpha, Dataset == "marker_depth"), .x))
lmm_common <- map(METRICS, ~ fit_alpha_lmm(filter(alpha, Dataset == "common_10k"), .x))

# Table 1: main-text metrics at marker-specific depths
main_metrics <- c("Observed", "Shannon", "Evenness")
write_table(map_dfr(lmm_marker, "anova") %>% filter(Metric %in% main_metrics), "Table1_alpha_LMM")
write_table(map_dfr(lmm_marker, "contrasts") %>% filter(Metric %in% main_metrics), "Table1_alpha_contrasts")

# Table S4a: all metrics, both depths
write_table(bind_rows(map_dfr(lmm_marker, "contrasts") %>% mutate(Dataset = "marker_depth", .before = 1),
                      map_dfr(lmm_common, "contrasts") %>% mutate(Dataset = "common_10k", .before = 1)),
            "TableS4a_alpha_contrasts_all_metrics")
write_table(bind_rows(map_dfr(lmm_marker, "anova") %>% mutate(Dataset = "marker_depth", .before = 1),
                      map_dfr(lmm_common, "anova") %>% mutate(Dataset = "common_10k", .before = 1)),
            "TableS4a_alpha_LMM_all_metrics")

# Table S4b: rank-based tests pooled and within each location (marker-specific depth)
table_s4b <- alpha %>% filter(Dataset == "marker_depth") %>%
  pivot_longer(all_of(METRICS), names_to = "Metric", values_to = "Value") %>%
  group_by(Metric, Marker) %>% group_modify(~ {
    d <- .x
    test <- function(sub) {
      up <- sub$Value[sub$Habitat == "Upland"]; we <- sub$Value[sub$Habitat == "Wetland"]
      c(P = wilcox.test(up, we, exact = FALSE)$p.value, Delta = cliff_delta(up, we))
    }
    all <- test(d); bh <- test(filter(d, Location == "BH")); hc <- test(filter(d, Location == "HC"))
    tibble(P_pooled = signif(all["P"], 3), Cliff_delta_pooled = round(all["Delta"], 2),
           P_BH = signif(bh["P"], 3), Cliff_delta_BH = round(bh["Delta"], 2),
           P_HC = signif(hc["P"], 3), Cliff_delta_HC = round(hc["Delta"], 2))
  }) %>% ungroup()
write_table(table_s4b, "TableS4b_alpha_wilcoxon_by_location")

# Table S4c: residual diagnostics
write_table(map_dfr(lmm_marker, "diagnostics"), "TableS4c_LMM_diagnostics")

# ---- Table 3 (right-hand part): cross-marker Spearman correlations of per-sample alpha diversity
pairs_markers <- list(c("rbcL", "trnL"), c("rbcL", "ITS2"), c("trnL", "ITS2"))
table3_alpha <- map_dfr(pairs_markers, function(pr) map_dfr(main_metrics, function(metric) {
  wide <- alpha %>% filter(Dataset == "marker_depth") %>% select(SampleID, Marker, all_of(metric)) %>%
    pivot_wider(names_from = Marker, values_from = all_of(metric))
  ct <- cor.test(wide[[pr[1]]], wide[[pr[2]]], method = "spearman", exact = FALSE)
  tibble(Pair = paste(pr, collapse = " vs. "), Metric = metric, rho = round(ct$estimate, 2), P = signif(ct$p.value, 3))
}))
write_table(table3_alpha, "Table3_cross_marker_alpha_spearman")

# ---- Figure 2: alpha diversity at marker-specific depths --------------------
plot_alpha <- function(data, contrasts, metrics, labels, title = NULL) {
  df <- data %>% select(Marker, SampleID, Location, Habitat, all_of(metrics)) %>%
    pivot_longer(all_of(metrics), names_to = "Metric", values_to = "Value") %>%
    mutate(Metric = factor(Metric, metrics, labels = labels))
  stars <- contrasts %>% filter(Metric %in% metrics) %>%
    mutate(Marker = factor(Marker, MARKERS), Metric = factor(Metric, metrics, labels = labels), Label = p_stars(P)) %>%
    left_join(df %>% group_by(Metric) %>% summarise(y = max(Value, na.rm = TRUE) * 1.08, .groups = "drop"), by = "Metric")
  ggplot(df, aes(Habitat, Value, fill = Habitat)) +
    geom_boxplot(outlier.shape = NA, alpha = 0.6, width = 0.6) +
    geom_jitter(aes(shape = Location), width = 0.12, size = 1.8, alpha = 0.8) +
    geom_text(data = stars, aes(x = 1.5, y = y, label = Label), inherit.aes = FALSE, size = 4) +
    facet_grid(Metric ~ Marker, scales = "free_y") +
    scale_fill_manual(values = COL_HABITAT) + scale_shape_manual(values = SHAPE_LOCATION) +
    labs(x = NULL, y = NULL, title = title) +
    theme_pub() + theme(legend.position = "bottom")
}
fig2 <- plot_alpha(filter(alpha, Dataset == "marker_depth"), map_dfr(lmm_marker, "contrasts"),
                   c("Observed", "Shannon", "Evenness"),
                   c("Observed OTU richness", "Shannon diversity (H')", "Pielou's evenness (J')"))
save_figure(fig2, "Figure2_alpha_diversity", 8, 8)

# ---- Figure S5: Pinopsida versus other OTUs per sample ----------------------
pin_df <- table_s2 %>%
  transmute(Marker = factor(Marker, MARKERS), SampleID, Location, Habitat,
            Pinopsida = Pinopsida_OTUs, Other = OTUs_rarefied - Pinopsida_OTUs) %>%
  pivot_longer(c(Pinopsida, Other), names_to = "Group", values_to = "OTUs") %>%
  mutate(Group = factor(Group, c("Other", "Pinopsida")),
         SampleID = factor(SampleID, unique(SampleID[order(Location, Habitat, SampleID)])))
figS5 <- ggplot(pin_df, aes(SampleID, OTUs, fill = Group)) +
  geom_col() +
  facet_grid(Marker ~ Habitat + Location, scales = "free", space = "free_x") +
  scale_fill_manual(values = c(Other = "grey60", Pinopsida = "#2CA02C")) +
  labs(x = NULL, y = "Number of OTUs per sample (rarefied)", fill = "OTU class") +
  theme_pub(10) + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, size = 7), legend.position = "bottom")
save_figure(figS5, "FigureS5_Pinopsida_OTUs_per_sample", 9, 7)
