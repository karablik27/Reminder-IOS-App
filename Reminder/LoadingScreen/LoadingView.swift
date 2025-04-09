import SwiftUI
import Combine
import SwiftData

// MARK: - Constants

private enum Constants {
    enum Image {
        static let offsetY: CGFloat = -24
        static let width: CGFloat = 160
        static let height: CGFloat = 160
        static let cornerRadius: CGFloat = 20
    }
    enum Animation {
        static let initialOpacity: Double = 0.0
        static let duration: Double = 0.5
        static let finalOpacity: Double = 1.0
    }
    enum ScreenState {
        case loading, welcome, content
    }
}

// MARK: - MainView
struct LoadingView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @StateObject private var viewModel = LoadingViewModel()
    @State private var logoOpacity: Double = Constants.Animation.initialOpacity
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @State private var currentScreen: Constants.ScreenState = .loading

    var body: some View {
        ZStack {
            switch currentScreen {
            case .content:
                ContentView(modelContext: modelContext)
                    .transition(.opacity)
            case .welcome:
                WelcomeView(modelContext: modelContext, onDismiss: {
                    withAnimation(.easeInOut(duration: Constants.Animation.duration)) {
                        currentScreen = .content
                    }
                })
                .transition(.opacity)
            case .loading:
                LoadingStateView(
                    logoOpacity: logoOpacity,
                    animationDuration: Constants.Animation.duration,
                    loadingModelIsFirst: viewModel.loadingModel.isFirst
                )
            }
        }
        .onAppear {
            let fetchDescriptor = FetchDescriptor<LocalizationModel>()
            if let savedLanguage = try? modelContext.fetch(fetchDescriptor).first?.selectedLanguage {
                Localizer.selectedLanguage = savedLanguage
            }

            withAnimation(.easeIn(duration: Constants.Animation.duration)) {
                logoOpacity = Constants.Animation.finalOpacity
            }
            
            let delay = isFirstLaunch ? Constants.Animation.finalOpacity : Constants.Animation.duration
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                viewModel.startLoading {
                    withAnimation(.easeInOut(duration: Constants.Animation.duration)) {
                        currentScreen = isFirstLaunch ? .welcome : .content
                    }
                }
            }
        }
    }
}

// MARK: - SubView
struct LoadingStateView: View {
    let logoOpacity: Double
    let animationDuration: Double
    let loadingModelIsFirst: Bool

    var body: some View {
        VStack {
            Spacer()
            
            Image("default_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Constants.Image.width, height: Constants.Image.height)
                .clipShape(RoundedRectangle(cornerRadius: Constants.Image.cornerRadius))
                .opacity(logoOpacity)
                .animation(.easeIn(duration: animationDuration), value: logoOpacity)
                .offset(y: Constants.Image.offsetY)
            
            if loadingModelIsFirst {
                Text("Welcome".localized)
                    .font(.system(size: ConstantsMain.Text.titleSize, weight: .bold))
                    .padding()
                    .animation(.easeIn(duration: animationDuration), value: logoOpacity)
            }
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea()
        .transition(.opacity)
    }
}

