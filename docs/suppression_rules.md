# Suppression Rules

## Purpose

This file defines how the project handles suppressed and sparse mortality cells.

## CDC WONDER rule

CDC WONDER suppresses sub-national death counts representing fewer than ten deaths.

## Project policy

Suppressed values must not be imputed silently.

## Primary handling rule

For raw CDC WONDER place-of-death cells:

```text
If count is suppressed, set the numeric count to NA and set `suppressed_cell = TRUE`.
```

For county-year compositions:

```text
If any place-of-death component is suppressed, set `suppressed_any = TRUE`.
```

For derived shares:

```text
Do not calculate final manuscript-weight shares from incomplete suppressed components unless a documented sensitivity method is used.
```

## Stability threshold

Initial planned threshold:

```text
low_count_flag = TRUE if cancer_deaths_total_65plus < 30
```

Rationale:

Even when a total county-year count is not suppressed, small denominators can produce unstable death-place shares.

## Sensitivity options

Permitted sensitivity strategies:

```text
1. Aggregate years 2018-2024 into a pooled county-level estimate.
2. Restrict primary maps/models to counties with total cancer deaths above a predefined threshold.
3. Use empirical-Bayes smoothing, saving both raw and smoothed estimates.
4. Shift to HRR/HSA geography if county-level suppression is too severe.
```

Not permitted:

```text
1. Treat suppressed counts as zero.
2. Replace suppressed values with five without a sensitivity label.
3. Redistribute suppressed other/unknown deaths into known categories.
4. Present smoothed estimates as raw observed values.
```

## Audit fields

Every processed mortality file should include:

```text
suppressed_any
suppressed_cell_count
low_count_flag
composition_complete
smoothing_method
```

## Manuscript language

Required limitation language:

```text
County-level estimates are affected by small-count suppression and sparse mortality cells. Analyses therefore distinguish raw observed counts from suppressed, incomplete, and smoothed estimates.
```
