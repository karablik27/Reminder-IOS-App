import SwiftUI
import SwiftData
import Combine

// MARK: - BookmarksViewModel
class BookmarksViewModel: ObservableObject {
    
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
        loadBookmarks()
        startTimer()
    }
    
    // MARK: - Data Loading
    func loadBookmarks() {
        var sortDescriptors: [SortDescriptor<EventsModel>] = []
        switch selectedSortOption {
        case .byDate:
            sortDescriptors = [SortDescriptor(\.date, order: isAscending ? .forward : .reverse)]
        case .byName:
            sortDescriptors = [SortDescriptor(\.title, order: isAscending ? .forward : .reverse)]
        }
        
        let fetchDescriptor = FetchDescriptor<EventsModel>(
            predicate: #Predicate { event in
                event.isBookmarked == true
            },
            sortBy: sortDescriptors
        )
        
        do {
            let bookmarked = try modelContext.fetch(fetchDescriptor)
            if selectedEventType == .allEvents {
                filteredModels = bookmarked
            } else {
                filteredModels = bookmarked.filter { $0.type == selectedEventType }
            }
        } catch {
            print("Error fetching bookmarked events: \(error)")
            filteredModels = []
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
    
    // MARK: - Sorting Methods
    func toggleSortDirection() {
        isAscending.toggle()
        loadBookmarks()
    }
    
    // MARK: - Deletion Methods
    func deleteEvent(_ event: EventsModel) {
        NotificationManager.cancelNotifications(for: event)
        modelContext.delete(event)
        do {
            try modelContext.save()
            loadBookmarks()
        } catch {
            print("Error deleting bookmarked event: \(error)")
        }
    }
    
    // MARK: - Bookmark Handling
    func toggleBookmark(for event: EventsModel) {
        event.isBookmarked.toggle()
        do {
            try modelContext.save()
            loadBookmarks()
        } catch {
            print("Error toggling bookmark: \(error)")
        }
    }
    
    // MARK: - Time Calculation
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
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: currentDate)
        let startOfEventDay = calendar.startOfDay(for: event.date)
        
        guard let dayCount = calendar.dateComponents([.day], from: startOfToday, to: startOfEventDay).day else {
            return "Finish".localized
        }
        
        if dayCount <= 0 {
            return "Finish".localized
        }
        
        // Возвращаем строку с правильно локализованной формой дня
        return localizedDaysString(dayCount)
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
