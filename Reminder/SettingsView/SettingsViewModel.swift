import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {
    // Переключатель тёмной темы
    @Published var isDarkMode: Bool = false
    
    // Дополнительные поля настроек (при необходимости):
    // @Published var notificationEnabled: Bool = false
    // @Published var selectedLanguage: String = "English"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Загрузка текущих настроек, если храните их в UserDefaults или через SwiftData
        // Например:
        // isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
    
    func toggleTheme(isDark: Bool) {
        // Логика изменения темы приложения
        // Например, если используете SwiftUI App, можно менять ColorScheme через Environment
        // Или сохранять значение в UserDefaults:
        // UserDefaults.standard.set(isDark, forKey: "isDarkMode")
        
        print("Theme changed. Dark mode: \(isDark)")
    }
    
    func rateInAppStore() {
        // Логика перехода в App Store (например, открытие ссылки)
        // guard let url = URL(string: "itms-apps://itunes.apple.com/app/id123456789?action=write-review") else { return }
        // UIApplication.shared.open(url)
        print("User tapped Rate in App Store")
    }
    
    func factoryReset() {
        // Сброс всех настроек на дефолтные
        // Пример:
        // UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        // UserDefaults.standard.synchronize()
        // isDarkMode = false
        print("Factory reset triggered")
    }
}

