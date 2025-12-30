import Foundation
import HStorage
import SwiftUI

// MeasurementType defined in Domain/DraftModels.swift within same target.

public extension MeasurementType {
    var acceptableRange: ClosedRange<Double>? {
        switch self {
        case .height:
            20 ... 150
        case .weight:
            1 ... 60
        case .headCircumference:
            25 ... 60
        }
    }

    private var displayNameLocalizationKey: String {
        switch self {
        case .height:
            "measurement.height"
        case .weight:
            "measurement.weight"
        case .headCircumference:
            "measurement.headCircumference"
        }
    }

    var displayNameKey: LocalizedStringKey {
        LocalizedStringKey(displayNameLocalizationKey)
    }

    var displayNameString: String {
        String(localized: String.LocalizationValue(displayNameLocalizationKey))
    }

    var displayName: String {
        displayNameString
    }

    var unit: String {
        switch self {
        case .height, .headCircumference:
            "cm"
        case .weight:
            "kg"
        }
    }
}
