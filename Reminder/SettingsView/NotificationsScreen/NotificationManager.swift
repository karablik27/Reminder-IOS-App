import Foundation
import UserNotifications

/// Utility struct for managing local notifications for events
struct NotificationManager {
    
    // MARK: - Schedule Notifications
    /// Schedules reminder notifications and a final "ended" notification for the given event
    /// - Parameters:
    ///   - event: The model containing event details
    ///   - globalPushEnabled: A flag indicating whether global push notifications are enabled
    static func scheduleNotifications(for event: EventsModel, globalPushEnabled: Bool) {
        // If global notifications are disabled, skip scheduling
        guard globalPushEnabled else {
            print("Global push notifications are disabled. Skipping scheduling for event: \(event.title)")
            return
        }
        
        // Remove any previously scheduled notifications for this event
        cancelNotifications(for: event)
        
        let center = UNUserNotificationCenter.current()
        // Calculate initial reminder offset and repeat frequency
        let firstInterval = firstRemindInterval(for: event.firstRemind)
        let frequency = reminderFrequencyInterval(for: event.howOften)
        
        // Determine when to start scheduling reminders
        let scheduledStartDate = event.date.addingTimeInterval(-firstInterval)
        let now = Date()

        // Final cutoff: 59 seconds before the event starts
        let finalReminderCutoff = event.date.addingTimeInterval(-59)
        
        // If past first interval, schedule the next reminder at `frequency` from now
        var notificationDate = scheduledStartDate > now
            ? scheduledStartDate
            : now.addingTimeInterval(frequency)
        
        // Only schedule if there's time before the cutoff
        if notificationDate < finalReminderCutoff {
            var index = 0
            while notificationDate < finalReminderCutoff {
                let content = UNMutableNotificationContent()
                content.title = "Reminder"
                // Randomized body message for variety
                let messages = [
                    "Don't miss the event:".localized + " \(event.title)!",
                    "Your event".localized + " \(event.title) " + "is coming soon!".localized,
                    "Get ready for".localized + " \(event.title)!",
                    "\(event.title) " + "is just around the corner!".localized,
                    "Reminder:".localized + " \(event.title) " + "is approaching fast!".localized
                ]
                content.body = messages.randomElement() ?? "Reminder: \(event.title) is coming up!"
                content.sound = .default
                
                // Create calendar trigger for this reminder date
                let triggerDateComponents = Calendar.current.dateComponents(
                    [.year, .month, .day, .hour, .minute, .second],
                    from: notificationDate
                )
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
                
                // Unique identifier including index
                let identifier = "\(event.id.uuidString)_\(index)"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                // Schedule the notification
                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling reminder for event \(event.title): \(error)")
                    }
                }
                
                // Move to next reminder slot
                notificationDate = notificationDate.addingTimeInterval(frequency)
                index += 1
            }
        } else {
            print("No time available to schedule reminder notifications for event: \(event.title)")
        }
        
        // MARK: Schedule Final "Event Ended" Notification
        let finalContent = UNMutableNotificationContent()
        finalContent.title = "Event Ended".localized
        finalContent.body = "The event".localized + " \(event.title)" + " has ended!".localized
        finalContent.sound = .default
        
        let finalIdentifier = "\(event.id.uuidString)_final"
        // Delay until just after event date
        let delay = event.date.timeIntervalSince(now) + 1
        let finalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: delay > 1 ? delay : 1, repeats: false)
        
        let finalRequest = UNNotificationRequest(identifier: finalIdentifier, content: finalContent, trigger: finalTrigger)
        center.add(finalRequest) { error in
            if let error = error {
                print("Error scheduling final notification for event \(event.title): \(error)")
            }
        }
    }
    
    // MARK: - Cancel Notifications
    /// Cancels all pending notifications for the given event
    /// - Parameter event: The model containing event details
    static func cancelNotifications(for event: EventsModel) {
        let center = UNUserNotificationCenter.current()
        let identifierPrefix = event.id.uuidString
        center.getPendingNotificationRequests { requests in
            // Filter and remove requests matching the event prefix
            let identifiersToCancel = requests
                .filter { $0.identifier.hasPrefix(identifierPrefix) }
                .map { $0.identifier }
            center.removePendingNotificationRequests(withIdentifiers: identifiersToCancel)
        }
    }
    
    // MARK: - Interval Calculations
    /// Returns the time interval (in seconds) before the event to send the first reminder
    private static func firstRemindInterval(for firstRemind: FirstRemind) -> TimeInterval {
        switch firstRemind {
        case .fiveMinutesBefore: return 300         // 5 minutes
        case .fifthteenMinutesBefore: return 900    // 15 minutes
        case .thirtyMinutesBefore: return 1800      // 30 minutes
        case .fortyfiveMinutesBefore: return 2700   // 45 minutes
        case .oneHourBefore: return 3600            // 1 hour
        case .twoHourBefore: return 7200            // 2 hours
        case .threeHourBefore: return 10800         // 3 hours
        case .fourHourBefore: return 14400          // 4 hours
        case .fiveHourBefore: return 18000          // 5 hours
        case .sixHourBefore: return 21600           // 6 hours
        case .sevenHourBefore: return 25200         // 7 hours
        case .eightHourBefore: return 28800         // 8 hours
        case .nineHourBefore: return 32400          // 9 hours
        case .tenHourBefore: return 36000           // 10 hours
        case .elevenHourBefore: return 39600        // 11 hours
        case .twelveHourBefore: return 43200        // 12 hours
        case .thirteenHourBefore: return 46800      // 13 hours
        case .fourteenHourBefore: return 50400      // 14 hours
        case .fifteenHourBefore: return 54000       // 15 hours
        case .sixteenHourBefore: return 57600       // 16 hours
        case .seventeenHourBefore: return 61200     // 17 hours
        case .oneDayBefore: return 86400            // 1 day
        case .oneWeekBefore: return 604800          // 1 week
        }
    }
    
    /// Returns the repeat frequency interval (in seconds) for reminders
    private static func reminderFrequencyInterval(for frequency: ReminderFrequency) -> TimeInterval {
        switch frequency {
        case .everyFiveSeconds: return 60   // Actually triggers every minute
        case .everyHour: return 3600       // Hourly reminders
        case .everyDay: return 86400       // Daily reminders
        case .everyWeek: return 604800     // Weekly reminders
        }
    }
}
