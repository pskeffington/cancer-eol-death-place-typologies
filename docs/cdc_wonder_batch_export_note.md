# CDC WONDER Batch Export Note

Reviewed: 2026-05-24

## Problem

The full Object 02 request can exceed the CDC WONDER maximum row limit.

Observed request message:

```text
This request produces 131,746 rows, but 75,000 is the maximum allowed.
```

## Decision

Do not reduce scientific scope by grouping at region or race. Keep the required layout:

```text
Group Results By: County
And By: Year
And By: Place of Death
```

Split the request by year instead.

## Annual batch files

Run the same request seven times, selecting one year at a time:

```text
2018
2019
2020
2021
2022
2023
2024
```

Save the exports as:

```text
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2018.txt
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2019.txt
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2020.txt
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2021.txt
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2022.txt
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2023.txt
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2024.txt
```

## Merge rule

The processing script must read all files matching:

```text
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_*.txt
```

Batch files must not overlap by year. Overlap would double-count county-year-place rows.
