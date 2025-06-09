import Foundation

final class LanguagesViewModel {
    var currentLanguage: AppLanguage {
        get { LocalizationManager.currentLanguage }
        set { LocalizationManager.currentLanguage = newValue }
    }
}
