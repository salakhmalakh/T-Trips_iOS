import Foundation

final class SettingsViewModel {
    static let darkModeKey = "darkModeEnabled"

    var darkMode: Bool {
        get { UserDefaults.standard.bool(forKey: Self.darkModeKey) }
        set { UserDefaults.standard.set(newValue, forKey: Self.darkModeKey) }
    }
}
