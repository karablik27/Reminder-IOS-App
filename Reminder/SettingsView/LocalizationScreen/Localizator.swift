import Foundation

// MARK: - Localizer
class Localizer {
    static var selectedLanguage: String = Locale.current.language.languageCode?.identifier ?? "en" {
        didSet {
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }
    
    static func localizedString(for key: String) -> String {
        if let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(key, bundle: bundle, comment: "")
        } else {
            return NSLocalizedString(key, bundle: .main, comment: "")
        }
    }
}

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}
