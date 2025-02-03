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
    
    let slides = [
        WelcomeSlide(
            number: 1,
            slideTitles: [
                SlideTitle(text: "Reminder", offset: CGSize(width: 0, height: 35), font: .system(size: 35, weight: .bold), color: .black)
            ],
            slideTexts: [
                SlideText(text: "Welcome to a convenient application that helps you remember the main thing.", offset: CGSize(width: 0, height: 25), font: .system(size: 17), color: .primary, alignment: .center)
            ]
        ),
        WelcomeSlide(
            number: 2,
            icons: [
                SlideIcon(iconName: "arrow.down", offset: CGSize(width: -130, height: 110), size: CGSize(width: 35, height: 35)),
                SlideIcon(iconName: "arrow.down", offset: CGSize(width: -60, height: 200), size: CGSize(width: 35, height: 35))
            ],
            slideTitles: [
                SlideTitle(text: "Create a new reminder", offset: CGSize(width: 0, height: -85), font: .system(size: 35, weight: .bold), color: .black)
            ],
            slideTexts: [
                SlideText(text: "1. Tap the '+' button to create a new reminder.", offset: CGSize(width: 0, height: -75), font: .system(size: 17), color: .primary, alignment: .center),
                SlideText(text: "2. Then choose a title, date, and more.", offset: CGSize(width: 0, height: -20), font: .body, color: .primary, alignment: .center),
                SlideText(text: "3. Save and wait for a reminder!", offset: CGSize(width: 40, height: 30), font: .body, color: .primary, alignment: .center)
            ]
            
        ),
        WelcomeSlide(
            number: 3,
            slideTitles: [
                SlideTitle(text: "Notifications", offset: CGSize(width: 0, height: 35), font: .system(size: 35, weight: .bold), color: .black)
            ],
            slideTexts: [
                SlideText(text: "Click allow to receive notifications about your events and more, or configure later in settings.", offset: CGSize(width: 0, height: 25), font: .system(size: 17), color: .primary, alignment: .center)
            ]
        ),
        WelcomeSlide(
            number: 4,
            icons: [
                SlideIcon(iconName: "magnifyingglass", offset: CGSize(width: -100, height: 150), size: CGSize(width: 50, height: 50)),
                SlideIcon(iconName: "arrow.up.arrow.down", offset: CGSize(width: -100, height: 400), size: CGSize(width: 50, height: 50))
            ],
            slideTitles: [
                SlideTitle(text: "Search and Sort events", offset: CGSize(width: 0, height: -85), font: .system(size: 35, weight: .bold), color: .black)
            ],
            slideTexts: [
                SlideText(text: "Search symbol", offset: CGSize(width: -90, height: 40), font: .system(size: 17), color: .primary, alignment: .center),
                SlideText(text: "Sort symbol", offset: CGSize(width: -95, height: 250), font: .system(size: 17), color: .primary, alignment: .center)
            ]
        )
    ]
    
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



