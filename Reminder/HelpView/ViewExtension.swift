import SwiftUI

extension View {
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func adjustableOpacity(tabBarHeight: CGFloat = ConstantsMain.TabBar.height, margin: CGFloat = 8) -> some View {
        self.modifier(OpacityModifier(tabBarHeight: tabBarHeight, margin: margin))
    }
    
}
