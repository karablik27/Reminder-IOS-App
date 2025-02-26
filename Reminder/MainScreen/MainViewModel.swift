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
    @Published var filteredModels: [MainModel] = []

    @Query private var events: [MainModel]

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func loadEvents() {
        filteredModels = events
    }

    func toggleSortDirection() {
        isAscending.toggle()
    }
}
