import SwiftUI
import SwiftData

private enum Constants {
    enum TabBar {
        // Размер зелёного бара
        static let height: CGFloat = UIScreen.main.bounds.height * 0.1
        static let iconSize: CGFloat = UIScreen.main.bounds.width * 0.06
        
        // Большой белый круг (декоративный)
        static let whiteCircleSize: CGFloat = 60
        
        // Меньший круг-кнопка (NavigationLink), внутри белый с чёрной границей
        static let linkCircleSize: CGFloat = 44
        
        // Радиус и тень бара
        static let cornerRadius: CGFloat = UIScreen.main.bounds.width * 0.09
        static let shadowRadius: CGFloat = UIScreen.main.bounds.width * 0.025
        static let shadowOpacity: Double = 0.15
        
        // Смещение кругов вверх
        static let circleOffsetY: CGFloat = -0.55 * whiteCircleSize
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            // 1) Зелёный таббар
            HStack(spacing: 0) {
                TabBarButton(image: "list.bullet", index: 0, selectedTab: $selectedTab)
                TabBarButton(image: "bookmark",   index: 1, selectedTab: $selectedTab)
                TabBarButton(image: "clock",      index: 2, selectedTab: $selectedTab)
                TabBarButton(image: "gearshape",  index: 3, selectedTab: $selectedTab)
            }
            .padding()
            .frame(height: Constants.TabBar.height)
            .background(Colors.GreenTabBar) // Ваш зелёный цвет
            .cornerRadius(Constants.TabBar.cornerRadius)
            .shadow(
                color: .black.opacity(Constants.TabBar.shadowOpacity),
                radius: Constants.TabBar.shadowRadius,
                x: 0, y: 0
            )
            .padding(.horizontal)
            
            // 2) Большой белый круг (декоративный, не кнопка)
            Circle()
                .fill(Color.white)
                .frame(width: Constants.TabBar.whiteCircleSize,
                       height: Constants.TabBar.whiteCircleSize)
                .offset(y: Constants.TabBar.circleOffsetY)
            
            // 3) Меньший круг - NavigationLink (белый, с чёрной окантовкой, чёрным плюсом)
            NavigationLink(destination: AddEventView(viewModel: AddEventViewModel(modelContext: modelContext))) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .overlay(
                            Circle()
                                .stroke(.black, lineWidth: 4)
                        )
                        .frame(width: Constants.TabBar.linkCircleSize,
                               height: Constants.TabBar.linkCircleSize)
                    
                    Image(systemName: "plus")
                        .font(.system(size: Constants.TabBar.iconSize, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            // Смещаем так же, чтобы быть в центре белого круга
            .offset(y: Constants.TabBar.circleOffsetY)
        }
    }
}

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
