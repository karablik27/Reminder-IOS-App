import SwiftUI
import SwiftData
import Combine

class BeautifulDatesViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var selectedEventType: EventTypeMain = .allEvents
    @Published var selectedSortOption: SortOption = .byDate
    @Published var isAscending = true
    @Published var filteredModels: [EventsModel] = []
    @Published var currentDate: Date = Date()
    @Published var searchText: String = ""
    
    // MARK: - Private Properties
    private var modelContext: ModelContext
    private var timerCancellable: AnyCancellable?
    
    // MARK: - Initializer
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadBeautifulEvents()
        startTimer()
    }
    
    // MARK: - Loading Beautiful Events
    func loadBeautifulEvents() {
        var sortDescriptors: [SortDescriptor<EventsModel>] = []
        switch selectedSortOption {
        case .byDate:
            sortDescriptors = [SortDescriptor(\.date, order: isAscending ? .forward : .reverse)]
        case .byName:
            sortDescriptors = [SortDescriptor(\.title, order: isAscending ? .forward : .reverse)]
        }
        
        let fetchDescriptor = FetchDescriptor<EventsModel>(sortBy: sortDescriptors)
        
        do {
            let allEvents = try modelContext.fetch(fetchDescriptor)
            let allBeautiful = allEvents.filter { $0.isBeautiful }
            if selectedEventType == .allEvents {
                filteredModels = allBeautiful
            } else {
                filteredModels = allBeautiful.filter { $0.type == selectedEventType }
            }
        } catch {
            print("Error fetching beautiful events: \(error)")
            filteredModels = []
        }
    }
    
    // MARK: - Sorting Methods
    func toggleSortDirection() {
        isAscending.toggle()
        loadBeautifulEvents()
    }
    
    // MARK: - Deletion Methods
    func deleteEvent(_ event: EventsModel) {
        NotificationManager.cancelNotifications(for: event)
        modelContext.delete(event)
        do {
            try modelContext.save()
            loadBeautifulEvents()
        } catch {
            print("Error deleting event: \(error)")
        }
    }
    
    // MARK: - Bookmark Handling
    func toggleBookmark(for event: EventsModel) {
        event.isBookmarked.toggle()
        do {
            try modelContext.save()
            loadBeautifulEvents()
        } catch {
            print("Error toggling bookmark: \(error)")
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
        
        if diff <= 0 {
            return "Finish".localized
        }
        
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

    
    var searchResults: [EventsModel] {
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
