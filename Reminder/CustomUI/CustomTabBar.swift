import SwiftUI
import SwiftData

// MARK: - CustomTabBarShape
/// A shape for the tab bar background with a notch cutout at the top center.
struct TabBarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let cornerRadius = Constants.TabBar.cornerRadius
        let notchRadius = Constants.TabBar.notchRadius
        let notchWidth = notchRadius * 2
        let centerX = rect.midX

        // Main rounded rectangle path.
        let mainPath = Path(roundedRect: rect, cornerRadius: cornerRadius)

        // Notch path (semicircular arc) to be subtracted.
        var notchPath = Path()
        notchPath.addArc(
            center: CGPoint(x: centerX, y: rect.minY),
            radius: notchWidth / 2,
            startAngle: .degrees(360),
            endAngle: .degrees(180),
            clockwise: false
        )

        // Return the main path minus the notch.
        return mainPath.subtracting(notchPath)
    }
}

// MARK: - Constants
private enum Constants {
    
    enum TabBar {
        static let height: CGFloat = 90
        static let iconSize: CGFloat = 28
        static let notchRadius: CGFloat = 35
        static let linkCircleSize: CGFloat = 44
        static let cornerRadius: CGFloat = 56
        static let shadowRadius: CGFloat = 12
        static let shadowOpacity: Double = 0.15
        static let offsetY: CGFloat = -37
        static let iconScale: CGFloat = 1.3
        static let shadowXY: CGFloat = 0
    }
    static let horizontalPadding: CGFloat = 32
    static let lineWidth: CGFloat = 4
}

// MARK: - CustomTabBar
/// A custom tab bar view with a notch cutout in the center and a central "plus" button.
struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            // MARK: 1. Base shape
            TabBarShape()
                .fill(Color.white)
                .frame(height: Constants.TabBar.height)
                .padding(.horizontal)
                .zIndex(0)

            // MARK: 2. Colored shape with shadow
            TabBarShape()
                .fill(Colors.GreenTabBar)
                .shadow(
                    color: .black.opacity(Constants.TabBar.shadowOpacity),
                    radius: Constants.TabBar.shadowRadius,
                    x: Constants.TabBar.shadowXY, y: Constants.TabBar.shadowXY
                )
                .frame(height: Constants.TabBar.height)
                .zIndex(1)

            // MARK: 3. Icons
            HStack {
                TabBarButton(image: "list.bullet", index: 0, selectedTab: $selectedTab)
                TabBarButton(image: "sparkles", index: 1, selectedTab: $selectedTab)

                Spacer(minLength: Constants.TabBar.notchRadius * 2)

                TabBarButton(image: "bookmark", index: 2, selectedTab: $selectedTab)
                TabBarButton(image: "clock", index: 3, selectedTab: $selectedTab)
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .frame(height: Constants.TabBar.height)
            .zIndex(2)

            // MARK: 4. Plus button
            NavigationLink(destination: AddEventView(viewModel: AddEventViewModel(modelContext: modelContext))) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .overlay(
                            Circle().stroke(Color.black, lineWidth: Constants.lineWidth)
                        )
                        .frame(width: Constants.TabBar.linkCircleSize,
                               height: Constants.TabBar.linkCircleSize)

                    Image(systemName: "plus")
                        .font(.system(size: Constants.TabBar.iconSize, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .offset(y: Constants.TabBar.offsetY)
            .zIndex(3)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - TabBarButton
/// A button used within the custom tab bar to select the desired tab.
struct TabBarButton: View {
    let image: String
    let index: Int
    @Binding var selectedTab: Int

    var body: some View {
        Button {
            selectedTab = index
        } label: {
            Image(systemName: image)
                .font(.system(size: Constants.TabBar.iconSize * Constants.TabBar.iconScale))
                .foregroundColor(selectedTab == index ? .black : .gray)
                .frame(maxWidth: .infinity)
        }
    }
}
