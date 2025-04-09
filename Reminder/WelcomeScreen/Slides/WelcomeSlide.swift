import Foundation

// MARK: - Local Model
struct WelcomeSlide: Identifiable {
    let id = UUID()
    let number: Int
    let icons: [SlideIcon]
    let slideTitles: [SlideTitle]
    let slideTexts: [SlideText]
    
    // Сохраняем исходные строки локализации в приватных свойствах
    private let _searchExplanation: String?
    private let _sortExplanation: String?
    
    // Вычисляемые свойства, которые динамически возвращают локализованный текст
    var searchExplanation: String? {
        _searchExplanation?.localized
    }
    
    var sortExplanation: String? {
        _sortExplanation?.localized
    }
    
    // MARK: - Initialization
    init(
        number: Int,
        icons: [SlideIcon] = [],
        slideTitles: [SlideTitle] = [],
        slideTexts: [SlideText] = [],
        searchExplanation: String? = nil,
        sortExplanation: String? = nil
    ) {
        self.number = number
        self.icons = icons
        self.slideTitles = slideTitles
        self.slideTexts = slideTexts
        self._searchExplanation = searchExplanation
        self._sortExplanation = sortExplanation
    }
}
