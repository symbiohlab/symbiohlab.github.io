# =============================================================================
# 04_marker_congruence.R
# Inter-marker congruence: Mantel (Spearman), Procrustes/PROTEST on the first two
# PCoA axes and on all axes, and the same analyses within locations and habitat types.
# Produces: Table 3, Table S6, Figure 5 (Mantel scatter), Figure 6 (Procrustes).
# =============================================================================
if (!exists("ps_marker")) source(file.path("R", "01_data_import.R"))

message("04 - inter-marker congruence")
set.seed(SEED)   # same permutation results whether run via run_all.R or sourced on its own

dist_list <- setNames(lapply(MARKERS, function(m) bray_dist(ps_marker[[m]])), MARKERS)
meta <- sample_info(ps_marker$rbcL)
pairs_markers <- list(c("rbcL", "trnL"), c("rbcL", "ITS2"), c("trnL", "ITS2"))
subsets <- list("All samples" = rep(TRUE, nrow(meta)),
                "BH" = meta$Location == "BH", "HC" = meta$Location == "HC",
                "Wetland" = meta$Habitat == "Wetland", "Upland" = meta$Habitat == "Upland")

subset_dist <- function(d, keep) as.dist(as.matrix(d)[keep, keep])

protest_r <- function(d1, d2, k = NULL) {
  pt <- protest(pcoa_scores(d1, k), pcoa_scores(d2, k), permutations = N_PERM_MANTEL, symmetric = TRUE)
  c(r = pt$t0, p = pt$signif)
}

congruence <- map_dfr(pairs_markers, function(pr) map_dfr(names(subsets), function(s) {
  keep <- subsets[[s]]; d1 <- subset_dist(dist_list[[pr[1]]], keep); d2 <- subset_dist(dist_list[[pr[2]]], keep)
  mt <- mantel(d1, d2, method = "spearman", permutations = N_PERM_MANTEL)
  two <- protest_r(d1, d2, k = 2); all <- protest_r(d1, d2, k = NULL)
  tibble(Pair = paste(pr, collapse = " vs. "), Subset = s, n = sum(keep),
         Mantel_r = round(mt$statistic, 3), Mantel_P = mt$signif,
         Procrustes_r_2axes = round(two["r"], 3), Procrustes_P_2axes = two["p"],
         Procrustes_r_all_axes = round(all["r"], 3), Procrustes_P_all_axes = all["p"])
}))

table3 <- congruence %>% filter(Subset == "All samples") %>% select(-Subset)
write_table(table3, "Table3_congruence")
write_table(congruence %>% filter(Subset != "All samples"), "TableS6_congruence_within_subsets")

# Per-sample Procrustes residuals (first two axes) compared between locations (reported in the text)
residuals_by_location <- map_dfr(pairs_markers, function(pr) {
  pr_fit <- procrustes(pcoa_scores(dist_list[[pr[1]]], 2), pcoa_scores(dist_list[[pr[2]]], 2), symmetric = TRUE)
  res <- residuals(pr_fit)
  w <- wilcox.test(res[meta$Location == "BH"], res[meta$Location == "HC"], exact = FALSE)
  tibble(Pair = paste(pr, collapse = " vs. "), P_wilcoxon = signif(w$p.value, 3))
})
message("  Procrustes residuals BH vs. HC (two axes): ", paste(residuals_by_location$Pair, "p =", residuals_by_location$P_wilcoxon, collapse = "; "))

# ---- Figure 5: pairwise Bray-Curtis dissimilarities between markers --------
scatter <- map_dfr(pairs_markers, function(pr) {
  tibble(Pair = paste(pr, collapse = " vs. "), x = as.vector(dist_list[[pr[1]]]), y = as.vector(dist_list[[pr[2]]]))
}) %>% mutate(Pair = factor(Pair, sapply(pairs_markers, paste, collapse = " vs. ")))
labels5 <- table3 %>% transmute(Pair = factor(Pair, levels(scatter$Pair)),
                                Label = sprintf("Mantel r = %.3f, %s", Mantel_r, ifelse(Mantel_P < 0.001, "p < 0.001", paste0("p = ", Mantel_P))))
fig5 <- ggplot(scatter, aes(x, y)) +
  geom_point(colour = "#2166AC", alpha = 0.35, size = 1.6) +
  geom_smooth(method = "lm", formula = y ~ x, se = TRUE, colour = "#D6604D", fill = "#FDDBC7", linewidth = 0.9) +
  geom_text(data = labels5, aes(x = 0.01, y = 0.97, label = Label), inherit.aes = FALSE, hjust = 0, vjust = 1, size = 3.5) +
  facet_wrap(~ Pair) +
  scale_x_continuous(breaks = seq(0, 1, 0.25)) + scale_y_continuous(breaks = seq(0, 1, 0.25)) +
  coord_cartesian(xlim = c(0, 1.01), ylim = c(0, 1.01)) +   # zoom without dropping the confidence band (avoids geom_smooth warnings)
  labs(x = "Bray-Curtis dissimilarity (marker 1)", y = "Bray-Curtis dissimilarity (marker 2)") + theme_pub(12)
save_figure(fig5, "Figure5_Mantel_scatter", 10, 4)

# ---- Figure 6: Procrustes superimposition (first two PCoA axes) ------------
arrows <- map_dfr(pairs_markers, function(pr) {
  pt <- protest(pcoa_scores(dist_list[[pr[1]]], 2), pcoa_scores(dist_list[[pr[2]]], 2), permutations = N_PERM_MANTEL, symmetric = TRUE)
  tibble(Pair = paste(pr, collapse = " vs. "), SampleID = rownames(pt$X),
         X1 = pt$X[, 1], X2 = pt$X[, 2], Y1 = pt$Yrot[, 1], Y2 = pt$Yrot[, 2],
         Panel = sprintf("%s\nProcrustes r = %.3f, %s", paste(pr, collapse = " vs. "), pt$t0,
                         ifelse(pt$signif < 0.001, "p < 0.001", paste0("p = ", pt$signif))))
}) %>% left_join(meta %>% select(SampleID, Location, Habitat), by = "SampleID") %>%
  mutate(Panel = factor(Panel, unique(Panel)))
fig6 <- ggplot(arrows, aes(colour = Habitat, shape = Location)) +
  geom_segment(aes(x = X1, y = X2, xend = Y1, yend = Y2), colour = "grey55", alpha = 0.5, linewidth = 0.4) +
  geom_point(aes(X1, X2), size = 3) + geom_point(aes(Y1, Y2), size = 3, alpha = 0.4) +
  facet_wrap(~ Panel) +
  scale_colour_manual(values = COL_HABITAT) + scale_shape_manual(values = SHAPE_LOCATION) +
  labs(x = "Procrustes axis 1", y = "Procrustes axis 2", caption = "Solid points: marker 1; transparent points: marker 2 (rotated)") +
  theme_pub(12)
save_figure(fig6, "Figure6_Procrustes", 11, 4.5)
