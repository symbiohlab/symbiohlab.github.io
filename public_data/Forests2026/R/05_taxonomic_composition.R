# =============================================================================
# 05_taxonomic_composition.R
# Taxonomic profiles, detection overlap among markers, and indicator genera.
# Produces: Figure 4 (family profiles), Figure S3 (genus profiles),
#           Figure S2 (UpSet-style overlap), Table S1 (indicator genera).
# =============================================================================
if (!exists("ps_marker")) source(file.path("R", "01_data_import.R"))

message("05 - taxonomic composition and indicator genera")
set.seed(SEED)   # same results whether run via run_all.R or sourced on its own

GROUP_LEVELS <- c("BH-Wetland", "BH-Upland", "HC-Wetland", "HC-Upland")

# relative abundance of assigned taxa at a given rank, per sample
rank_profile <- function(ps, marker, rank) {
  rel <- rel_abundance(ps); tax <- taxonomy_df(ps); md <- sample_info(ps)
  keep <- is_assigned(tax[[rank]])
  agg <- t(rowsum(t(rel[, keep, drop = FALSE]), tax[[rank]][keep]))          # samples x taxa
  as.data.frame(agg) %>% rownames_to_column("SampleID") %>%
    mutate(Marker = marker, Group = paste(md$Location, md$Habitat, sep = "-"), Location = md$Location, Habitat = md$Habitat) %>%
    pivot_longer(-c(SampleID, Marker, Group, Location, Habitat), names_to = "Taxon", values_to = "RelAbund")
}

# ---- Figures 4 and S3: mean relative abundance by habitat group -------------
plot_profile <- function(rank, top_n = 10, fill_label) {
  prof <- map_dfr(MARKERS, ~ rank_profile(ps_marker[[.x]], .x, rank)) %>%
    group_by(Marker, Group, Taxon) %>% summarise(Mean = mean(RelAbund), .groups = "drop")
  top <- prof %>% group_by(Taxon) %>% summarise(Overall = mean(Mean), .groups = "drop") %>% arrange(desc(Overall)) %>% slice_head(n = top_n)
  df <- prof %>% mutate(Taxon = ifelse(Taxon %in% top$Taxon, Taxon, "Other")) %>%
    group_by(Marker, Group, Taxon) %>% summarise(Mean = sum(Mean), .groups = "drop")
  # unassigned reads complete each bar to 100%
  df <- bind_rows(df, df %>% group_by(Marker, Group) %>% summarise(Mean = 1 - sum(Mean), .groups = "drop") %>% mutate(Taxon = "Other")) %>%
    group_by(Marker, Group, Taxon) %>% summarise(Mean = sum(Mean), .groups = "drop") %>%
    mutate(Marker = factor(Marker, MARKERS), Group = factor(Group, GROUP_LEVELS),
           Taxon = factor(Taxon, c("Other", rev(top$Taxon))))
  palette <- setNames(c("#AAAAAA", rev(c("#E63946", "#2166AC", "#33A02C", "#FF7F00", "#6A3D9A", "#B15928", "#00B4D8", "#FB6F92", "#66C2A5", "#F4C21B")[seq_len(nrow(top))])),
                      c("Other", rev(top$Taxon)))
  ggplot(df, aes(Marker, Mean, fill = Taxon)) +
    geom_col(width = 0.78) +
    facet_wrap(~ Group, nrow = 2) +
    scale_fill_manual(values = palette) +
    scale_y_continuous(labels = function(x) paste0(100 * x, "%"), expand = expansion(mult = c(0, 0.02))) +
    labs(x = "Marker", y = "Mean relative abundance", fill = fill_label) +
    theme_pub() + theme(legend.key.size = unit(0.4, "cm"), legend.text = element_text(size = 9, face = if (rank == "Genus") "italic" else "plain"))
}
save_figure(plot_profile("Family", 10, "Family"), "Figure4_family_profiles", 8, 6)
save_figure(plot_profile("Genus", 10, "Genus"), "FigureS3_genus_profiles", 8, 6)

