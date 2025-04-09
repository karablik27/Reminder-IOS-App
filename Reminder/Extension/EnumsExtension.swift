import SwiftUI

// MARK: - FirstRemind Extension
extension FirstRemind {
    var displayName: String {
        rawValue.localized
    }
}

// MARK: - ReminderFrequency Extension
extension ReminderFrequency {
    var displayName: String {
        rawValue.localized
    }
}

// MARK: - EventTypeMain Extension
extension EventTypeMain {
    var displayName: String {
        rawValue.localized
    }
}

// MARK: - EventTypeAddEvent Extension
extension EventTypeAddEvent {
    var displayName: String {
        rawValue.localized
    }
}

// MARK: - SortOption Extension
extension SortOption {
    var displayName: String {
        rawValue.localized
    }
}
