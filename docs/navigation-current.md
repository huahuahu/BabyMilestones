# BabyMilestones - Current Navigation Structure

> **Last Updated**: December 24, 2025  
> **Status**: MVP Implementation

## Overview

This document describes the **current implemented** navigation structure of the BabyMilestones iOS app. For the planned full navigation architecture, see [navigation-plan.md](navigation-plan.md).

## Current Architecture

The app currently uses a **single-screen NavigationStack** approach rather than the planned TabView structure. This reflects the MVP focus on core growth tracking functionality.

## Navigation Hierarchy

```
BabyMeasureApp
└── RootView (NavigationStack)
    ├── ChildHeader (Menu)
    │   ├── Child Selection (per child)
    │   └── Edit Profile → EditChildView (Sheet)
    │
    ├── RecordHistoryView (Main Content)
    │   └── Measurement Records (List with swipe-to-delete)
    │
    └── Toolbar Actions
        ├── Export → ExportView (Sheet)
        ├── Growth Chart → GrowthChartView (Push Navigation)
        ├── Add Child → AddChildSheet (Sheet)
        └── New Record → RecordEntryView (Sheet)
```

## Screen Inventory

### 1. RootView
**Type**: Root NavigationStack  
**Purpose**: Main app entry point and primary navigation container

**Features**:
- Child selection header with dropdown menu
- Record history display
- Toolbar with export, chart, add child, and record entry actions

**State Management**:
- `@State private var selectedChildState` - Tracks currently selected child
- `@State private var showingAddChild` - Controls add child sheet visibility
- `@State private var showingAddRecord` - Controls record entry sheet visibility
- `@State private var showingExport` - Controls export sheet visibility

---

### 2. ChildHeader
**Type**: Component with Menu  
**Purpose**: Display and switch between children

**Features**:
- Avatar display (from local storage)
- Child name with dropdown indicator
- Menu for switching between children
- Edit profile option opens EditChildView sheet

**Interactions**:
- Tap → Opens dropdown menu
- Select child → Updates `selectedChildState`
- Edit Profile → Opens `EditChildView` sheet

---

### 3. RecordHistoryView
**Type**: Content View  
**Purpose**: Display measurement history for selected child

**Features**:
- Grouped list by date (descending)
- Shows measurement type, value, and unit
- Swipe-to-delete functionality
- Empty state when no records exist

**Data**:
- Queries `MeasurementEntity` filtered by current child

---

### 4. GrowthChartView
**Type**: Push Navigation Destination  
**Navigation**: `NavigationLink` from toolbar  
**Purpose**: Visualize growth data with percentile charts

**Features**:
- Segmented picker for measurement type (Height/Weight/Head)
- Time range selector (3 months / 1 year / All)
- Charts visualization with:
  - Standard percentile curves (P3, P10, P25, P50, P75, P90, P97)
  - User measurement points
- Age-based X-axis formatting

**Dependencies**:
- `GrowthChartDataService` for percentile data
- Swift Charts framework

---

### 5. AddChildSheet
**Type**: Sheet Presentation  
**Purpose**: Create a new child profile

**Features**:
- Name text field (required)
- Gender picker (Male/Female/Unspecified)
- Birthday date picker (cannot be in future)
- Form validation with error messages
- Cancel/Save toolbar actions

**Navigation**:
- Cancel → Dismisses sheet
- Save → Creates `ChildEntity`, dismisses sheet

---

### 6. RecordEntryView
**Type**: Sheet Presentation  
**Purpose**: Add a new measurement record

