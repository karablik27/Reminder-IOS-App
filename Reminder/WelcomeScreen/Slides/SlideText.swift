import SwiftUI

// MARK: - Local Model
struct SlideText: Identifiable {
    let id = UUID()
    let text: String
    let offset: CGSize
    let font: Font
    let color: Color
    let alignment: TextAlignment

    init(text: String, offset: CGSize = .zero, font: Font = .body, color: Color = .primary, alignment: TextAlignment = .center) {
        self.text = text
        self.offset = offset
        self.font = font
        self.color = color
        self.alignment = alignment
    }
}

