import SwiftUI
import SwiftData
import Combine

class EventsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var selectedTab: Int = 0
    @Published var searchText: String = ""
    @Published var selectedEventType: EventTypeMain = .allEvents
    @Published var selectedSortOption: SortOption = .byDate
    @Published var isAscending = true
    @Published var filteredModels: [EventsModel] = []
    @Published var currentDate: Date = Date()
    
    // MARK: - Private Properties
    private var modelContext: ModelContext
    private var timerCancellable: AnyCancellable?
    
    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadEvents()
        startTimer()
    }
    
    // MARK: - Event Loading (Upcoming Events Only)
    func loadEvents() {
        let now = Date()
        
        var sortDescriptors: [SortDescriptor<EventsModel>] = []
        switch selectedSortOption {
        case .byDate:
            sortDescriptors = [SortDescriptor(\.date, order: isAscending ? .forward : .reverse)]
        case .byName:
            sortDescriptors = [SortDescriptor(\.title, order: isAscending ? .forward : .reverse)]
        }
        
        let fetchDescriptor = FetchDescriptor<EventsModel>(
            predicate: #Predicate { (event: EventsModel) in
                event.date > now
            },
            sortBy: sortDescriptors
        )
        
        do {
            let upcomingEvents = try modelContext.fetch(fetchDescriptor)
            if selectedEventType == .allEvents {
                filteredModels = upcomingEvents
            } else {
                filteredModels = upcomingEvents.filter { $0.type == selectedEventType }
            }
        } catch {
            print("Error fetching events: \(error)")
            filteredModels = []
        }
    }
    
    // MARK: - Bookmark Handling
    func toggleBookmark(for event: EventsModel) {
        event.isBookmarked.toggle()
        do {
            try modelContext.save()
            loadEvents()
        } catch {
            print("Error saving bookmark status: \(error)")
        }
    }
    
    // MARK: - Sorting
    func toggleSortDirection() {
        isAscending.toggle()
        loadEvents()
    }
    
    // MARK: - Event Addition + Notification Scheduling
    func addEvent(title: String,
                  date: Date,
                  icon: String,
                  type: EventTypeMain,
                  firstRemind: FirstRemind,
                  howOften: ReminderFrequency,
                  information: String = "",
                  photos: [UIImage] = []) {
        let newEvent = EventsModel(
            title: title,
            date: date,
            icon: icon,
            type: type,
            isBookmarked: false,
            information: information,
            firstRemind: firstRemind,
            howOften: howOften
        )
        
        if !photos.isEmpty {
            newEvent.photos = photos.compactMap { $0.jpegData(compressionQuality: 1.0) }
        }
        
        modelContext.insert(newEvent)
        do {
            try modelContext.save()
            loadEvents()
            let fetchDescriptor = FetchDescriptor<NotificationsModel>(predicate: nil)
            if let notificationSettings = try? modelContext.fetch(fetchDescriptor).first {
                NotificationManager.scheduleNotifications(for: newEvent, globalPushEnabled: notificationSettings.isPushEnabled)
            }
        } catch {
            print("Error saving event: \(error)")
        }
    }
    
    // MARK: - Event Deletion
    func deleteEvent(_ event: EventsModel) {
        NotificationManager.cancelNotifications(for: event)
        modelContext.delete(event)
        do {
            try modelContext.save()
            loadEvents()
        } catch {
            print("Error deleting event: \(error)")
        }
    }
    
    // MARK: - Timer (Updates Every Second)
    private func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in
                guard let self = self else { return }
                self.currentDate = now
                self.loadEvents()
            }
    }
    
    // MARK: - Time Left Calculation
    func localizedDaysString(_ count: Int) -> String {
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        
        if languageCode == "ru" {
            let mod10 = count % 10
            let mod100 = count % 100
            if mod10 == 1 && mod100 != 11 {
                return "\(count) день"
            } else if (2...4).contains(mod10) && !(12...14).contains(mod100) {
                return "\(count) дня"
            } else {
                return "\(count) дней"
            }
        } else {
            return count == 1 ? "1 day" : "\(count) days"
        }
    }

    func timeLeftString(for event: EventsModel) -> String {
        let now = currentDate
        let diff = event.date.timeIntervalSince(now)
        let secondsInDay: TimeInterval = 24 * 3600
        
        if diff >= secondsInDay {
            let days = Int(diff / secondsInDay)
            return localizedDaysString(days)
        }
        let hours = Int(diff / 3600)
        let minutes = Int((diff.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(diff.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    
    // MARK: - Filtered Search Results
    var searchResults: [EventsModel] {
        let text = searchText.lowercased()
        if text.isEmpty {
            return filteredModels
        } else {
            return filteredModels.filter { $0.title.lowercased().contains(text) }
        }
    }
    
    // MARK: - Deinitialization
    deinit {
        timerCancellable?.cancel()
    }
}
