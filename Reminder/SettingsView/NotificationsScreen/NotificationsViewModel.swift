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
        
        if !newValue {
            // При отключении отменяем все запланированные уведомления.
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            print("All scheduled notifications cancelled.")
        } else {
            // При включении уведомлений повторно планируем их для активных событий.
            let now = Date()
            let fetchDescriptor = FetchDescriptor<EventsModel>(predicate: #Predicate { (event: EventsModel) in
                event.date > now
            })
            if let events = try? context.fetch(fetchDescriptor) {
                for event in events {
                    NotificationManager.scheduleNotifications(for: event, globalPushEnabled: true)
                }
                print("Push notifications enabled - rescheduling notifications for \(events.count) active events.")
            } else {
                print("No active events found for rescheduling notifications.")
            }
        }
        print("Push notifications: \(newValue ? "enabled" : "disabled")")
    }

}
