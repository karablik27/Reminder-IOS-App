import SwiftUI
import SwiftData
import Combine

// MARK: - HistoryViewModel
class HistoryViewModel: ObservableObject {
    
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
    
    var searchResults: [EventsModel] {
        let text = searchText.lowercased()
        if text.isEmpty {
            return filteredModels
        } else {
            return filteredModels.filter { $0.title.lowercased().contains(text) }
        }
    }
    
    // MARK: - Initializer
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadHistoryEvents()
        startTimer()
    }
    
    // MARK: - Data Loading
    func loadHistoryEvents() {
        let now = Date()
        
        var sortDescriptors: [SortDescriptor<EventsModel>] = []
        switch selectedSortOption {
        case .byDate:
            sortDescriptors = [SortDescriptor(\.date, order: isAscending ? .forward : .reverse)]
        case .byName:
            sortDescriptors = [SortDescriptor(\.title, order: isAscending ? .forward : .reverse)]
        }
        
        let fetchDescriptor = FetchDescriptor<EventsModel>(
            predicate: #Predicate { event in
                event.date <= now
            },
            sortBy: sortDescriptors
        )
        
        do {
            let allHistory = try modelContext.fetch(fetchDescriptor)
            if selectedEventType == .allEvents {
                filteredModels = allHistory
            } else {
                filteredModels = allHistory.filter { $0.type == selectedEventType }
            }
        } catch {
            print("Error fetching finished events: \(error)")
            filteredModels = []
        }
    }
    
    // MARK: - Deletion Methods
    func deleteEvent(_ event: EventsModel) {
        NotificationManager.cancelNotifications(for: event)
        modelContext.delete(event)
        do {
            try modelContext.save()
            loadHistoryEvents()
        } catch {
            print("Error deleting event: \(error)")
        }
    }
    
    
    // MARK: - Sorting Methods
    func toggleSortDirection() {
        isAscending.toggle()
        loadHistoryEvents()
    }
    
    // MARK: - Bookmark Handling
    func toggleBookmark(for event: EventsModel) {
        event.isBookmarked.toggle()
        do {
            try modelContext.save()
            loadHistoryEvents()
        } catch {
            print("Error toggling bookmark: \(error)")
        }
    }
    
    // MARK: - Timer Management
    private func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in
                guard let self = self else { return }
                self.currentDate = now
                self.loadHistoryEvents()
            }
    }
    
    // MARK: - Time Calculation
    func timeLeftString(for event: EventsModel) -> String {
        return "Finish".localized
    }
    
    // MARK: - Deinitializer
    deinit {
        timerCancellable?.cancel()
    }
}
