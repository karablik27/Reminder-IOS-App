import SwiftUI
import SwiftData
import Combine

enum SortOption: String, CaseIterable {
    case byDate = "By date"
    case byName = "By name"
}


class MainViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var searchText: String = ""
    @Published var selectedEventType: Enums.EventType = .allEvents
    @Published var selectedSortOption: SortOption = .byDate
    @Published var isAscending = true
    @Published var filteredModels: [MainModel] = [] // Все события для отображения

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        print("MainViewModel initialized with modelContext: \(modelContext)")
        loadEvents() // Загружаем события при инициализации
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
        loadEvents() // Обновляем события при смене направления сортировки
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

        // Метод для удаления всех событий
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
}

