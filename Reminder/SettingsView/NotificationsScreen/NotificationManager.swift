import Foundation
import UserNotifications

struct NotificationManager {
    
    /// Планирует серию reminder‑уведомлений и финальное уведомление о завершении события.
    static func scheduleNotifications(for event: EventsModel, globalPushEnabled: Bool) {
        guard globalPushEnabled else {
            print("Global push notifications are disabled. Skipping scheduling for event: \(event.title)")
            return
        }
        
        // Отменяем все ранее запланированные уведомления для данного события.
        cancelNotifications(for: event)
        
        let center = UNUserNotificationCenter.current()
        let firstInterval = firstRemindInterval(for: event.firstRemind)
        let frequency = reminderFrequencyInterval(for: event.howOften)
        
        let scheduledStartDate = event.date.addingTimeInterval(-firstInterval)
        let now = Date()
        
        // Определяем, что reminder‑уведомления планируем до момента event.date - 59 секунд,
        // чтобы не было пересечения с финальным уведомлением.
        let finalReminderCutoff = event.date.addingTimeInterval(-59)
        var notificationDate = scheduledStartDate > now
            ? scheduledStartDate
            : now.addingTimeInterval(frequency)
        
        // Планируем reminder‑уведомления до finalReminderCutoff.
        if notificationDate < finalReminderCutoff {
            var index = 0
            while notificationDate < finalReminderCutoff {
                let content = UNMutableNotificationContent()
                content.title = "Reminder"
                let messages = [
                    "Don't miss the event:".localized + " \(event.title)!",
                    "Your event".localized + " \(event.title) " + "is coming soon!".localized,
                    "Get ready for".localized + " \(event.title)!",
                    "\(event.title) " + "is just around the corner!".localized,
                    "Reminder:".localized + " \(event.title) " + "is approaching fast!".localized
                ]
                content.body = messages.randomElement() ?? "Reminder: \(event.title) is coming up!"
                content.sound = .default
                
                let triggerDateComponents = Calendar.current.dateComponents(
                    [.year, .month, .day, .hour, .minute, .second],
                    from: notificationDate
                )
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
                
                let identifier = "\(event.id.uuidString)_\(index)"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling reminder for event \(event.title): \(error)")
                    }
                }
                
                notificationDate = notificationDate.addingTimeInterval(frequency)
                index += 1
            }
        } else {
            print("No time available to schedule reminder notifications for event: \(event.title)")
        }
        
        // Планируем финальное уведомление о завершении события.
        let finalContent = UNMutableNotificationContent()
        finalContent.title = "Event Ended"
        finalContent.body = "The event \(event.title) has ended!"
        finalContent.sound = .default
        
        let finalIdentifier = "\(event.id.uuidString)_final"
        // Вычисляем задержку: время до event.date плюс 1 секунда.
        let delay = event.date.timeIntervalSince(now) + 1
        let finalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: delay > 1 ? delay : 1, repeats: false)
        
        let finalRequest = UNNotificationRequest(identifier: finalIdentifier, content: finalContent, trigger: finalTrigger)
        center.add(finalRequest) { error in
            if let error = error {
                print("Error scheduling final notification for event \(event.title): \(error)")
            }
        }
    }
    
    /// Отменяет все запланированные уведомления для данного события.
    static func cancelNotifications(for event: EventsModel) {
        let center = UNUserNotificationCenter.current()
        let identifierPrefix = event.id.uuidString
        center.getPendingNotificationRequests { requests in
            let identifiersToCancel = requests
                .filter { $0.identifier.hasPrefix(identifierPrefix) }
                .map { $0.identifier }
            center.removePendingNotificationRequests(withIdentifiers: identifiersToCancel)
        }
    }
    
    // MARK: - Вспомогательные методы
    
    private static func firstRemindInterval(for firstRemind: FirstRemind) -> TimeInterval {
        switch firstRemind {
        case .fiveMinutesBefore: return 300
        case .fifthteenMinutesBefore: return 900
        case .thirtyMinutesBefore: return 1800
        case .fortyfiveMinutesBefore: return 2700
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
        case .everyFiveSeconds: return 60
        case .everyHour: return 3600
        case .everyDay: return 86400
        case .everyWeek: return 604800
        }
    }
}
