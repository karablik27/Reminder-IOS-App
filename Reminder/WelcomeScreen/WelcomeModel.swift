import Foundation
import SwiftData

@Model
final class WelcomeModel {
    var currentSlideIndex: Int
    var hasSeenWelcome: Bool
    var timestamp: Date
    
    init(currentSlideIndex: Int = 0, hasSeenWelcome: Bool = false, timestamp: Date = Date()) {
        self.currentSlideIndex = currentSlideIndex
        self.hasSeenWelcome = hasSeenWelcome
        self.timestamp = timestamp
    }
}


