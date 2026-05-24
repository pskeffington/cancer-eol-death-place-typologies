# CDC WONDER Two-Batch Export Note

Reviewed: 2026-05-24

## Current extraction split

The Object 02 CDC WONDER request exceeded the 75,000-row limit when run as one national 2018-2024 file. The current practical split is acceptable:

```text
Batch 1: 2018-2020
Batch 2: 2021-2024
```

Keep the scientific layout unchanged for both batches:

```text
Group Results By: County
And By: Year
And By: Place of Death
```

## Required batch filenames

Save the two CDC WONDER tab-delimited exports as:

```text
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2018_2020.txt
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2021_2024.txt
```

Do not overlap years between the two files.

## Required filters for both batches

Use the same filters in both requests except for year selection:

```text
Age: 65-74 years, 75-84 years, 85+ years
Underlying Cause of Death: C00-C97 malignant neoplasms
Sex: All
Race: All Races
Hispanic Origin: All Origins
Place of Death: All Places
Multiple Cause of Death: All / blank
Show Totals: unchecked
Show Zero Values: checked, if available
Show Suppressed Values: checked
Export Results: checked
Export Type: tab-delimited text
```

## Local combine rule

The processing script currently expects one canonical raw file:

```text
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2018_2024.txt
```

Use the companion local combine script before Object 02 processing:

```bash
Rscript analysis/00_combine_cdc_wonder_batches.R
Rscript analysis/01_build_death_place_composition.R
```

## Expected result

The combine script reads both raw CDC WONDER exports, removes repeated table headers and WONDER footnotes, and writes the canonical 2018-2024 raw file for Object 02.
