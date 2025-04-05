import SwiftUI
import SwiftData
import Combine
import UserNotifications

final class NotificationsViewModel: ObservableObject {
    @Published var settings: NotificationsModel
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        let fetchDescriptor = FetchDescriptor<NotificationsModel>(predicate: nil)
        if let existingSettings = try? context.fetch(fetchDescriptor).first {
            settings = existingSettings
        } else {
            let newSettings = NotificationsModel()
            context.insert(newSettings)
            try? context.save()
            settings = newSettings
        }
        // Если пользователь ещё не менял настройки вручную, устанавливаем push по статусу системного разрешения.
        if !settings.isManuallySet {
            UNUserNotificationCenter.current().getNotificationSettings { notifSettings in
                DispatchQueue.main.async {
                    self.settings.isPushEnabled = (notifSettings.authorizationStatus == .authorized)
                }
            }
        }
    }
    
    func togglePush(_ newValue: Bool, context: ModelContext) {
        settings.isPushEnabled = newValue
        settings.isManuallySet = true
        try? context.save()
        print("Push notifications: \(newValue ? "enabled" : "disabled")")
    }
}
