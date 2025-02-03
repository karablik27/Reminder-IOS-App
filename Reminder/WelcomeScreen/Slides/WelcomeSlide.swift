import Foundation

struct WelcomeSlide: Identifiable {
    let id = UUID()
    let number: Int
    let icons: [SlideIcon]
    let slideTitles: [SlideTitle]
    let slideTexts: [SlideText]

    init(number: Int, icons: [SlideIcon] = [], slideTitles: [SlideTitle] = [], slideTexts: [SlideText] = []) {
        self.number = number
        self.icons = icons
        self.slideTitles = slideTitles
        self.slideTexts = slideTexts
    }
}

