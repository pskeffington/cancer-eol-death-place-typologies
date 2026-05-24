# Roadmap

Cancer End-of-Life Death-Place Typologies

Reviewed: 2026-05-24

## Project frame

This repository supports an open-data health services research project classifying U.S. county-level cancer end-of-life place-of-death typologies and examining whether those typologies vary by hospice access, healthcare supply, rurality, socioeconomic context, and regional end-of-life care intensity.

Working manuscript title:

```text
County-Level Typologies of Cancer Place of Death and End-of-Life Care Intensity Among Older Adults in the United States, 2018-2024
```

Primary analytic unit:

```text
county-year
```

Primary cohort:

```text
decedents age 65+ with underlying cause of death ICD-10 C00-C97
```

Primary outcome family:

```text
place-of-death composition among older cancer decedents
```

## Current repository status

Stage 0 scaffold is complete. The repository has the main README, analysis plan, variable dictionary, source validation log, CDC WONDER extraction notes, place-of-death codebook, suppression rules, and staged GitHub issues.

Stage 1 is partially complete. The primary CDC WONDER design is documented in the repository, and the place-of-death mapping is written. The blocking item is the actual CDC WONDER raw export file and the first reproducible processing script.

No manuscript result should be treated as final until the raw extract, processing script, source validation log, and generated audit outputs are all aligned.

## Object status board

| Object | Status | Repository anchor | Current action |
|---|---|---|---|
| Object 01 | closed | `docs/cdc_wonder_extraction_notes.md` | Keep as source-design record; update only if extraction settings change. |
| Object 02 | open | `analysis/01_build_death_place_composition.R` | Build the primary county-year composition script. |
| Object 03 | open | `docs/variable_dictionary.md`; `data/crosswalks/` | Select NCHS or USDA rurality classification and document the choice. |
| Object 04 | closed | `docs/source_validation_log.md` | Continue updating supplementary source statuses as verified, partial, rejected, or replaced. |
| Object 05 | closed | `docs/place_of_death_codebook.md` | Use as the authoritative death-place mapping for Object 02. |
| Object 06 | open | `docs/covariate_source_notes.md` | Build covariate feasibility notes before merging ACS, HRSA, CMS, or Dartmouth-derived variables. |
| Object 07 | open | `analysis/04_typology_modeling.R` | Defer until Object 02 produces a stable analytic file. |

## Stage 1 — Extraction lock

Goal: lock the primary mortality source design and produce the raw export needed for processing.

### Completed anchors

- `docs/cdc_wonder_extraction_notes.md`
- `docs/place_of_death_codebook.md`
- `docs/suppression_rules.md`
- `docs/source_validation_log.md`

### Remaining work

- Save the raw CDC WONDER export locally under the expected file name.
- Confirm that the raw export field names match the processing-script assumptions.
- Record any manual CDC WONDER query settings not already captured.
- Reconcile the export against the place-of-death codebook.

### Acceptance gate

Stage 1 is complete when the raw source file exists locally and a processing script can load it from project root without manual editing.

## Stage 2 — Primary mortality analytic file

Goal: produce a reproducible county-year death-place composition file.

### Required object

```text
analysis/01_build_death_place_composition.R
```

### Expected inputs

```text
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2018_2024.txt
```

### Expected outputs

```text
data/processed/cancer_eol_death_place_composition_county_year.csv
outputs/death_place_composition_audit.csv
```

### Minimum transformations

- Read the raw CDC WONDER tab-delimited export.
- Standardize state, county, year, and FIPS fields.
- Normalize place-of-death categories against `docs/place_of_death_codebook.md`.
- Pivot death counts from long to wide format.
- Calculate death-place shares.
- Preserve suppressed cells as missing, not zero.
- Flag suppression, sparse denominators, incomplete composition, and share-sum failures.
- Save both analytic output and audit output.

### Acceptance gate

Stage 2 is complete when all complete county-years have death-place shares that sum to 1.0 within a documented tolerance and all incomplete county-years are explicitly flagged.

## Stage 3 — Rurality and covariate source lock

Goal: define the county-level predictors before model construction.

### Required objects

```text
docs/covariate_source_notes.md
data/crosswalks/county_rurality_crosswalk.csv
analysis/02_build_covariates.R
```

### Decision points

- Select one primary rurality classification.
- Identify one sensitivity rurality option or reject alternatives explicitly.
- Select ACS 5-year socioeconomic variables.
- Select HRSA AHRF healthcare-supply variables.
- Determine whether CMS hospice data can support county-level inference or must remain a provider/state/regional contextual measure.
- Determine whether Dartmouth Atlas measures can be linked defensibly at HRR/HSA level rather than county level.

