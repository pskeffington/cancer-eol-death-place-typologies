# Cancer End-of-Life Death-Place Typologies

Open-data health services research project classifying U.S. county-level cancer end-of-life death-place typologies and examining associations with hospice access, healthcare supply, rurality, socioeconomic context, and regional care intensity.

## Working manuscript title

**County-Level Typologies of Cancer Place of Death and End-of-Life Care Intensity Among Older Adults in the United States, 2018-2024**

## Study frame

This repository supports a reproducible, open-data study aligned with end-of-life care variation, healthcare efficiency, cancer end-of-life quality, and hospital death typology research.

The primary empirical unit is the county-year. The main cohort is decedents age 65+ whose underlying cause of death is malignant neoplasm, ICD-10 C00-C97.

## Primary data source

- CDC WONDER Multiple Cause of Death, final 2018-2024 public-use mortality data
- Primary outcome: place of death among older cancer decedents
- Candidate place categories: inpatient medical facility, outpatient or emergency department, dead on arrival, hospice facility, nursing home/long-term care, decedent home, other, unknown

## Supplementary data sources

- Dartmouth Atlas End-of-Life Care
- CMS Medicare hospice utilization public-use files
- HRSA Area Health Resources Files
- American Community Survey 5-year estimates
- USDA/NCHS rurality or urban-rural classification crosswalks, if needed

## Primary aims

1. Classify counties into cancer end-of-life death-place typologies.
2. Examine whether typologies vary by healthcare supply, hospice access, socioeconomic context, and rurality.
3. Compare county-level death-place typologies with Dartmouth Atlas end-of-life care intensity measures.

## Repository structure

```text
analysis/       Reproducible scripts
code/           Reusable helper functions
data/           Local data staging; raw data excluded from Git where large or restricted
  raw/          Original source files
  processed/    Cleaned analytic files
  crosswalks/   FIPS, HRR, HSA, rurality, and geography crosswalks
docs/           Protocols, data-source notes, variable maps, validation logs
figures/        Exported figures and maps
manuscript/     LaTeX manuscript workspace
outputs/        Model outputs and diagnostics
tables/         Publication-ready table fragments
```

## Current status

Initial scaffold. No analysis results should be treated as final until source extraction, citation validation, and reproducibility checks are complete.
