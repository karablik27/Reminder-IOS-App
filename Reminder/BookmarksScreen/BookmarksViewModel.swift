import SwiftUI
import SwiftData
import Combine

// MARK: - BookmarksViewModel
class BookmarksViewModel: ObservableObject {
    
    // MARK: - Published Properties
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
        loadBookmarks()
        startTimer()
    }
    
    // MARK: - Data Loading
    func loadBookmarks() {
        print("Loading bookmarked events...")
        
        var sortDescriptors: [SortDescriptor<MainModel>] = []
        switch selectedSortOption {
        case .byDate:
            sortDescriptors = [SortDescriptor(\.date, order: isAscending ? .forward : .reverse)]
        case .byName:
            sortDescriptors = [SortDescriptor(\.title, order: isAscending ? .forward : .reverse)]
        }
        
        let fetchDescriptor = FetchDescriptor<MainModel>(
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
            print("Fetched \(filteredModels.count) bookmarked events.")
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
        print("Bookmarks sort toggled to \(isAscending ? "ascending" : "descending")")
        loadBookmarks()
    }
    
    // MARK: - Deletion Methods
    func deleteEvent(_ event: MainModel) {
        modelContext.delete(event)
        do {
            try modelContext.save()
            loadBookmarks()
            print("Bookmarked event deleted.")
        } catch {
            print("Error deleting bookmarked event: \(error)")
        }
    }
    
    func deleteAllBookmarkedEvents() {
        let fetchDescriptor = FetchDescriptor<MainModel>(
            predicate: #Predicate { event in
                event.isBookmarked == true
            }
        )
        do {
            let allBookmarked = try modelContext.fetch(fetchDescriptor)
            for event in allBookmarked {
                modelContext.delete(event)
            }
            try modelContext.save()
            loadBookmarks()
            print("All bookmarked events deleted.")
        } catch {
            print("Error deleting all bookmarked events: \(error)")
        }
    }
    
    // MARK: - Bookmark Handling
    func toggleBookmark(for event: MainModel) {
        event.isBookmarked.toggle()
        do {
            try modelContext.save()
            loadBookmarks()
        } catch {
            print("Error toggling bookmark: \(error)")
        }
    }
    
    // MARK: - Time Calculation
    func timeLeftString(for event: MainModel) -> String {
        let now = currentDate
        if event.date <= now {
            return "Finish"
        }
        
        let diff = event.date.timeIntervalSince(now)
        let days = Int(diff / 86400)
        if days >= 1 {
            return "\(days) days"
        } else {
            let hours = Int(diff / 3600)
            let minutes = Int((diff.truncatingRemainder(dividingBy: 3600)) / 60)
            let seconds = Int(diff.truncatingRemainder(dividingBy: 60))
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    // MARK: - Deinitializer
    deinit {
        timerCancellable?.cancel()
    }
}