# ---- Figure S2: overlap of detected families and genera among markers ------
# Detection of a taxon by a marker: present in >= PRESENCE_PREVALENCE of that marker's samples.
# At family level, OTUs without a family assignment are kept as bins named
# "Unassigned_Family_within_<deepest assigned rank>", as in the original analysis;
# at genus level only assigned genera are counted.
presence_table <- function(rank, keep_unassigned_bins = FALSE) {
  map_dfr(MARKERS, function(m) {
    rel <- rel_abundance(ps_marker[[m]]); tax <- taxonomy_df(ps_marker[[m]])
    taxon <- tax[[rank]]
    unassigned <- !is_assigned(taxon)
    taxon[unassigned] <- paste0("Unassigned_", rank, "_within_", sub("_un$", "", taxon[unassigned]))
    if (!keep_unassigned_bins) { rel <- rel[, !unassigned, drop = FALSE]; taxon <- taxon[!unassigned] }
    agg <- t(rowsum(t(rel), taxon))                       # samples x taxa
    prevalence <- colMeans(agg > 0)
    tibble(Marker = m, Taxon = names(prevalence), Present = prevalence >= PRESENCE_PREVALENCE)
  }) %>% pivot_wider(names_from = Marker, values_from = Present, values_fill = FALSE) %>%
    filter(rbcL | trnL | ITS2)
}
family_presence <- presence_table("Family", keep_unassigned_bins = TRUE)
genus_presence  <- presence_table("Genus",  keep_unassigned_bins = FALSE)
write_table(family_presence, "FigureS2_family_presence_by_marker")
write_table(genus_presence,  "FigureS2_genus_presence_by_marker")

upset_panels <- function(pres, label) {
  sets <- MARKERS
  combos <- expand.grid(lapply(sets, function(s) c(FALSE, TRUE)), stringsAsFactors = FALSE); colnames(combos) <- sets
  combos$n <- apply(combos, 1, function(row) sum(apply(pres[sets], 1, function(p) all(p == as.logical(row)))))
  combos <- combos[rowSums(combos[sets]) > 0 & combos$n > 0, ] %>% arrange(desc(n)) %>% mutate(x = row_number(),
            colour = ifelse(rbcL & trnL & ITS2, "#E07B54", "#2166AC"))
  set_sizes <- colSums(pres[sets])
  bars <- ggplot(combos, aes(x, n, fill = I(colour))) + geom_col(width = 0.65) +
    geom_text(aes(label = n), vjust = -0.4, size = 3.2) +
    scale_x_continuous(breaks = combos$x, expand = expansion(add = 0.6)) + scale_y_continuous(expand = expansion(mult = c(0, 0.18))) +
    labs(x = NULL, y = label, subtitle = paste(sets, set_sizes, sep = " = ", collapse = ", ")) +
    theme_bw(11) + theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), panel.grid.major.x = element_blank(), panel.grid.minor = element_blank())
  dots <- combos %>% select(x, all_of(sets)) %>% pivot_longer(all_of(sets), names_to = "Set", values_to = "Present") %>%
    mutate(y = match(Set, sets))
  segments <- dots %>% filter(Present) %>% group_by(x) %>% summarise(ylo = min(y), yhi = max(y), .groups = "drop") %>% filter(yhi > ylo)
  matrix <- ggplot(dots, aes(x, y)) +
    geom_point(aes(colour = Present), size = 4) +
    geom_segment(data = segments, aes(x = x, xend = x, y = ylo, yend = yhi), colour = "#222222", linewidth = 1.1, inherit.aes = FALSE) +
    scale_colour_manual(values = c(`TRUE` = "#222222", `FALSE` = "#DDDDDD"), guide = "none") +
    scale_x_continuous(breaks = combos$x, expand = expansion(add = 0.6)) +
    scale_y_continuous(breaks = seq_along(sets), labels = sets, limits = c(0.3, length(sets) + 0.3)) +
    labs(x = NULL, y = NULL) + theme_bw(11) +
    theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), panel.grid = element_blank(), axis.text.y = element_text(face = "bold"))
  list(bars = bars, matrix = matrix)
}
fam <- upset_panels(family_presence, "Families (n)"); gen <- upset_panels(genus_presence, "Genera (n)")
figS2 <- (fam$bars + labs(title = "A  Family")) / fam$matrix / (gen$bars + labs(title = "B  Genus")) / gen$matrix + plot_layout(heights = c(2.8, 1, 2.8, 1))
save_figure(figS2, "FigureS2_marker_overlap", 10, 10)

