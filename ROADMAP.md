# Roadmap

Cancer End-of-Life Death-Place Typologies

## Current status

Stage 0 scaffold is complete. The project has a repository structure, protocol, data-source registry, variable dictionary, analysis plan, citation-audit template, and initial R setup script.

## Stage 1 — Source validation and extraction lock

Goal: lock the primary data design before modeling.

### Objects

- `docs/cdc_wonder_extraction_notes.md`
- `docs/source_validation_log.md`
- `docs/place_of_death_codebook.md`
- `docs/suppression_rules.md`

### Acceptance gates

- CDC WONDER years confirmed.
- ICD-10 C00-C97 cancer case definition confirmed.
- Age 65+ extraction confirmed.
- County-year extraction feasibility confirmed.
- Place-of-death field values mapped to project variables.
- Suppression rules documented.
- No manuscript-weight claim remains tied to an unverified data source.

## Stage 2 — Primary mortality analytic file

Goal: produce a reproducible county-year death-place composition file.

### Objects

- `analysis/01_build_death_place_composition.R`
- `data/processed/cancer_eol_death_place_composition_county_year.csv`
- `outputs/death_place_composition_audit.csv`

### Acceptance gates

- Raw extract loads without manual editing.
- County FIPS are standardized as five-character strings.
- Place-of-death categories are normalized.
- Total deaths reconcile against source totals.
- Death-place shares sum to 1.0 where complete.
- Suppressed or unstable counties are explicitly flagged.

## Stage 3 — Covariate build

Goal: add county-level healthcare supply, socioeconomic, and rurality predictors.

### Objects

- `analysis/02_build_covariates.R`
- `data/crosswalks/county_rurality_crosswalk.csv`
- `data/processed/county_covariates.csv`
- `docs/covariate_source_notes.md`

### Acceptance gates

- Rurality classification selected and documented.
- ACS variables selected and mapped.
- HRSA AHRF variables selected and mapped.
- Hospice proxy source evaluated.
- All joins pass FIPS completeness checks.

## Stage 4 — Dartmouth Atlas linkage

Goal: link county-year death-place outcomes to regional end-of-life care intensity measures where defensible.

### Objects

- `analysis/03_build_dartmouth_linkage.R`
- `data/crosswalks/county_hrr_crosswalk.csv`
- `data/processed/dartmouth_eol_intensity_linked.csv`
- `docs/dartmouth_atlas_linkage_notes.md`

### Acceptance gates

- Atlas measure definitions verified.
- Geographic level documented.
- County-to-HRR or county-to-HSA linkage method documented.
- Linkage loss quantified.
- Analysis boundary written if linkage is imperfect.

## Stage 5 — Typology modeling

Goal: classify counties into interpretable end-of-life death-place typologies.

### Objects

- `analysis/04_typology_modeling.R`
- `outputs/typology_model_diagnostics.csv`
- `data/processed/county_typology_assignments.csv`
- `figures/typology_profile_plot.png`

### Acceptance gates

- Candidate typology methods compared.
- Final method selected on interpretability and stability.
- Class labels are defensible from observed death-place shares.
- Sparse-count sensitivity check completed.
- Typology assignment file generated.

## Stage 6 — Association models

Goal: estimate structural associations with hospital-death share and typology membership.

### Objects

- `analysis/05_association_models.R`
- `outputs/model_hospital_death_share.csv`
- `outputs/model_typology_membership.csv`
- `tables/table_regression_results.tex`

### Acceptance gates

- Primary model specified before results interpretation.
- Covariates checked for missingness and collinearity.
- County clustering/state or HRR adjustment handled transparently.
- Results framed as association, not causation.
- Sensitivity models run and archived.

## Stage 7 — Figures and tables

Goal: generate publication-ready descriptive outputs.

### Objects

- `analysis/06_make_tables.R`
- `analysis/07_make_figures.R`
- `tables/table_1_sample_characteristics.tex`
- `tables/table_2_typology_profiles.tex`
- `tables/table_3_regression_results.tex`
- `figures/figure_1_hospital_death_share_map.png`
- `figures/figure_2_typology_map.png`

### Acceptance gates

- Tables compile cleanly in LaTeX.
- Figures are reproducible from scripts.
- Maps include missingness and suppression notes.
- All table values trace to processed analytic files.

## Stage 8 — Manuscript assembly

Goal: create the first defensible manuscript draft.

### Objects

- `manuscript/main.tex`
- `manuscript/references.bib`
- `manuscript/sections/introduction.tex`
- `manuscript/sections/methods.tex`
- `manuscript/sections/results.tex`
- `manuscript/sections/discussion.tex`

### Acceptance gates

- Every factual claim is either cited or tied to a generated result.
- No simulated citations.
- No causal overclaiming.
- Tables and figures are called from generated fragments.
- Limitations explicitly address ecological design, suppression, and geography linkage.

## Stage 9 — Reproducibility and release

Goal: prepare a contributor-review pre-release.

### Objects

- `CHANGELOG.md`
- `CITATION.cff`
- `CONTRIBUTING.md`
- `docs/reproducibility_checklist.md`
- GitHub release `v0.1.0-pre.0`

### Acceptance gates

- Fresh clone can run setup.
- Scripts execute in order or documented manual source-download steps are clear.
- Outputs regenerate from public data.
- README accurately describes current state.
- Pre-release notes identify non-final limitations.

## Immediate next actions

1. Complete CDC WONDER source validation.
2. Write `docs/cdc_wonder_extraction_notes.md`.
3. Build `analysis/01_build_death_place_composition.R` against the expected raw extract schema.
4. Select the rurality classification.
5. Open issues for Stages 4-9 after Stage 1 extraction is validated.
