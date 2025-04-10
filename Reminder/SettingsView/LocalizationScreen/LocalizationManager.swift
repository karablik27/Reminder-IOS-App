import Combine
import SwiftUI

// MARK: - LocalizationManager
class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var language: String = Localizer.selectedLanguage
    
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = NotificationCenter.default
            .publisher(for: .languageChanged)
            .sink { [weak self] _ in
                self?.language = Localizer.selectedLanguage
            }
    }
}
