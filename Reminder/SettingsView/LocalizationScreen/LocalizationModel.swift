import SwiftData
import Foundation

// MARK: - LocalizationModel
@Model
final class LocalizationModel {
    var selectedLanguage: String

    init(selectedLanguage: String = Locale.current.language.languageCode?.identifier ?? "en") {
        self.selectedLanguage = selectedLanguage
    }
}
