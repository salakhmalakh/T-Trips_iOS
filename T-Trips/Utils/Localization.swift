import Foundation

extension String {
    var localized: String {
        Bundle.localizedBundle.localizedString(forKey: self, value: nil, table: nil)
    }
}
