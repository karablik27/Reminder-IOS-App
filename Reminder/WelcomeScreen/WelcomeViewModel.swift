import Foundation
import SwiftUI
import SwiftData
import UserNotifications

// MARK: - ViewModel
final class WelcomeViewModel: ObservableObject {
    @Published var currentPage: Int
    @Published var welcomeModel: WelcomeModel
    @Published var showNotificationAlert = false
    @Published var notificationPermissionGranted = false
    @Published var showMainView = false

    let slides = WelcomeScreenData.slides

    private let modelContext: ModelContext

    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        let model = WelcomeModel()
        self.welcomeModel = model
        self.currentPage = model.currentSlideIndex
        modelContext.insert(model)
    }

    // MARK: - Slide Navigation
    func nextPage() {
        if currentPage < slides.count - 1 {
            withAnimation {
                currentPage += 1
                welcomeModel.currentSlideIndex = currentPage
            }
        }
    }

    // MARK: - Notifications
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                self.notificationPermissionGranted = granted
                self.showNotificationAlert = true
            }
        }
    }

    // MARK: - Completion
    func completeWelcome(_ dismiss: @escaping () -> Void, isFirstLaunch: Binding<Bool>) {
        withAnimation(.easeInOut(duration: 0.5)) {
            isFirstLaunch.wrappedValue = false
        }
        welcomeModel.hasSeenWelcome = true
        dismiss()
        showMainView = true
    }
}
