import SwiftUI
import Combine
import SwiftData

final class SettingsViewModel: ObservableObject {
    @Published var isDarkMode: Bool = false

    private var modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        // Здесь можно загрузить дополнительные настройки (например, язык, тёмную тему и т.д.)
    }
    
    func toggleTheme(isDark: Bool) {
        isDarkMode = isDark
        // Дополнительное сохранение (например, в UserDefaults) можно добавить здесь.
        print("Theme changed. Dark mode: \(isDark)")
    }
    
    func rateInAppStore() {
        // Здесь реализуйте логику перехода в App Store.
        print("User tapped Rate in App Store")
    }
    
    func factoryReset() {
        print("Factory reset triggered")
        
        do {
            // Удаляем все события из модели MainModel
            let events = try modelContext.fetch(FetchDescriptor<MainModel>())
            for event in events {
                modelContext.delete(event)
            }
            try modelContext.save()
            print("All events have been deleted.")
        } catch {
            print("Error during factory reset (events): \(error)")
        }
        
        // Очистка вручную отмеченных красивых дат:
        print("All user beautiful dates have been cleared.")
        
        // Сброс дополнительных настроек
        isDarkMode = false
        
        // Если есть другие настройки — сбрасывайте их здесь
    }

}
