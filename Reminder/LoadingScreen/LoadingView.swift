import SwiftUI
import Combine
import SwiftData

struct LoadingView: View {
    // MARK: - Constants
    private enum Constants {
        enum Image {
            static let widthMultiplier: CGFloat = 0.4
            static let heightMultiplier: CGFloat = 0.2
            static let verticalOffset: CGFloat = -0.15
        }
        
        enum Animation {
            static let duration: Double = 0.5
            static let initialOpacity: Double = 0.0
            static let finalOpacity: Double = 1.0
        }
        
        enum WelcomeText {
            static let fontSize: CGFloat = 34
            static let verticalOffset: CGFloat = -20
        }
    }
    
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = LoadingViewModel()
    @State private var logoOpacity: Double = Constants.Animation.initialOpacity
    @State private var showWelcome = false
    @State private var showMainView = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: Constants.WelcomeText.verticalOffset) {
                        Image("default_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                width: geometry.size.width * Constants.Image.widthMultiplier,
                                height: geometry.size.height * Constants.Image.heightMultiplier
                            )
                            .offset(y: geometry.size.height * Constants.Image.verticalOffset)
                            .opacity(logoOpacity)
                        
                        if viewModel.loadingModel.isFirst {
                            Text("Welcome")
                                .font(.system(size: Constants.WelcomeText.fontSize, weight: .bold))
                                .padding()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
            }
            .onAppear {
                withAnimation(.easeIn(duration: Constants.Animation.duration)) {
                    logoOpacity = Constants.Animation.finalOpacity
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        if viewModel.loadingModel.isFirst {
                            showWelcome = true
                        } else {
                            showMainView = true
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showWelcome) {
                WelcomeView(modelContext: modelContext)
            }
            .fullScreenCover(isPresented: $showMainView) {
                // Передаём modelContext в ContentView
                ContentView(modelContext: modelContext)
            }
            .onChange(of: viewModel.isFinishedLoading) { old, new in
                if new {
                    if viewModel.loadingModel.isFirst {
                        showMainView = false
                        showWelcome = true
                    } else {
                        showMainView = true
                    }
                }
            }
        }
    }
}

#Preview {
    LoadingView()
}
