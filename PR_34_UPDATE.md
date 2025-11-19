# PR #34 Title and Description Update

## Recommended PR Title
```
feat: Add growth standards data and HStandard package (Phase 03)
```

## Recommended PR Description

```markdown
## Overview
Implements growth standards data parsing and storage as part of Phase 03 of the BabyMilestones project.

Closes #33

## Changes

### New Package: HStandard
- Created `app-ios/Packages/HStandard` Swift package for growth standard types and data
- Defined core data models:
  - `GrowthReference`: Age-based percentile values for height, weight, BMI, and head circumference
  - `WeightForHeightReference`: Height-based weight percentiles
  - `BiologicalSex`: Male/Female enumeration
  - `PercentileValues`: Generic type for P3, P10, P25, P50, P75, P90, P97 percentiles
- Phantom types for measurement units (Centimeter, Kilogram, BMI)

### Growth Reference Data
- Extracted data from `/resource/prc-wst-423-2022.pdf` into structured Swift arrays
- Male reference data: 45 age points (0-81 months)
- Female reference data: 45 age points (0-81 months)
- Weight-for-height tables for both genders (under 2 years and 2-7 years)
- All data includes 7 percentile points as per Chinese MOH WS/T 423-2022 standard

### Data Extraction Tools
- Added `.github/prompts/extractData.prompt.md` for AI-assisted data extraction from PDF tables
- Created CSV files in `/resource/` with cleaned percentile data:
  - Age-based: height, weight, BMI, head circumference (0-36 months)
  - Height-based: weight percentiles for different age ranges

### Integration
- Integrated HStandard package into main BabyMeasure project
- Added package references to Xcode project and test target

## Technical Details
- Uses phantom types for compile-time unit safety
- Data hardcoded in Swift for performance and offline access
- Follows Chinese Ministry of Health growth standards (WS/T 423-2022)
- Percentile values stored as Double for interpolation support

## Next Steps
This PR provides the foundation for:
- [ ] Implementing query interface with interpolation (remaining Phase 03 work)
- [ ] Growth chart visualization (Phase 04)
- [ ] Percentile calculation for recorded measurements

## Testing
- Basic package structure test included
- Full query interface tests to be added in follow-up PR

---
**Related Issues:** #33 
**Phase:** Phase 03 - Growth Standards Parsing and Query System
```

## Summary

This PR addresses issue #33 by implementing the data layer for growth standards. The PR:

1. **Creates a new Swift package** (`HStandard`) with type-safe data models
2. **Extracts and structures growth data** from the WHO/MOH PDF standards document
3. **Provides CSV source data** for transparency and future updates
4. **Integrates the package** into the main project

The current PR focuses on the data foundation. The query interface and interpolation logic mentioned in issue #33 should be implemented in a follow-up PR to keep changes focused and reviewable.

## GitHub PR Update Instructions

Since the agent cannot directly update the PR title and description through git commands, the repository owner should manually update PR #34 with:

1. **Title:** `feat: Add growth standards data and HStandard package (Phase 03)`
2. **Description:** Use the markdown content provided above

This will properly link the PR to issue #33 and provide clear context for reviewers.
