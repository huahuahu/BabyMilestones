import HStorage
import SwiftUI

/// Settings section for app preferences including units, language, and theme.
struct AppPreferencesSection: View {
    @Environment(AppPreferences.self) private var preferences

    var body: some View {
        @Bindable var preferences = preferences

        Section("settings.preferences.section") {
            unitsPicker
            languagePicker
            themePicker
        }
    }

    // MARK: - Pickers

    private var unitsPicker: some View {
        @Bindable var preferences = preferences

        return Picker("settings.units", selection: $preferences.unitSystem) {
            ForEach(UnitSystem.allCases) { unit in
                Text(unit.displayName)
                    .tag(unit)
            }
        }
    }

    private var languagePicker: some View {
        @Bindable var preferences = preferences

        return Picker("settings.language", selection: $preferences.language) {
            ForEach(AppLanguage.allCases) { language in
                Text(language.displayName)
                    .tag(language)
            }
        }
    }

    private var themePicker: some View {
        @Bindable var preferences = preferences

        return Picker("settings.theme", selection: $preferences.theme) {
            ForEach(AppTheme.allCases) { theme in
                Text(theme.displayName)
                    .tag(theme)
            }
        }
    }
}

#Preview {
    List {
        AppPreferencesSection()
    }
    .environment(AppPreferences())
}
