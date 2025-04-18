import SwiftUI
import SwiftData
import Combine

// MARK: - AddEventViewModel
class AddEventViewModel: ObservableObject {
    private var modelContext: ModelContext

    // MARK: - New Event Properties
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
    @Published var selectedForDeletion: Set<Int> = []
    @Published var isSelectionMode: Bool = false

    /// NEW: Store additional photos (UIImages) that the user adds in the Information screen.
    @Published var newAdditionalPhotos: [UIImage] = []
    
    // MARK: - Computed Properties
    var displayedTitle: String {
        newTitle.isEmpty ? ("Event".localized + " " + "№ \(nextEventNumber)") : newTitle
    }

    // MARK: - Init
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        updateNextEventNumber()
    }

    // MARK: - Public Methods
    func updateNextEventNumber() {
        do {
            let allEvents = try modelContext.fetch(FetchDescriptor<EventsModel>())
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

    func addEvent() {
        if newType == .none {
            print("User must select a valid type first!")
            return
        }
        let mainType = convertToMainType(newType)
        let finalDate = combineDateAndTime()
        let newEvent = EventsModel(
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
        
        // NEW: Convert additional photos to Data and save them.
        if !newAdditionalPhotos.isEmpty {
            newEvent.photos = newAdditionalPhotos.compactMap {
                $0.jpegData(compressionQuality: 1.0)
            }
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

    // MARK: - Private Helpers
    private func resetForm() {
        newTitle = ""
        newIcon = "default_icon"
        newType = .none
        newInformation = ""
        newFirstRemind = .oneHourBefore
        newHowOften = .everyHour
        newEventDate = Date()
        newEventTime = Date()
        newAdditionalPhotos = []
        updateNextEventNumber()
    }

    private func convertToMainType(_ addType: EventTypeAddEvent) -> EventTypeMain {
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
            newAdditionalPhotos.remove(at: index)
        }
        selectedForDeletion.removeAll()
        isSelectionMode = false
    }
}
