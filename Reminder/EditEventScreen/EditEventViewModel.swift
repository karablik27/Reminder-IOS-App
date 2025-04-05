import SwiftUI
import SwiftData
import Combine

class EditEventViewModel: ObservableObject {
    private var modelContext: ModelContext
    // Существующее событие
    @Published var event: MainModel

    // Редактируемые свойства
    @Published var title: String
    @Published var icon: String
    @Published var eventDate: Date
    @Published var eventTime: Date
    @Published var eventType: EventTypeAddEvent
    @Published var information: String
    @Published var firstRemind: FirstRemind
    @Published var howOften: ReminderFrequency
    @Published var iconData: Data?

    var displayedTitle: String {
        title.isEmpty ? "Event" : title
    }
    
    var eventImage: UIImage? {
        if let data = iconData, let img = UIImage(data: data) {
            return img
        }
        return nil
    }
    
    init(modelContext: ModelContext, event: MainModel) {
        self.modelContext = modelContext
        self.event = event
        self.title = event.title
        self.icon = event.icon
        self.eventDate = event.date
        self.eventTime = event.date // Предполагаем, что время хранится в event.date
        self.eventType = Self.convertToAddEventType(from: event.type)
        self.information = event.information
        self.firstRemind = event.firstRemind
        self.howOften = event.howOften
        self.iconData = event.iconData
    }
    
    func saveChanges() {
        let finalDate = combineDateAndTime()
        event.title = title
        event.icon = icon
        event.date = finalDate
        event.type = Self.convertToMainEventType(from: eventType)
        event.information = information
        event.firstRemind = firstRemind
        event.howOften = howOften
        event.iconData = iconData
        do {
            try modelContext.save()
            let fetchDescriptor = FetchDescriptor<NotificationsModel>(predicate: nil)
            if let notificationSettings = try? modelContext.fetch(fetchDescriptor).first {
                NotificationManager.scheduleNotifications(for: event, globalPushEnabled: notificationSettings.isPushEnabled)
            }
        } catch {
            print("Error saving event changes: \(error)")
        }
    }

    func deleteEvent() {
        NotificationManager.cancelNotifications(for: event)
        modelContext.delete(event)
        do {
            try modelContext.save()
        } catch {
            print("Error deleting event: \(error)")
        }
    }
    
    private func combineDateAndTime() -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: eventDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: eventTime)
        var merged = DateComponents()
        merged.year = dateComponents.year
        merged.month = dateComponents.month
        merged.day = dateComponents.day
        merged.hour = timeComponents.hour
        merged.minute = timeComponents.minute
        return calendar.date(from: merged) ?? eventDate
    }
    
    private static func convertToAddEventType(from mainType: EventTypeMain) -> EventTypeAddEvent {
        switch mainType {
        case .allEvents: return .other
        case .holidays: return .holidays
        case .birthdays: return .birthdays
        case .study: return .study
        case .movies: return .movies
        case .other: return .other
        }
    }
    
    private static func convertToMainEventType(from addType: EventTypeAddEvent) -> EventTypeMain {
        switch addType {
        case .none: return .other
        case .holidays: return .holidays
        case .birthdays: return .birthdays
        case .study: return .study
        case .movies: return .movies
        case .other: return .other
        }
    }
    
    func defaultIcon(for newType: EventTypeAddEvent) -> String {
        switch newType {
        case .none: return ""
        case .holidays: return "holiday_icon"
        case .birthdays: return "birthday_icon"
        case .study: return "study_icon"
        case .movies: return "movie_icon"
        case .other: return "default_icon"
        }
    }
    
    func updateIcon() {
        icon = defaultIcon(for: eventType)
    }
}
