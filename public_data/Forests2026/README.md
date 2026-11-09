# Analysis code: Wetland–Upland Differentiation of Soil Plant eDNA Across Three Markers at Two Korean Forest Wetlands

R code and processed data to reproduce all statistical analyses, tables and figures of the manuscript (Forests, manuscript forests-4631211). Raw sequencing reads are available in the NCBI Sequence Read Archive under BioProject PRJNA1480349.

## Contents

```
run_all.R                  runs the whole pipeline (Rscript run_all.R)
R/00_setup.R               packages, constants (rarefaction depths, seed, permutations), helper functions
R/01_data_import.R         data import, phyloseq objects, rarefaction; Table S2, Table S3, Figure 1, Figure S1
R/02_alpha_diversity.R     alpha diversity, mixed models, contrasts, diagnostics, sensitivity; Table 1, Table 3 (alpha correlations), Table S4a-c, Figure 2, Figure S5
R/03_beta_diversity.R      PERMANOVA (free and location-restricted permutations), PERMDISP, PCoA; Table 2, Table S5, Figure 3
R/04_marker_congruence.R   Mantel, Procrustes/PROTEST, analyses within subsets; Table 3, Table S6, Figure 5, Figure 6
R/05_taxonomic_composition.R  taxonomic profiles, marker overlap, indicator genera; Figure 4, Figure S2, Figure S3, Table S1
data/                      input data (see below)
output/tables, output/figures   created by the scripts
```

## Data

| File | Content |
|---|---|
| `data/sample_metadata.tsv` | 24 soil samples: `SampleID`, `Location` (BH = Bonghwa, HC = Hapcheon), `Habitat` (Wetland, Upland) |
| `data/<marker>_otu_table.tsv` | OTU read counts (97% OTUs) per sample for `rbcL`, `trnL` and `ITS2`; rows = OTUs, columns = samples |
| `data/<marker>_taxonomy.tsv` | consensus taxonomy of each OTU (Kingdom to Species); unresolved ranks are given as `<parent>_un` or left empty |

Sample IDs encode location (B = BH, H = HC), habitat (I = wetland interior, O = upland outside the wetland) and replicate number (1–6). OTU tables and taxonomy were produced upstream with QIIME 2 (DADA2 denoising, VSEARCH 97% clustering) and web BLAST searches of the NCBI nucleotide collection, as described in the Methods of the manuscript; those steps are not part of this repository.

## Requirements

R (>= 4.3) with the packages phyloseq (Bioconductor), vegan, permute, lme4, lmerTest, pbkrtest, emmeans, dplyr, tidyr, purrr, tibble, ggplot2 and patchwork (CRAN). `R/00_setup.R` checks for these packages and installs any that are missing (phyloseq via BiocManager), so no manual installation is needed; an internet connection is required the first time. To install everything by hand instead:

```r
install.packages(c("vegan", "permute", "lme4", "lmerTest", "pbkrtest", "emmeans",
                   "dplyr", "tidyr", "purrr", "tibble", "ggplot2", "patchwork", "BiocManager"))
BiocManager::install("phyloseq")
```

The results in the manuscript were produced with R 4.5.2, phyloseq 1.54.2, vegan 2.7.3, permute 0.9.10, lme4 1.1.38, lmerTest 3.1.3, emmeans 2.0.1, ggplot2 4.0.3 and patchwork 1.3.2 (see `output/session_info.txt` after a run).

## How to run

From the repository root:

```
Rscript run_all.R
```

Each script in `R/` can also be sourced on its own; it loads the data automatically if needed. A full run takes a few minutes (the permutation tests dominate). All random steps use a fixed seed (123), so the outputs are reproducible.

## Analysis settings

* Rarefaction without replacement to marker-specific depths (rbcL 10,000; trnL 21,000; ITS2 17,000 reads); all 24 samples are retained for every marker. Alpha diversity analyses are repeated at a common depth of 10,000 reads.
* Alpha diversity: observed OTU richness (Hill number q = 0), Shannon diversity (q = 1), Pielou's evenness, genus-level richness and metrics after excluding Pinopsida OTUs; linear mixed models `Alpha ~ Habitat * Marker + Location + (1 | SampleID)` with Type III F-tests (Kenward–Roger df) and unadjusted wetland–upland contrasts within marker.
* Beta diversity: Bray–Curtis dissimilarity on relative abundances; sequential PERMANOVA `Location + Habitat + Location:Habitat` with free permutations and with permutations restricted within location; habitat tests within each location; PERMDISP for habitat type, location, and location within each habitat type.
* Inter-marker congruence: Spearman Mantel tests and Procrustes/PROTEST on the first two PCoA axes and on all axes with positive eigenvalues (Lingoes correction), for all samples and within locations and habitat types.
* Marker overlap (Figure S2): a taxon counts as detected by a marker if it occurs in at least 5% of that marker's samples; at family level, OTUs without a family assignment are kept as "Unassigned_Family_within_<parent taxon>" bins, at genus level only assigned genera are counted.
* Indicator genera: genera with prevalence >= 10%; permutation test of the habitat term in a rank-based model including location (permutations restricted within location) and Wilcoxon rank-sum tests on pooled samples; Benjamini–Hochberg adjustment within marker; Cliff's delta pooled and per location.
* Permutations: 999 (PERMANOVA, PERMDISP, indicator tests), 9,999 (Mantel, PROTEST).

## Output files

Tables (`output/tables/*.csv`) and figures (`output/figures/*.pdf|png`) are named after the manuscript items they support (for example `Table2_PERMANOVA.csv`, `Figure3_PCoA.pdf`). Figure S4 (workflow diagram) is a schematic and is not generated by this code.
