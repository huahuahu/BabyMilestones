import SwiftUI

/// Observable class managing app-wide user preferences.
@MainActor
@Observable
final class AppPreferences {
    // MARK: - UserDefaults Keys

    private enum Keys {
        static let unitSystem = "app.preferences.unitSystem"
        static let language = "app.preferences.language"
        static let theme = "app.preferences.theme"
    }

    // MARK: - Properties

    var unitSystem: UnitSystem {
        didSet {
            UserDefaults.standard.set(unitSystem.rawValue, forKey: Keys.unitSystem)
        }
    }

    var language: AppLanguage {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: Keys.language)
            applyLanguage()
        }
    }

    var theme: AppTheme {
        didSet {
            UserDefaults.standard.set(theme.rawValue, forKey: Keys.theme)
        }
    }

    // MARK: - Initialization

    init() {
        if let rawValue = UserDefaults.standard.string(forKey: Keys.unitSystem),
           let unit = UnitSystem(rawValue: rawValue) {
            unitSystem = unit
        } else {
            unitSystem = .metric
        }

        if let rawValue = UserDefaults.standard.string(forKey: Keys.language),
           let lang = AppLanguage(rawValue: rawValue) {
            language = lang
        } else {
            language = .system
        }

        if let rawValue = UserDefaults.standard.string(forKey: Keys.theme),
           let appTheme = AppTheme(rawValue: rawValue) {
            theme = appTheme
        } else {
            theme = .system
        }
    }

    // MARK: - Private Methods

    private func applyLanguage() {
        if let code = language.languageCode {
            UserDefaults.standard.set([code], forKey: "AppleLanguages")
        } else {
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
        }
    }
}
