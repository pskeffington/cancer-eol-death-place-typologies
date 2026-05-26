# Cancer End-of-Life Death-Place Typologies

Open-data health-services research project classifying U.S. county-level cancer end-of-life death-place typologies and examining associations with hospice access, healthcare supply, rurality, socioeconomic context, and regional care intensity.

**Maintainer:** Paul Skeffington, MS, MPH  
**Repository status:** active manuscript scaffold; no analysis results should be treated as final until source extraction, citation validation, and reproducibility checks are complete.  
**Last documentation refresh:** 2026-05-25

## Working manuscript title

**County-Level Typologies of Cancer Place of Death and End-of-Life Care Intensity Among Older Adults in the United States, 2018-2024**

## Study frame

This repository supports a reproducible, open-data study aligned with end-of-life care variation, healthcare efficiency, cancer end-of-life quality, and hospital death typology research.

The primary empirical unit is the county-year. The main cohort is decedents age 65+ whose underlying cause of death is malignant neoplasm, ICD-10 C00-C97.

## Primary data source

- CDC WONDER Multiple Cause of Death, final 2018-2024 public-use mortality data.
- Primary outcome: place of death among older cancer decedents.
- Candidate place categories: inpatient medical facility, outpatient or emergency department, dead on arrival, hospice facility, nursing home/long-term care, decedent home, other, and unknown.

## Supplementary data sources

- Dartmouth Atlas End-of-Life Care.
- CMS Medicare hospice utilization public-use files.
- HRSA Area Health Resources Files.
- American Community Survey 5-year estimates.
- USDA/NCHS rurality or urban-rural classification crosswalks, if needed.

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

## Reproducibility guardrails

- Do not commit restricted, personally identifying, or license-limited data extracts.
- Preserve CDC WONDER query parameters, grouping choices, suppression rules, and download timestamps in `docs/` before producing tables.
- Keep source-to-variable crosswalks separate from analysis outputs so county-year construction can be audited.
- Treat small-cell suppression, county boundary harmonization, and denominator construction as manuscript-relevant analytic decisions.

## Current documentation tasks

- Build a data-source registry with URL, access route, geography, years, variables, and verification status.
- Draft a county-year construction protocol.
- Add a variable map for place-of-death categories, hospice supply, rurality, socioeconomic context, and Dartmouth Atlas linkage fields.
- Add a reproducibility note for any CDC WONDER query that cannot be automated.

## Next execution steps

1. Create source manifests for CDC WONDER and each supplementary dataset.
2. Draft the analytic file specification for county-year records.
3. Build validation checks for ICD-10 cancer decedent counts and place-of-death category totals.
4. Add manuscript-ready table and figure shells only after source extraction is validated.

## Current status

Documentation refreshed on 2026-05-25. The repository remains in scaffold and source-validation mode.
