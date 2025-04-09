import Foundation
import SwiftData
import SwiftUI

// MARK: - Merged WelcomeModel
@Model
final class WelcomeModel: Identifiable {
    var id = UUID()
    
    // MARK: - Dynamic Properties
    var currentSlideIndex: Int
    var hasSeenWelcome: Bool
    
    // MARK: - Computed Static Content
    var slides: [WelcomeSlide] {
        return WelcomeScreenData.slides
    }
    
    // MARK: - Initialization
    init(
        currentSlideIndex: Int = 0,
        hasSeenWelcome: Bool = false
    ) {
        self.currentSlideIndex = currentSlideIndex
        self.hasSeenWelcome = hasSeenWelcome
    }
}
