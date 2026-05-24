# Project Protocol

## Project

Cancer End-of-Life Death-Place Typologies

## Working title

County-Level Typologies of Cancer Place of Death and End-of-Life Care Intensity Among Older Adults in the United States, 2018-2024

## Rationale

End-of-life cancer care varies across regions, systems, and local healthcare markets. Hospital death, home death, hospice-facility death, and nursing-home death are observable death-certificate outcomes that can be analyzed using open national data. This project uses those outcomes to classify county-level end-of-life system patterns and evaluate whether those patterns align with healthcare supply, hospice access, rurality, socioeconomic conditions, and regional care intensity.

## Research design

Ecological, county-year, open-data health services study.

## Population

U.S. decedents age 65 years and older with malignant neoplasm as the underlying cause of death.

## Case definition

- Age: 65+
- Years: 2018-2024
- Underlying cause of death: ICD-10 C00-C97
- Geography: county-year where permitted by suppression rules

## Primary outcome domain

Place of death.

Candidate operational categories:

- Hospital or medical facility inpatient
- Medical facility outpatient or emergency department
- Dead on arrival
- Hospice facility
- Nursing home or long-term care facility
- Decedent home
- Other
- Unknown

## Primary analytic outputs

1. County-year death-place composition file.
2. County typology assignment file.
3. County/HRR-level comparison with end-of-life care intensity measures.
4. Maps and descriptive tables.
5. Regression models estimating associations between typology/outcome shares and county structural predictors.

## Candidate typologies

- Hospital-dominant
- Home-dominant
- Hospice-facility-dominant
- Nursing-home/LTC-dominant
- Mixed-pattern
- Sparse/unstable-count category, if needed

## Primary predictors

- Hospice supply and utilization proxy measures
- Hospital supply and bed availability
- Primary care and specialty workforce
- Rurality or urban-rural classification
- County age structure
- Race/ethnicity composition
- Poverty, income, education, disability, and insurance context
- Dartmouth Atlas end-of-life care intensity indicators where geographically linkable

## Statistical plan

- Descriptive county-year rates and shares
- Empirical Bayes or Bayesian smoothing for sparse counties, if needed
- Clustering or latent class analysis on death-place shares
- Fractional logit or beta regression for hospital-death share
- Multinomial or Dirichlet-multinomial models for full death-place composition
- Sensitivity analysis by age threshold, cancer subtype, rurality, and suppression rules

## Interpretation boundary

This is not a causal design. Results should be framed as geographic patterning and structural association, not causal effects of hospice supply or local healthcare capacity.

## Minimum defensibility standard

No table, claim, or manuscript result is final until:

- Source URL is recorded.
- Dataset vintage is recorded.
- Extraction parameters are saved.
- Variable definitions are documented.
- Suppression rules are documented.
- Reproducibility script can rebuild the analytic file.
- Manuscript claims are linked to output tables or verified source documents.