**Features**:
- Measurement type segmented picker (Height/Weight/Head Circumference)
- Value input with decimal keyboard
- Date picker (constrained to child's lifetime)
- Range validation warnings
- Auto-focus on value field

**Navigation**:
- Cancel → Dismisses sheet
- Save → Creates `MeasurementEntity`, dismisses sheet

---

### 7. EditChildView
**Type**: Sheet Presentation  
**Purpose**: Edit existing child profile or delete child

**Features**:
- Avatar picker (PhotosPicker integration)
- Name editing
- Gender picker
- Birthday picker
- Delete child option with confirmation alert
- Cascading delete of related measurements

**Navigation**:
- Cancel → Dismisses sheet
- Save → Updates `ChildEntity`, dismisses sheet
- Delete → Confirmation alert → Removes child and records → Dismisses sheet

---

### 8. ExportView
**Type**: Sheet Presentation  
**Purpose**: Export data in CSV or JSON format

**Features**:
- Format picker (CSV/JSON)
- Scope picker (All children / Single child)
- Child selector for single export
- Export state handling (idle/exporting/success/failure)
- ShareLink for sharing exported file
- Retry capability on failure

**States**:
- `idle` → Ready to export
- `exporting` → Generating file
- `success` → Shows share button
- `failure` → Shows error with retry option

---

## Navigation Patterns Used

### 1. NavigationStack (Primary)
```swift
NavigationStack {
    // Main content
}
```
Used as the root container in `RootView`.

### 2. NavigationLink (Push)
```swift
NavigationLink("曲线", destination: GrowthChartView(child: child))
```
Used for navigating to `GrowthChartView` from toolbar.

### 3. Sheet Presentation
```swift
.sheet(isPresented: $showingAddChild) {
    AddChildSheet()
        .presentationDetents([.medium, .large])
}
```
Used for modal presentations of forms and dialogs.

### 4. Menu (Dropdown)
```swift
Menu {
    ForEach(children) { child in
        Button(action: { onSelect(child) }) { ... }
    }
} label: {
    // Trigger view
}
```
Used in `ChildHeader` for child selection.

---



## Data Flow

```
RootView
├── @Query children: [ChildEntity]
├── @State selectedChildState
│
├── ChildHeader
│   ├── Receives: selected binding, children array
│   └── Calls: onSelect callback
│
├── RecordHistoryView
│   ├── Receives: child (ChildEntity)
│   └── @Query allRecords → filters by child.id
│
└── Sheets
    ├── AddChildSheet → @Environment(\.modelContext)
    ├── RecordEntryView → @Environment(\.modelContext)
    ├── EditChildView → @Environment(\.modelContext), SelectedChildState
    └── ExportView → @Environment(\.modelContext)
```

---

## Empty/Placeholder Folders

The following folders exist but are currently empty:

- `Milestones/` - Reserved for milestone tracking features
- `Settings/` - Reserved for app settings and preferences

---

## iOS 26 Features Used

### Liquid Glass Effect
```swift
.glassEffect(.clear, in: .rect(cornerRadius: 8))
```
Applied to the child header dropdown for modern styling.

---

## Next Steps

Per the [navigation-plan.md](navigation-plan.md), the following features are planned:

1. **Phase 1**: Implement TabView root navigation
2. **Phase 2**: Build out Home Dashboard
5. **Phase 5**: Create Settings section

---

## File References

| View | File Path |
|------|-----------|
| RootView | [RootView.swift](../app-ios/BabyMeasure/RootView.swift) |
| ChildHeader | [ChildHeader.swift](../app-ios/BabyMeasure/Children/ChildHeader.swift) |
| AddChildSheet | [AddChildSheet.swift](../app-ios/BabyMeasure/Children/AddChildSheet.swift) |
| EditChildView | [EditChildView.swift](../app-ios/BabyMeasure/Children/EditChildView.swift) |
| RecordHistoryView | [RecordHistoryView.swift](../app-ios/BabyMeasure/Measurements/RecordHistoryView.swift) |
| RecordEntryView | [RecordEntryView.swift](../app-ios/BabyMeasure/Measurements/RecordEntryView.swift) |
| GrowthChartView | [GrowthChartView.swift](../app-ios/BabyMeasure/Measurements/GrowthChartView.swift) |
| ExportView | [ExportView.swift](../app-ios/BabyMeasure/Export/ExportView.swift) |
