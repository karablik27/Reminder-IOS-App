import SwiftUI

struct SlideIcon: Identifiable {
    let id = UUID()
    let iconName: String
    let offset: CGSize
    let size: CGSize
    
    init(iconName: String, offset: CGSize = .zero, size: CGSize = CGSize(width: 80, height: 80)) {
        self.iconName = iconName
        self.offset = offset
        self.size = size
    }
}

