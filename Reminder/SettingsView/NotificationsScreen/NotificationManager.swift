import Foundation
import UserNotifications

struct NotificationManager {
    
    /// Планирует серию уведомлений для события, основываясь на выбранных параметрах и глобальном флаге push-уведомлений.
    static func scheduleNotifications(for event: MainModel, globalPushEnabled: Bool) {
        // Если глобально уведомления выключены — ничего не планировать.
        guard globalPushEnabled else {
            print("Global push notifications are disabled. Skipping scheduling for event: \(event.title)")
            return
        }
        
        // Сначала отменяем предыдущие уведомления для этого события
        cancelNotifications(for: event)
        
        let center = UNUserNotificationCenter.current()
        
        let firstRemindInterval = firstRemindInterval(for: event.firstRemind)
        let frequencyInterval = reminderFrequencyInterval(for: event.howOften)
        
        let firstNotificationDate = event.date.addingTimeInterval(-firstRemindInterval)
        
        guard firstNotificationDate > Date() else {
            print("First notification time is in the past. Skipping scheduling.")
            return
        }
        
        var notificationDate = firstNotificationDate
        var index = 0
        while notificationDate < event.date {
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = "Upcoming event: \(event.title) is approaching."
            content.sound = .default
            
            let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            
            let identifier = "\(event.id.uuidString)_\(index)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
            
            notificationDate = notificationDate.addingTimeInterval(frequencyInterval)
            index += 1
        }
    }
    
    /// Отменяет все запланированные уведомления для указанного события
    static func cancelNotifications(for event: MainModel) {
        let center = UNUserNotificationCenter.current()
        let identifierPrefix = event.id.uuidString
        center.getPendingNotificationRequests { requests in
            let identifiersToCancel = requests
                .filter { $0.identifier.hasPrefix(identifierPrefix) }
                .map { $0.identifier }
            center.removePendingNotificationRequests(withIdentifiers: identifiersToCancel)
        }
    }
    
    private static func firstRemindInterval(for firstRemind: FirstRemind) -> TimeInterval {
        switch firstRemind {
        case .oneHourBefore: return 3600
        case .twoHourBefore: return 7200
        case .threeHourBefore: return 10800
        case .fourHourBefore: return 14400
        case .fiveHourBefore: return 18000
        case .sixHourBefore: return 21600
        case .sevenHourBefore: return 25200
        case .eightHourBefore: return 28800
        case .nineHourBefore: return 32400
        case .tenHourBefore: return 36000
        case .elevenHourBefore: return 39600
        case .twelveHourBefore: return 43200
        case .thirteenHourBefore: return 46800
        case .fourteenHourBefore: return 50400
        case .fifteenHourBefore: return 54000
        case .sixteenHourBefore: return 57600
        case .seventeenHourBefore: return 61200
        case .oneDayBefore: return 86400
        case .oneWeekBefore: return 604800
        }
    }
    
    private static func reminderFrequencyInterval(for frequency: ReminderFrequency) -> TimeInterval {
        switch frequency {
        case .everyHour: return 3600
        case .everyDay: return 86400
        case .everyWeek: return 604800
        }
    }
}
