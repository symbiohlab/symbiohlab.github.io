# =============================================================================
# 03_beta_diversity.R
# Bray-Curtis community structure: PERMANOVA (single sequential model with free
# and location-restricted permutations, and within each location), PERMDISP, PCoA.
# Produces: Table 2, Table S5, Figure 3.
# =============================================================================
if (!exists("ps_marker")) source(file.path("R", "01_data_import.R"))

message("03 - beta diversity")
set.seed(SEED)   # same permutation results whether run via run_all.R or sourced on its own

# ---- Table 2: PERMANOVA -----------------------------------------------------
permanova_one <- function(ps, marker) {
  comm <- rel_abundance(ps); md <- sample_info(ps)
  tidy <- function(a, model) {
    as.data.frame(a) %>% rownames_to_column("Term") %>%
      transmute(Marker = marker, Model = model, Term, df = Df, SS = round(SumOfSqs, 3),
                R2 = round(R2, 3), F = round(F, 2), P = `Pr(>F)`)
  }
  # sequential model, free permutations
  free <- tidy(adonis2(comm ~ Location * Habitat, data = md, method = "bray",
                       permutations = N_PERM_ADONIS, by = "terms"), "Location + Habitat + Location:Habitat")
  # same model, permutations restricted within location (cannot test the Location term)
  ctrl <- how(nperm = N_PERM_ADONIS, blocks = md$Location)
  restricted <- tidy(adonis2(comm ~ Location * Habitat, data = md, method = "bray",
                             permutations = ctrl, by = "terms"), "restricted") %>%
    transmute(Term, P_restricted_within_location = ifelse(Term == "Location", NA, P))
  full <- left_join(free, restricted, by = "Term") %>% rename(P_free = P)
  # habitat effect within each location
  within <- map_dfr(levels(md$Location), function(loc) {
    keep <- md$Location == loc; sub <- comm[keep, ]; sub <- sub[, colSums(sub) > 0]
    tidy(adonis2(sub ~ Habitat, data = md[keep, ], method = "bray", permutations = N_PERM_ADONIS, by = "terms"),
         paste("Habitat within", loc)) %>% filter(Term == "Habitat") %>% rename(P_free = P)
  })
  bind_rows(full, within)
}
table2 <- map_dfr(MARKERS, ~ permanova_one(ps_marker[[.x]], .x))
write_table(table2, "Table2_PERMANOVA")

# ---- Table S5: homogeneity of multivariate dispersion (PERMDISP) ------------
permdisp_one <- function(ps, marker) {
  d <- bray_dist(ps); md <- sample_info(ps); D <- as.matrix(d)
  test <- function(keep, group, label) {
    bd <- betadisper(as.dist(D[keep, keep]), droplevels(factor(group[keep])))
    pt <- permutest(bd, permutations = N_PERM_ADONIS)
    centroid <- tapply(bd$distances, bd$group, mean)
    tibble(Marker = marker, Grouping = label, n = sum(keep), Groups = length(centroid),
           F = round(pt$tab$F[1], 2), P = pt$tab[1, "Pr(>F)"],
           Mean_distance_to_centroid = paste(names(centroid), round(centroid, 3), sep = " = ", collapse = "; "))
  }
  all <- rep(TRUE, nrow(md))
  bind_rows(test(all, md$Habitat, "Habitat"), test(all, md$Location, "Location"),
            test(md$Habitat == "Wetland", md$Location, "Location within wetland"),
            test(md$Habitat == "Upland",  md$Location, "Location within upland"))
}
table_s5 <- map_dfr(MARKERS, ~ permdisp_one(ps_marker[[.x]], .x))
write_table(table_s5, "TableS5_PERMDISP")

# ---- Figure 3: PCoA with PERMANOVA annotation -------------------------------
pcoa_df <- map_dfr(MARKERS, function(m) {
  pts <- pcoa_scores(bray_dist(ps_marker[[m]]), k = 2); eig <- attr(pts, "eig"); eig <- eig[eig > 0]
  md <- sample_info(ps_marker[[m]])
  tibble(Marker = m, SampleID = rownames(pts), Location = md$Location, Habitat = md$Habitat,
         Axis1 = pts[, 1], Axis2 = pts[, 2],
         Panel = sprintf("%s\nPCoA1 = %.1f%%, PCoA2 = %.1f%%", m, 100 * eig[1] / sum(eig), 100 * eig[2] / sum(eig)))
}) %>% mutate(Marker = factor(Marker, MARKERS), Panel = factor(Panel, unique(Panel)))

fmt_p <- function(p) ifelse(p < 0.001, "p < 0.001", paste0("p = ", p))
annotation <- table2 %>% filter(Model == "Location + Habitat + Location:Habitat", Term %in% c("Habitat", "Location")) %>%
  group_by(Marker) %>%
  summarise(Label = sprintf("Habitat: R2 = %.2f, %s\nLocation: R2 = %.2f, %s",
                            R2[Term == "Habitat"], fmt_p(P_free[Term == "Habitat"]),
                            R2[Term == "Location"], fmt_p(P_free[Term == "Location"])), .groups = "drop") %>%
  mutate(Marker = factor(Marker, MARKERS)) %>%
  left_join(pcoa_df %>% group_by(Marker, Panel) %>% summarise(x = min(Axis1), y = max(Axis2) + 0.15, .groups = "drop"), by = "Marker")

fig3 <- ggplot(pcoa_df, aes(Axis1, Axis2, colour = Habitat, shape = Location)) +
  geom_point(size = 3.5, alpha = 0.9) +
  geom_text(data = annotation, aes(x = x, y = y, label = Label), inherit.aes = FALSE, hjust = 0, vjust = 1, size = 3) +
  facet_wrap(~ Panel) + coord_equal() + scale_y_continuous(expand = expansion(mult = c(0.05, 0.15))) +
  scale_colour_manual(values = COL_HABITAT) + scale_shape_manual(values = SHAPE_LOCATION) +
  labs(x = "PCoA1", y = "PCoA2") + theme_pub(12)
save_figure(fig3, "Figure3_PCoA", 11, 4.5)
