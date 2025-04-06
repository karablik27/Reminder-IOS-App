import SwiftUI
import SwiftData
import Combine

class AddEventViewModel: ObservableObject {
    private var modelContext: ModelContext

    // Свойства для нового события
    @Published var newTitle: String = ""
    @Published var newIcon: String = "default_icon"
    @Published var newEventDate: Date = Date()
    @Published var newEventTime: Date = Date()
    @Published var newType: EventTypeAddEvent = .none
    @Published var newInformation: String = ""
    @Published var newFirstRemind: FirstRemind = .oneHourBefore
    @Published var newHowOften: ReminderFrequency = .everyHour
    @Published var newIconData: Data? = nil
    @Published var nextEventNumber: Int = 1

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        updateNextEventNumber()
    }
    
    func updateNextEventNumber() {
        do {
            let allEvents = try modelContext.fetch(FetchDescriptor<MainModel>())
            nextEventNumber = allEvents.count + 1
        } catch {
            print("Error counting events: \(error)")
            nextEventNumber = 1
        }
    }
    
    func updateIcon() {
        newIcon = defaultIcon(for: newType)
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
    
    private func convertToMainType(_ addType: EventTypeAddEvent) -> EventTypeMain {
        switch addType {
        case .none: return .other
        case .holidays: return .holidays
        case .birthdays: return .birthdays
        case .study: return .study
        case .movies: return .movies
        case .other: return .other
        }
    }
    
    private func combineDateAndTime() -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: newEventDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: newEventTime)
        var merged = DateComponents()
        merged.year = dateComponents.year
        merged.month = dateComponents.month
        merged.day = dateComponents.day
        merged.hour = timeComponents.hour
        merged.minute = timeComponents.minute
        return calendar.date(from: merged) ?? newEventDate
    }
    
    func addEvent() {
        if newType == .none {
            print("User must select a valid type first!")
            return
        }
        let mainType = convertToMainType(newType)
        let finalDate = combineDateAndTime()
        let newEvent = MainModel(
            id: UUID(),
            title: newTitle,
            date: finalDate,
            icon: newIcon,
            type: mainType,
            isBookmarked: false,
            information: newInformation,
            firstRemind: newFirstRemind,
            howOften: newHowOften
        )
        if let data = newIconData, !data.isEmpty {
            newEvent.iconData = data
        }
        modelContext.insert(newEvent)
        do {
            try modelContext.save()
            print("Event saved successfully!")
            let fetchDescriptor = FetchDescriptor<NotificationsModel>(predicate: nil)
            if let notificationSettings = try? modelContext.fetch(fetchDescriptor).first {
                NotificationManager.scheduleNotifications(for: newEvent, globalPushEnabled: notificationSettings.isPushEnabled)
            }
            resetForm()
        } catch {
            print("Error saving event: \(error)")
        }
    }
    
    private func resetForm() {
        newTitle = ""
        newIcon = "default_icon"
        newType = .none
        newInformation = ""
        newFirstRemind = .oneHourBefore
        newHowOften = .everyHour
        newEventDate = Date()
        newEventTime = Date()
        updateNextEventNumber()
    }
    
    var displayedTitle: String {
        newTitle.isEmpty ? "Event".localized + " " + "№ \(nextEventNumber)" : newTitle
    }
}
