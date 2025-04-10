import SwiftUI
import SwiftData
import Combine

// MARK: - LocalizationViewModel
final class LocalizationViewModel: ObservableObject {
    @Published var selectedLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    
    let availableLanguages: [String: String] = [
        "en": "English",
        "ru": "Русский"
    ]
    
    var sortedLanguageCodes: [String] {
        availableLanguages.keys.sorted { lhs, rhs in
            if lhs == "en" { return true }
            if rhs == "en" { return false }
            return lhs < rhs
        }
    }
    
    private var modelContext: ModelContext
    private var languageSettings: LocalizationModel?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        let fetchDescriptor = FetchDescriptor<LocalizationModel>()
        if let settings = try? modelContext.fetch(fetchDescriptor).first {
            languageSettings = settings
            selectedLanguage = settings.selectedLanguage
        } else {
            let newSettings = LocalizationModel(selectedLanguage: Locale.current.language.languageCode?.identifier ?? "en")
            modelContext.insert(newSettings)
            try? modelContext.save()
            languageSettings = newSettings
            selectedLanguage = newSettings.selectedLanguage
        }
    }
    
    func selectLanguage(_ language: String) {
        guard availableLanguages.keys.contains(language) else { return }
        selectedLanguage = language
        languageSettings?.selectedLanguage = language
        do {
            try modelContext.save()
        } catch {
            print("Ошибка сохранения настроек языка: \(error)")
        }
        NotificationCenter.default.post(name: .languageChanged, object: nil)
        Localizer.selectedLanguage = language
    }
}

