# Place-of-Death Codebook

## Purpose

This file defines the mapping from CDC WONDER raw place-of-death categories to analytic death-place outcome variables.

## Raw CDC WONDER categories

```text
Medical Facility - Inpatient
Medical Facility - Outpatient or ER
Medical Facility - Dead on Arrival
Decedent's home
Hospice Facility
Nursing home/long term care
Other
Place of death unknown
```

## Primary analytic mapping

| Raw category | Derived category | Derived variable |
|---|---|---|
| Medical Facility - Inpatient | hospital | `deaths_inpatient` |
| Medical Facility - Outpatient or ER | hospital | `deaths_outpatient_er` |
| Medical Facility - Dead on Arrival | hospital | `deaths_doa` |
| Decedent's home | home | `deaths_home` |
| Hospice Facility | hospice facility | `deaths_hospice_facility` |
| Nursing home/long term care | nursing/LTC | `deaths_nursing_ltc` |
| Other | other/unknown | `deaths_other_unknown` |
| Place of death unknown | other/unknown | `deaths_other_unknown` |

## Primary hospital-death definition

```text
hospital_deaths_primary = deaths_inpatient + deaths_outpatient_er + deaths_doa
share_hospital = hospital_deaths_primary / cancer_deaths_total_65plus
```

Rationale:

The primary definition captures deaths occurring in or immediately upon arrival to a medical-facility setting.

## Sensitivity hospital-death definition

```text
hospital_deaths_sensitivity = deaths_inpatient + deaths_outpatient_er
share_hospital_excluding_doa = hospital_deaths_sensitivity / cancer_deaths_total_65plus
```

Rationale:

Dead-on-arrival deaths may reflect prehospital collapse rather than end-of-life treatment intensity inside the hospital. Excluding DOA tests whether results depend on that classification.

## Home-death definition

```text
share_home = deaths_home / cancer_deaths_total_65plus
```

Interpretation boundary:

Home death does not necessarily mean hospice care was used at home.

## Hospice-facility death definition

```text
share_hospice_facility = deaths_hospice_facility / cancer_deaths_total_65plus
```

Interpretation boundary:

Hospice facility death identifies a licensed hospice facility as the location of death. It does not capture hospice services delivered in the decedent's home, nursing facility, or hospital unless the death-place field records hospice facility.

## Nursing/LTC death definition

```text
share_nursing_ltc = deaths_nursing_ltc / cancer_deaths_total_65plus
```

## Other/unknown definition

```text
share_other_unknown = deaths_other_unknown / cancer_deaths_total_65plus
```

This category should be reported separately in audit outputs and not silently redistributed across known locations.

## Typology input variables

Primary typology model should begin with:

```text
share_hospital
share_home
share_hospice_facility
share_nursing_ltc
share_other_unknown
```

A sensitivity typology model may use:

```text
share_hospital_excluding_doa
share_home
share_hospice_facility
share_nursing_ltc
share_other_unknown
```
