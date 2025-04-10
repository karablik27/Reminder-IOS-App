import SwiftUI
import SwiftData
import Combine
import UserNotifications

// MARK: - NotificationsViewModel
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
        if !settings.isManuallySet {
            UNUserNotificationCenter.current().getNotificationSettings { notifSettings in
                DispatchQueue.main.async {
                    self.settings.isPushEnabled = (notifSettings.authorizationStatus == .authorized)
                }
            }
        }
    }
    
    // MARK: - togglePush
    func togglePush(_ newValue: Bool, context: ModelContext) {
        settings.isPushEnabled = newValue
        settings.isManuallySet = true
        try? context.save()
        
        if !newValue {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            print("All scheduled notifications cancelled.")
        } else {
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
