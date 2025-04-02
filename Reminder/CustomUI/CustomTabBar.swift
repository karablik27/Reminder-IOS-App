import SwiftUI
import SwiftData

// MARK: - Shape для фона таб-бара с вырезом (notch) в верхней центральной части
struct TabBarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let cornerRadius = Constants.TabBar.cornerRadius
        let notchRadius = Constants.TabBar.notchRadius
        let notchWidth = notchRadius * 2
        let centerX = rect.midX
        
        // Основной скруглённый прямоугольник
        let mainPath = Path(roundedRect: rect, cornerRadius: cornerRadius)
        
        // Дуга (полукруг), которую вычтем из основного прямоугольника
        var notchPath = Path()
        notchPath.addArc(
            center: CGPoint(x: centerX, y: rect.minY),
            radius: notchWidth / 2,
            startAngle: .degrees(360),
            endAngle: .degrees(180),
            clockwise: false
        )
        
        // Возвращаем разность: (скруглённый прямоугольник) - (дуга)
        return mainPath.subtracting(notchPath)
    }
}

// MARK: - Константы
private enum Constants {
    enum TabBar {
        /// Высота таб-бара (без выреза)
        static let height: CGFloat = 90
        /// Размер иконок
        static let iconSize: CGFloat = 28
        /// Радиус выреза (notch)
        static let notchRadius: CGFloat = 35
        /// Размер кнопки "plus" – NavigationLink
        static let linkCircleSize: CGFloat = 44
        /// Скругление таб-бара
        static let cornerRadius: CGFloat = 56
        /// Параметры тени
        static let shadowRadius: CGFloat = 12
        static let shadowOpacity: Double = 0.15
        
        static let offsetY: CGFloat = -37
    }
    
    enum Colors {
        static let GreenTabBar = Color(red: 0.8, green: 1, blue: 0.85, opacity: 0.9)
    }
}


struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            // 1) Базовая белая форма
            TabBarShape()
                .fill(Color.white)
                .frame(height: Constants.TabBar.height)
                .padding(.horizontal)
                .zIndex(0)
            
            // 2) Зеленая форма таб-бара с тенью
            TabBarShape()
                .fill(Constants.Colors.GreenTabBar)
                .shadow(
                    color: .black.opacity(Constants.TabBar.shadowOpacity),
                    radius: Constants.TabBar.shadowRadius,
                    x: 0, y: 0
                )
                .frame(height: Constants.TabBar.height)
                .zIndex(1)
            
            // 3) Иконки таб-бара
            HStack {
                // Вкладка "Events"
                TabBarButton(image: "list.bullet", index: 0, selectedTab: $selectedTab)
                
                TabBarButton(image: "sparkles", index: 1, selectedTab: $selectedTab)
                
                // Отступ для кнопки "plus"
                Spacer(minLength: Constants.TabBar.notchRadius * 2)
                
                TabBarButton(image: "bookmark", index: 2, selectedTab: $selectedTab)
                // Дополнительные вкладки
                TabBarButton(image: "clock", index: 3, selectedTab: $selectedTab)
                
            }
            .padding(.horizontal, 32)
            .frame(height: Constants.TabBar.height)
            .zIndex(2)
            
            // 4) Кнопка "plus" в центре выреза
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
            .buttonStyle(PlainButtonStyle()) // Добавляем стиль кнопки
            .offset(y: Constants.TabBar.offsetY)
            .zIndex(3)

        }
        .frame(maxWidth: .infinity)
    }
}

// Пример кнопки для таб-бара:
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

