import SwiftUI
import Combine

struct LoadingView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = LoadingViewModel()
    @State private var logoOpacity: Double = 0.0
    @State private var showWelcome = false

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack {
                Spacer()
                
                Image("App Icon")
                    .resizable()
                    .offset(x: 5, y: -150)
                    .frame(width: 150, height: 160)
                    .opacity(logoOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.5)) {
                            logoOpacity = 1.0
                        }
                    }

                if viewModel.loadingModel.isFirst {
                    Text("Welcome")
                        .padding()
                        .font(.title)
                        .offset(x: 5, y: -160)
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


