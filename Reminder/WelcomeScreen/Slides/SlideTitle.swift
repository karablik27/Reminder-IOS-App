import SwiftUI

// MARK: - Local Model
struct SlideTitle: Identifiable {
    let id = UUID()
    let text: String
    let offset: CGSize
    let font: Font
    let color: Color

    init(text: String, offset: CGSize = .zero, font: Font = .title, color: Color = .primary) {
        self.text = text
        self.offset = offset
        self.font = font
        self.color = color
    }
}

