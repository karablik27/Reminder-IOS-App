import SwiftUI
import SwiftData
import Combine

class EditEventViewModel: ObservableObject {
    private var modelContext: ModelContext

    @Published var event: EventsModel
    @Published var title: String
    @Published var icon: String
    @Published var eventDate: Date
    @Published var eventTime: Date
    @Published var eventType: EventTypeAddEvent
    @Published var information: String
    @Published var firstRemind: FirstRemind
    @Published var howOften: ReminderFrequency
    @Published var iconData: Data?
    @Published var selectedForDeletion: Set<Int> = []
    @Published var isSelectionMode: Bool = false
    @Published var additionalPhotos: [UIImage] = []

    var displayedTitle: String {
        title.isEmpty ? "Event" : title
    }

    var eventImage: UIImage? {
        if let data = iconData, let img = UIImage(data: data) {
            return img
        }
        return nil
    }

    init(modelContext: ModelContext, event: EventsModel) {
        self.modelContext = modelContext
        self.event = event
        self.title = event.title
        self.icon = event.icon
        self.eventDate = event.date
        self.eventTime = event.date
        self.eventType = Self.convertToAddEventType(from: event.type)
        self.information = event.information
        self.firstRemind = event.firstRemind
        self.howOften = event.howOften
        self.iconData = event.iconData

        if !event.photos.isEmpty {
            self.additionalPhotos = event.photos.compactMap { UIImage(data: $0) }
        }
    }

    // MARK: - Public Methods

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
        event.photos = additionalPhotos.compactMap { $0.jpegData(compressionQuality: 1.0) }
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

    func updateIcon() {
        icon = defaultIcon(for: eventType)
    }

    func defaultIcon(for newType: EventTypeAddEvent) -> String {
        switch newType {
        case .none: return ""
        case .holidays: return "holiday_icon"
        case .birthdays: return "birthday_icon"
        case .study: return "study_icon"
        case .movies: return "movie_icon"
        case .anniversary: return "anniversary_icon"
        case .travel: return "travel_icon"
        case .concerts: return "concert_icon"
        case .goals: return "goal_icon"
        case .health: return "health_icon"
        case .meetings: return "meeting_icon"
        case .reminders: return "reminder_icon"
        case .work: return "work_icon"
        case .shopping: return "shopping_icon"
        case .romantic: return "romantic_icon"
        case .firstTime: return "firsttime_icon"
        case .wishDate: return "wish_icon"
        case .memorable: return "memorable_icon"
        case .other: return "other_icon"
        }
    }

    // MARK: - Private Helpers

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
        case .anniversary: return .anniversary
        case .travel: return .travel
        case .concerts: return .concerts
        case .goals: return .goals
        case .health: return .health
        case .meetings: return .meetings
        case .reminders: return .reminders
        case .work: return .work
        case .shopping: return .shopping
        case .romantic: return .romantic
        case .firstTime: return .firstTime
        case .wishDate: return .wishDate
        case .memorable: return .memorable
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
        case .anniversary: return .anniversary
        case .travel: return .travel
        case .concerts: return .concerts
        case .goals: return .goals
        case .health: return .health
        case .meetings: return .meetings
        case .reminders: return .reminders
        case .work: return .work
        case .shopping: return .shopping
        case .romantic: return .romantic
        case .firstTime: return .firstTime
        case .wishDate: return .wishDate
        case .memorable: return .memorable
        case .other: return .other
        }
    }
    
    func toggleSelection(_ index: Int) {
        if selectedForDeletion.contains(index) {
            selectedForDeletion.remove(index)
        } else {
            selectedForDeletion.insert(index)
        }
    }

    func deleteSelectedPhotos() {
        let sorted = selectedForDeletion.sorted(by: >)
        for index in sorted {
            additionalPhotos.remove(at: index)
        }
        selectedForDeletion.removeAll()
        isSelectionMode = false
    }
}
