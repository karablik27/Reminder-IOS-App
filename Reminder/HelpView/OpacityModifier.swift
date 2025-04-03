import SwiftUI

struct OpacityModifier: ViewModifier {
    let tabBarHeight: CGFloat
    let margin: CGFloat

    func body(content: Content) -> some View {
        GeometryReader { geo in
            let cellFrame = geo.frame(in: .global)
            let screenHeight = UIScreen.main.bounds.height
            let safeAreaInsets = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first?.safeAreaInsets.bottom ?? 0
            let tabBarTop = screenHeight - (tabBarHeight + safeAreaInsets)
            let computedOpacity = cellFrame.maxY >= tabBarTop + margin ? 0.0 : 1.0

            content
                .opacity(computedOpacity)
                .animation(.easeInOut, value: computedOpacity)
        }
    }
}

extension View {
    func adjustableOpacity(tabBarHeight: CGFloat = ConstantsMain.TabBar.height, margin: CGFloat = 8) -> some View {
        self.modifier(OpacityModifier(tabBarHeight: tabBarHeight, margin: margin))
    }
}