# ---- Table S1: indicator genera --------------------------------------------
# For each genus (prevalence >= MIN_PREVALENCE) and marker:
#   (i)  permutation test of the habitat effect in a rank-based linear model that
#        includes location, with permutations restricted within location;
#   (ii) Wilcoxon rank-sum test on the pooled samples (original analysis);
#   Benjamini-Hochberg adjustment within marker; Cliff's delta pooled and per location.
indicator_one <- function(ps, marker) {
  prof <- rank_profile(ps, marker, "Genus"); md <- sample_info(ps)
  wide <- prof %>% select(SampleID, Taxon, RelAbund) %>% pivot_wider(names_from = Taxon, values_from = RelAbund)
  wide <- wide[match(rownames(md), wide$SampleID), ]
  genera <- setdiff(colnames(wide), "SampleID"); genera <- genera[colMeans(wide[genera] > 0) >= MIN_PREVALENCE]
  families <- taxonomy_df(ps) %>% filter(is_assigned(Genus)) %>% distinct(Genus, Family)
  ctrl <- how(nperm = N_PERM_INDIC, blocks = md$Location)
  map_dfr(genera, function(g) {
    v <- wide[[g]]; up <- v[md$Habitat == "Upland"]; we <- v[md$Habitat == "Wetland"]
    ranks <- rank(v); F_obs <- anova(lm(ranks ~ md$Location + md$Habitat))[2, "F value"]
    set.seed(1)
    F_perm <- replicate(N_PERM_INDIC, {
      shuffled <- md$Habitat[shuffle(length(v), ctrl)]
      anova(lm(ranks ~ md$Location + shuffled))[2, "F value"]
    })
    sub_delta <- function(loc) cliff_delta(v[md$Habitat == "Upland" & md$Location == loc], v[md$Habitat == "Wetland" & md$Location == loc])
    tibble(Marker = marker, Genus = g, Family = families$Family[match(g, families$Genus)],
           Prevalence = round(mean(v > 0), 2),
           Median_wetland = signif(median(we), 3), Median_upland = signif(median(up), 3),
           Cliff_delta = round(cliff_delta(up, we), 2), Cliff_delta_BH = round(sub_delta("BH"), 2), Cliff_delta_HC = round(sub_delta("HC"), 2),
           P_restricted_permutation = (sum(F_perm >= F_obs) + 1) / (N_PERM_INDIC + 1),
           P_wilcoxon_pooled = wilcox.test(up, we, exact = FALSE)$p.value)
  }) %>% mutate(Q_restricted_permutation = p.adjust(P_restricted_permutation, "BH"),
                Q_wilcoxon_pooled = p.adjust(P_wilcoxon_pooled, "BH"),
                Direction = ifelse(Cliff_delta > 0, "Upland > Wetland", "Wetland > Upland"),
                Same_direction_both_locations = sign(Cliff_delta_BH) == sign(Cliff_delta_HC) & Cliff_delta_BH != 0 & Cliff_delta_HC != 0) %>%
    mutate(across(starts_with(c("P_", "Q_")), ~ signif(.x, 3)))
}
indicators <- map_dfr(MARKERS, ~ indicator_one(ps_marker[[.x]], .x)) %>% arrange(factor(Marker, MARKERS), Q_restricted_permutation)
write_table(indicators, "TableS1_indicator_genera_all_tested")
write_table(filter(indicators, Q_restricted_permutation < 0.05 | Q_wilcoxon_pooled < 0.05), "TableS1_indicator_genera_significant")

# consistent multi-marker indicators: significant (restricted test) in >= 2 markers with the same direction
consistent <- indicators %>% filter(Q_restricted_permutation < 0.05) %>%
  group_by(Genus, Direction) %>% summarise(Markers = paste(Marker, collapse = ", "), n_markers = n(), .groups = "drop") %>%
  filter(n_markers >= 2)
write_table(consistent, "TableS1_consistent_multi_marker_indicators")
