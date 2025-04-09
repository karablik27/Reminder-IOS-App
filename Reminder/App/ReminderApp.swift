import SwiftUI
import SwiftData

// MARK: - ReminderApp Entry Point
@main
struct ReminderApp: App {

    // MARK: - Model Container
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            LoadingModel.self,
            WelcomeModel.self,
            EventsModel.self,
            NotificationsModel.self,
            LocalizationModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // MARK: - Scene
    var body: some Scene {
        WindowGroup {
            LoadingView()
                .modelContainer(sharedModelContainer)
        }
    }
}
