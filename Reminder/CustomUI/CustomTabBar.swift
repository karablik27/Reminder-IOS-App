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
    // MARK: TabBar Constants
    enum TabBar {
        /// Height of the tab bar (without the notch).
        static let height: CGFloat = 90
        /// Icon size in the tab bar.
        static let iconSize: CGFloat = 28
        /// Notch radius (half the width of the notch).
        static let notchRadius: CGFloat = 35
        /// Size of the "plus" button (navigation link) circle.
        static let linkCircleSize: CGFloat = 44
        /// Corner radius for the tab bar.
        static let cornerRadius: CGFloat = 56
        /// Shadow radius for the green tab bar.
        static let shadowRadius: CGFloat = 12
        /// Shadow opacity for the green tab bar.
        static let shadowOpacity: Double = 0.15
        /// Vertical offset for the "plus" button.
        static let offsetY: CGFloat = -37
    }
    
    // MARK: Layout Constants
    /// Horizontal padding used in the tab bar icons row.
    static let horizontalPadding: CGFloat = 32
}

// MARK: - CustomTabBar
/// A custom tab bar view with a notch cutout in the center and a central "plus" button.
struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            // 1) Base white shape.
            TabBarShape()
                .fill(Color.white)
                .frame(height: Constants.TabBar.height)
                .padding(.horizontal)
                .zIndex(0)
            
            // 2) Green tab bar shape with shadow.
            TabBarShape()
                .fill(Colors.GreenTabBar)
                .shadow(
                    color: .black.opacity(Constants.TabBar.shadowOpacity),
                    radius: Constants.TabBar.shadowRadius,
                    x: 0, y: 0
                )
                .frame(height: Constants.TabBar.height)
                .zIndex(1)
            
            // 3) Tab bar icons.
            HStack {
                // "Events" tab.
                TabBarButton(image: "list.bullet", index: 0, selectedTab: $selectedTab)
                // Second tab.
                TabBarButton(image: "sparkles", index: 1, selectedTab: $selectedTab)
                
                // Spacer for "plus" button.
                Spacer(minLength: Constants.TabBar.notchRadius * 2)
                
                // "Bookmarks" tab.
                TabBarButton(image: "bookmark", index: 2, selectedTab: $selectedTab)
                // "Clock" tab.
                TabBarButton(image: "clock", index: 3, selectedTab: $selectedTab)
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .frame(height: Constants.TabBar.height)
            .zIndex(2)
            
            // 4) Plus button in the center notch.
            NavigationLink(destination: AddEventView(viewModel: AddEventViewModel(modelContext: modelContext))) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .overlay(
                            Circle().stroke(Color.black, lineWidth: 4)
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
                .font(.system(size: Constants.TabBar.iconSize * 1.3))
                .foregroundColor(selectedTab == index ? .black : .gray)
                .frame(maxWidth: .infinity)
        }
    }
}
