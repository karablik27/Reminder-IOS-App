import SwiftUI
import SwiftData
import Combine



class MainViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var searchText: String = ""
    @Published var selectedEventType: EventTypeMain = .allEvents
    @Published var selectedSortOption: SortOption = .byDate
    @Published var isAscending = true
    @Published var filteredModels: [MainModel] = []
    @Published var currentDate: Date = Date()

    private var modelContext: ModelContext
    private var timerCancellable: AnyCancellable?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        print("MainViewModel initialized with modelContext: \(modelContext)")
        loadEvents()
        startTimer()
    }

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

    func toggleSortDirection() {
        isAscending.toggle()
        print("Sort direction toggled to \(isAscending ? "ascending" : "descending")")
        loadEvents()
    }
    
    func deleteEvent(_ event: MainModel) {
            modelContext.delete(event)
            do {
                try modelContext.save()
                loadEvents()
                print("Событие удалено успешно")
            } catch {
                print("Ошибка при удалении события: \(error)")
            }
        }
    
    func deleteAllEvents() {
            let fetchDescriptor = FetchDescriptor<MainModel>()
            do {
                let allEvents = try modelContext.fetch(fetchDescriptor)
                for event in allEvents {
                    modelContext.delete(event)
                }
                try modelContext.save()
                loadEvents()
                print("Все события удалены успешно.")
            } catch {
                print("Ошибка при удалении всех событий: \(error)")
            }
        }
    
    
    private func startTimer() {
            timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] now in
                    self?.currentDate = now
                }
    }
    
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
    
    deinit {
            timerCancellable?.cancel()
    }
}

