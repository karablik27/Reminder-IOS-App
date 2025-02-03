import Foundation
import SwiftData
import Combine

class MainViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var selectedTab: Int = 0
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .allEvents
    private var modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption: String, CaseIterable {
        case allEvents = "All events"
        case byDate = "By date"
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        setupBindings()
        loadMockEvents() // Временно для демонстрации
    }
    
    private func setupBindings() {
        $sortOption
            .sink { [weak self] option in
                self?.sortEvents(by: option)
            }
            .store(in: &cancellables)
    }
    
    private func sortEvents(by option: SortOption) {
        switch option {
        case .allEvents:
            events.sort { $0.date < $1.date }
        case .byDate:
            events.sort { $0.date < $1.date }
        }
    }
    
    private func loadMockEvents() {
        events = [
            Event(title: "Shrek 5", date: Calendar.current.date(from: DateComponents(year: 2026, month: 12, day: 25))!, icon: "face.smiling"),
            Event(title: "My birthday", date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 27))!, icon: "gift"),
            Event(title: "Last day of course 2", date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 30))!, icon: "graduationcap"),
            Event(title: "Cosmonautics Day", date: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 12))!, icon: "party.popper")
        ]
    }
}
