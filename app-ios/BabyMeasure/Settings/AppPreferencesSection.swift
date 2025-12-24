import SwiftUI

/// Settings section for app preferences including units, language, and theme.
struct AppPreferencesSection: View {
  @Environment(AppPreferences.self) private var preferences

  var body: some View {
    @Bindable var preferences = preferences

    Section("应用偏好") {
      unitsPicker
      languagePicker
      themePicker
    }
  }

  // MARK: - Pickers

  private var unitsPicker: some View {
    @Bindable var preferences = preferences

    return Picker("单位", selection: $preferences.unitSystem) {
      ForEach(UnitSystem.allCases) { unit in
        Text(unit.displayName)
          .tag(unit)
      }
    }
  }

  private var languagePicker: some View {
    @Bindable var preferences = preferences

    return Picker("语言", selection: $preferences.language) {
      ForEach(AppLanguage.allCases) { language in
        Text(language.displayName)
          .tag(language)
      }
    }
  }

  private var themePicker: some View {
    @Bindable var preferences = preferences

    return Picker("主题", selection: $preferences.theme) {
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
