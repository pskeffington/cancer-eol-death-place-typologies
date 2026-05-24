# Raw Data Handoff

## Required manual export

The primary build script expects the following local file:

```text
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2018_2024.txt
```

## Extraction object

CDC WONDER Multiple Cause of Death by Single Race, 2018-2024 final data.

## Required query frame

```text
Years: 2018-2024
Age: 65+ years
Underlying cause of death: ICD-10 C00-C97
Group by: County, Year, Place of Death
Measure: Deaths
Export format: tab-delimited text
```

## Required file handling

1. Export the CDC WONDER table as a tab-delimited text file.
2. Save the file exactly as:

```text
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2018_2024.txt
```

3. Do not manually edit the exported table.
4. Keep any CDC WONDER notes/footnotes in the file; the script is designed to detect the tabular block.
5. Run:

```r
source("analysis/01_build_death_place_composition.R")
```

## Expected script outputs

```text
data/processed/cancer_eol_death_place_composition_county_year.csv
outputs/death_place_composition_audit.csv
```

## Failure states

The script should stop if:

```text
- the raw file is missing;
- the tabular header cannot be detected;
- required columns are absent;
- county/year/place/death fields cannot be normalized.
```

## Completion standard for Object 02

Object 02 should remain open until the script has been run against a real CDC WONDER export and the audit file confirms that rows, years, suppression flags, and place-of-death categories are valid.
