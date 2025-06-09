import Foundation
import ObjectiveC

enum AppLanguage: String, CaseIterable {
    case en, ru

    var title: String {
        switch self {
        case .en: return "english".localized
        case .ru: return "russian".localized
        }
    }
}

final class LocalizationManager {
    static let languageKey = "selectedLanguage"

    static var currentLanguage: AppLanguage {
        get {
            if let code = UserDefaults.standard.string(forKey: languageKey),
               let lang = AppLanguage(rawValue: code) {
                return lang
            }
            let code = Locale.preferredLanguages.first?.prefix(2) ?? "en"
            return AppLanguage(rawValue: String(code)) ?? .en
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: languageKey)
            Bundle.setLanguage(newValue.rawValue)
        }
    }

    static func setup() {
        Bundle.setLanguage(currentLanguage.rawValue)
    }
}

private var bundleKey: UInt8 = 0

private extension Bundle {
    class func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            objc_setAssociatedObject(Bundle.main, &bundleKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return
        }
        objc_setAssociatedObject(Bundle.main, &bundleKey, bundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    static var localizedBundle: Bundle {
        (objc_getAssociatedObject(Bundle.main, &bundleKey) as? Bundle) ?? Bundle.main
    }
}