### Acceptance gate

Stage 3 is complete when every candidate covariate has a source, vintage, geography, join key, interpretation boundary, and validation status.

## Stage 4 — Dartmouth Atlas linkage

Goal: compare death-place typologies with regional end-of-life care intensity only where geography permits.

### Required objects

```text
docs/dartmouth_atlas_linkage_notes.md
analysis/03_build_dartmouth_linkage.R
data/crosswalks/county_hrr_crosswalk.csv
data/processed/dartmouth_eol_intensity_linked.csv
```

### Acceptance gate

Stage 4 is complete when the Atlas measure definition, geography, linkage method, linkage loss, and interpretation boundary are documented.

## Stage 5 — Typology modeling

Goal: classify counties into interpretable cancer end-of-life death-place typologies.

### Required object

```text
analysis/04_typology_modeling.R
```

### Candidate approaches

- k-means clustering on standardized death-place shares
- hierarchical clustering
- latent class analysis
- Dirichlet mixture modeling if composition structure warrants it

### Expected outputs

```text
outputs/typology_model_diagnostics.csv
data/processed/county_typology_assignments.csv
figures/typology_profile_plot.png
```

### Acceptance gate

Stage 5 is complete when the selected method is reproducible, stable under sensitivity checks, and class labels are interpretable from observed death-place profiles rather than imposed narratives.

## Stage 6 — Association modeling

Goal: estimate structural associations with hospital-death share and typology membership.

### Required object

```text
analysis/05_association_models.R
```

### Primary outcome candidates

```text
share_hospital
typology_class
```

### Primary predictor families

```text
rurality
hospice supply or utilization proxy
hospital and physician supply
socioeconomic context
population age structure
regional care-intensity measure, if defensibly linked
```

### Acceptance gate

Stage 6 is complete when models are pre-specified, missingness and collinearity are audited, and all claims are framed as ecological associations rather than causal effects.

## Stage 7 — Publication tables and figures

Goal: generate manuscript-ready outputs from scripts only.

### Required objects

```text
analysis/06_make_tables.R
analysis/07_make_figures.R
tables/table_1_sample_characteristics.tex
tables/table_2_typology_profiles.tex
tables/table_3_regression_results.tex
figures/figure_1_hospital_death_share_map.png
figures/figure_2_typology_map.png
```

### Acceptance gate

Stage 7 is complete when every table value and figure element traces to a generated processed file, and every output includes suppression or missingness notes where relevant.

## Stage 8 — Manuscript assembly

Goal: assemble the first defensible LaTeX manuscript draft.

### Required objects

```text
manuscript/main.tex
manuscript/references.bib
manuscript/sections/introduction.tex
manuscript/sections/methods.tex
manuscript/sections/results.tex
manuscript/sections/discussion.tex
```

### Acceptance gate

Stage 8 is complete when every factual claim is cited or generated, every citation is verified, no simulated citation remains, and limitations explicitly address ecological inference, small-count suppression, county-level instability, and regional linkage boundaries.

## Stage 9 — Reproducibility and pre-release

Goal: prepare a contributor-review pre-release.

### Required objects

```text
CHANGELOG.md
CITATION.cff
CONTRIBUTING.md
docs/reproducibility_checklist.md
```

### Target release

```text
v0.1.0-pre.0
```

### Acceptance gate

Stage 9 is complete when a fresh clone can run the documented workflow, public-data download steps are explicit, generated outputs can be reproduced, and release notes clearly distinguish scaffold, validated source design, and non-final analytic results.

## Immediate execution queue

1. Place the raw CDC WONDER export in `data/raw/` using the expected filename.
2. Build `analysis/01_build_death_place_composition.R`.
3. Generate `outputs/death_place_composition_audit.csv`.
4. Update `docs/source_validation_log.md` after supplementary source checks.
5. Complete `docs/covariate_source_notes.md`.
6. Select and add the rurality crosswalk.
7. Begin typology modeling only after the composition file and audit pass.

## Current hard stops

- Do not model typologies before Object 02 is complete.
- Do not write manuscript results before generated tables and figures exist.
- Do not treat Dartmouth Atlas linkage as county-level unless the geography and crosswalk are explicitly defensible.
- Do not use CMS hospice utilization as a county predictor until the geography and attribution problem are resolved.
- Do not impute suppressed CDC WONDER cells silently.
