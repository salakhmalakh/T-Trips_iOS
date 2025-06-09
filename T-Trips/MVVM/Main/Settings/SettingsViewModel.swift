import Foundation

final class SettingsViewModel {
    static let darkModeKey = "darkModeEnabled"
    static let languageKey = LocalizationManager.languageKey

    var darkMode: Bool {
        get { UserDefaults.standard.bool(forKey: Self.darkModeKey) }
        set { UserDefaults.standard.set(newValue, forKey: Self.darkModeKey) }
    }

    var language: AppLanguage {
        get { LocalizationManager.currentLanguage }
        set { LocalizationManager.currentLanguage = newValue }
    }
}
