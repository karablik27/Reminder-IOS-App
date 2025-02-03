import Foundation
import SwiftUI
import SwiftData

final class WelcomeViewModel: ObservableObject {
    @Published var currentPage: Int
    @Published var welcomeModel: WelcomeModel

    init(modelContext: ModelContext) {
        let model = WelcomeModel()
        self.welcomeModel = model
        self.currentPage = model.currentSlideIndex
        modelContext.insert(model)
    }
    
    let slides = WelcomeScreenData.slides
    
    func nextPage() {
        if currentPage < slides.count - 1 {
            withAnimation {
                currentPage += 1
                welcomeModel.currentSlideIndex = currentPage
            }
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            withAnimation {
                currentPage -= 1
                welcomeModel.currentSlideIndex = currentPage
            }
        }
    }
    
    func goToPage(_ page: Int) {
        withAnimation {
            currentPage = min(max(page, 0), slides.count - 1)
            welcomeModel.currentSlideIndex = currentPage
        }
    }
    
    func markWelcomeAsSeen() {
        welcomeModel.hasSeenWelcome = true
    }
}



