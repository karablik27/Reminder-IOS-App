import SwiftUI
import Combine

struct LoadingView: View {
    // MARK: - Constants
    private enum Constants {
        enum Image {
            static let offsetX: CGFloat = 5
            static let offsetY: CGFloat = -150
            static let width: CGFloat = 150
            static let height: CGFloat = 160
        }
        
        enum Animation {
            static let duration: Double = 0.5
            static let initialOpacity: Double = 0.0
            static let finalOpacity: Double = 1.0
        }
        
        enum WelcomeText {
            static let offsetX: CGFloat = 5
            static let offsetY: CGFloat = -160
        }
    }
    
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = LoadingViewModel()
    @State private var logoOpacity: Double = Constants.Animation.initialOpacity
    @State private var showWelcome = false

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack {
                Spacer()
                
                Image("App Icon")
                    .resizable()
                    .offset(
                        x: Constants.Image.offsetX,
                        y: Constants.Image.offsetY
                    )
                    .frame(
                        width: Constants.Image.width,
                        height: Constants.Image.height
                    )
                    .opacity(logoOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: Constants.Animation.duration)) {
                            logoOpacity = Constants.Animation.finalOpacity
                        }
                    }

                if viewModel.loadingModel.isFirst {
                    Text("Welcome")
                        .padding()
                        .font(.title)
                        .offset(
                            x: Constants.WelcomeText.offsetX,
                            y: Constants.WelcomeText.offsetY
                        )
                }

                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showWelcome) {
            WelcomeView(modelContext: modelContext)
        }
        .onChange(of: viewModel.isFinishedLoading) { old, new in
            if new && viewModel.loadingModel.isFirst {
                showWelcome = true
            }
        }
    }
}

#Preview {
    LoadingView()
}


