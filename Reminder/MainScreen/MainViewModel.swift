import SwiftData
import Combine
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var models: [MainModel] = []
    @Published var selectedTab: Int = 0
    @Published var searchText: String = ""
    @Published var selectedEventType: EventType = .allEvents
    @Published var selectedSortOption: SortOption = .byDate
    @Published var isAscending = true

    @Query private var modelsQuery: [MainModel]

    private var cancellables = Set<AnyCancellable>()

    enum SortOption: String, CaseIterable {
        case byDate = "By date"
        case byName = "By name"
    }

    init() {
        setupBindings()
    }

    private func setupBindings() {
        Publishers.CombineLatest3($selectedEventType, $selectedSortOption, $isAscending)
            .sink { [weak self] type, sort, ascending in
                self?.filterAndSortEvents(type: type, sort: sort, ascending: ascending)
            }
            .store(in: &cancellables)
    }

    private func filterAndSortEvents(type: EventType, sort: SortOption, ascending: Bool) {
        // Сначала фильтруем по типу
        var filteredModels = modelsQuery
        
        if type != .allEvents {
            filteredModels = modelsQuery.filter { $0.type == type }
        }
        
        // Затем сортируем
        switch sort {
        case .byDate:
            filteredModels.sort { first, second in
                ascending ? first.date < second.date : first.date > second.date
            }
        case .byName:
            filteredModels.sort { first, second in
                ascending ? first.title < second.title : first.title > second.title
            }
        }
        
        models = filteredModels // Обновляем локальную модель для UI
    }

    func toggleSortDirection() {
        isAscending.toggle()
    }
}
