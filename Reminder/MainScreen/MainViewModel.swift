import SwiftUI
import SwiftData
import Combine

class MainViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedTab: Int = 0
    @Published var searchText: String = ""
    @Published var selectedEventType: EventTypeMain = .allEvents
    @Published var selectedSortOption: SortOption = .byDate
    @Published var isAscending = true
    @Published var filteredModels: [MainModel] = []
    @Published var currentDate: Date = Date()

    // MARK: - Private Properties
    private var modelContext: ModelContext
    private var timerCancellable: AnyCancellable?

    // MARK: - Initializer
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        print("MainViewModel initialized with modelContext: \(modelContext)")
        loadEvents()
        startTimer()
    }

    // MARK: - Event Loading
    func loadEvents() {
        print("Loading events...")
        var sortDescriptors: [SortDescriptor<MainModel>] = []
        switch selectedSortOption {
        case .byDate:
            sortDescriptors = [SortDescriptor(\.date, order: isAscending ? .forward : .reverse)]
        case .byName:
            sortDescriptors = [SortDescriptor(\.title, order: isAscending ? .forward : .reverse)]
        }
        
        let fetchDescriptor = FetchDescriptor<MainModel>(sortBy: sortDescriptors)
        do {
            let allEvents = try modelContext.fetch(fetchDescriptor)
            print("Fetched \(allEvents.count) events from modelContext.")
            if selectedEventType == .allEvents {
                filteredModels = allEvents
                print("No filter applied. Showing all events.")
            } else {
                filteredModels = allEvents.filter { $0.type == selectedEventType }
                print("Filtered by type \(selectedEventType.rawValue). Showing \(filteredModels.count) events.")
            }
        } catch {
            print("Error fetching events: \(error)")
            filteredModels = []
        }
    }
    
    // MARK: - Bookmark Handling
    func toggleBookmark(for event: MainModel) {
        event.isBookmarked.toggle()
        do {
            try modelContext.save()
            loadEvents()
        } catch {
            print("Error saving bookmark status: \(error)")
        }
    }

    // MARK: - Sorting Methods
    func toggleSortDirection() {
        isAscending.toggle()
        print("Sort direction toggled to \(isAscending ? "ascending" : "descending")")
        loadEvents()
    }
    
    // MARK: - Event Addition with Notification Scheduling
    func addEvent(title: String,
                  date: Date,
                  icon: String,
                  type: EventTypeMain,
                  firstRemind: FirstRemind,
                  howOften: ReminderFrequency,
                  information: String = "") {
        let newEvent = MainModel(
            title: title,
            date: date,
            icon: icon,
            type: type,
            isBookmarked: false,
            information: information,
            firstRemind: firstRemind,
            howOften: howOften
        )
        
        modelContext.insert(newEvent)
        do {
            try modelContext.save()
            loadEvents()
            print("Event saved successfully!")
            let fetchDescriptor = FetchDescriptor<NotificationsModel>(predicate: nil)
            if let notificationSettings = try? modelContext.fetch(fetchDescriptor).first {
                NotificationManager.scheduleNotifications(for: newEvent, globalPushEnabled: notificationSettings.isPushEnabled)
            }
        } catch {
            print("Error saving event: \(error)")
        }
    }
    
    // MARK: - Event Deletion
    func deleteEvent(_ event: MainModel) {
        NotificationManager.cancelNotifications(for: event)
        modelContext.delete(event)
        do {
            try modelContext.save()
            loadEvents()
            print("Event successfully deleted")
        } catch {
            print("Error deleting event: \(error)")
        }
    }
    
    func deleteAllEvents() {
        let fetchDescriptor = FetchDescriptor<MainModel>()
        do {
            let allEvents = try modelContext.fetch(fetchDescriptor)
            for event in allEvents {
                NotificationManager.cancelNotifications(for: event)
                modelContext.delete(event)
            }
            try modelContext.save()
            loadEvents()
            print("All events successfully deleted.")
        } catch {
            print("Error deleting all events: \(error)")
        }
    }
    
    // MARK: - Timer Management
    private func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in
                self?.currentDate = now
            }
    }
    
    // MARK: - Time Left Calculation
    func timeLeftString(for event: MainModel) -> String {
        let now = currentDate
        if event.date <= now {
            return "Finish".localized
        }
        
        let diff = event.date.timeIntervalSince(now)
        let days = Int(diff / 86400)
        if days >= 1 {
            return "\(days)" + "days".localized
        } else {
            let hours = Int(diff / 3600)
            let minutes = Int((diff.truncatingRemainder(dividingBy: 3600)) / 60)
            let seconds = Int(diff.truncatingRemainder(dividingBy: 60))
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    // MARK: - Вычисляемое свойство для поиска
    var searchResults: [MainModel] {
        let text = searchText.lowercased()
        if text.isEmpty {
            return filteredModels
        } else {
            return filteredModels.filter { $0.title.lowercased().contains(text) }
        }
    }
    
    // MARK: - Deinitializer
    deinit {
        timerCancellable?.cancel()
    }
}
