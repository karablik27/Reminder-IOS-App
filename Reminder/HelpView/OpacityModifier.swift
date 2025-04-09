import SwiftUI

// MARK: - OpacityModifier
struct OpacityModifier: ViewModifier {

    // MARK: - Properties
    let tabBarHeight: CGFloat
    let margin: CGFloat

    // MARK: - Body
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
