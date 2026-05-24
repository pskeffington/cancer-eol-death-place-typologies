# Source Validation Log

## Validation status key

```text
pending = source identified but not yet verified
verified = source exists and required fields appear available
partial = source exists but geography, variables, or vintage may not fully support the design
rejected = source unsuitable for this project
replaced = source superseded by a better source
```

## CDC WONDER Multiple Cause of Death

```text
source_id: S01
source_name: CDC WONDER Multiple Cause of Death by Single Race
agency: Centers for Disease Control and Prevention / National Center for Health Statistics
project_role: primary mortality outcome source
release_or_vintage: 2018-2024 final data
geographic_level: county of decedent residence
required_fields: year, county, age group, underlying cause of death, place of death, deaths
validation_status: verified
validated_on: 2026-05-24
notes: Supports the planned extraction for age 65+ cancer deaths by county, year, and place of death. Small-count suppression applies.
```

## Dartmouth Atlas End-of-Life Care

```text
source_id: S02
source_name: Dartmouth Atlas End-of-Life Care
agency: Dartmouth Atlas Project
project_role: regional end-of-life care intensity comparison
release_or_vintage: pending
geographic_level: pending; likely HRR/HSA/state depending on file
required_fields: regional identifier, end-of-life care intensity measures, measure definitions
validation_status: pending
validated_on: pending
notes: Must verify geography, file vintage, and whether county linkage is defensible.
```

## CMS Medicare Hospice Utilization

```text
source_id: S03
source_name: CMS Medicare Hospice Utilization Public Use File
agency: Centers for Medicare & Medicaid Services
project_role: hospice utilization or supply proxy
release_or_vintage: pending
geographic_level: pending
required_fields: provider geography, utilization, beneficiary counts, payment/utilization measures
validation_status: pending
validated_on: pending
notes: Need to determine whether county-level attribution is possible or whether this should remain a state/provider-market contextual measure.
```

## HRSA Area Health Resources Files

```text
source_id: S04
source_name: Area Health Resources Files
agency: Health Resources and Services Administration
project_role: county healthcare supply and facility covariates
release_or_vintage: pending
geographic_level: county
required_fields: county FIPS, hospital beds, workforce, facility, and population context variables
validation_status: pending
validated_on: pending
notes: Version must be frozen before covariate modeling.
```

## American Community Survey 5-year estimates

```text
source_id: S05
source_name: American Community Survey 5-year estimates
agency: U.S. Census Bureau
project_role: county socioeconomic and demographic covariates
release_or_vintage: pending
geographic_level: county
required_fields: poverty, income, education, insurance, disability, age structure, race/ethnicity
validation_status: pending
validated_on: pending
notes: Use 5-year estimates for county-level stability.
```

## Rurality classification

```text
source_id: S06
source_name: NCHS Urban-Rural Classification or USDA RUCC
agency: pending final source selection
project_role: county rurality stratification and adjustment
release_or_vintage: pending
geographic_level: county
required_fields: county FIPS, rurality category/code
validation_status: pending
validated_on: pending
notes: One primary system must be selected; alternate system may be used for sensitivity analysis.
```

## Current validation boundary

The only source currently verified for analytic design is the primary CDC WONDER mortality source. Supplementary sources remain pending and should not support manuscript claims until validated.
