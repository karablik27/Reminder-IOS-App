import Foundation

// MARK: - Localized String Extension
extension String {
    var localized: String {
        Localizer.localizedString(for: self)
    }
}
