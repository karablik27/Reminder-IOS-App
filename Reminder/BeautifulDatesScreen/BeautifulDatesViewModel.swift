import SwiftUI
import SwiftData
import Combine


class BeautifulDatesViewModel: ObservableObject {

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
        loadBeautifulEvents()
        startTimer()
    }
    
    // MARK: - Loading Beautiful Events
    func loadBeautifulEvents() {
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
    func deleteEvent(_ event: MainModel) {
        modelContext.delete(event)
        do {
            try modelContext.save()
            loadBeautifulEvents()
        } catch {
            print("Error deleting event: \(error)")
        }
    }
    
    func deleteAllBeautifulEvents() {
        let fetchDescriptor = FetchDescriptor<MainModel>()
        do {
            let allEvents = try modelContext.fetch(fetchDescriptor)
            let allBeautiful = allEvents.filter { $0.isBeautiful }
            for event in allBeautiful {
                modelContext.delete(event)
            }
            try modelContext.save()
            loadBeautifulEvents()
        } catch {
            print("Error deleting all beautiful events: \(error)")
        }
    }
    
    // MARK: - Bookmark Handling
    func toggleBookmark(for event: MainModel) {
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
