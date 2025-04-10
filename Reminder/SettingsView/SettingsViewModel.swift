import SwiftUI
import Combine
import SwiftData

//MARK: - SettingsViewModel
final class SettingsViewModel: ObservableObject {

    private var modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func factoryReset() {
        do {
            let events = try modelContext.fetch(FetchDescriptor<EventsModel>())
            for event in events {
                modelContext.delete(event)
            }
            try modelContext.save()
        } catch {
            print("Error during factory reset (events): \(error)")
        }
    }

}
