import Combine
import Foundation

// MARK: - ViewModel
final class LoadingViewModel: ObservableObject {

    @Published var isFinishedLoading = false
    @Published var loadingModel: LoadingModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init() {
        let userDefaults = UserDefaults.standard
        let isFirst = !userDefaults.bool(forKey: "hasLaunchedBefore")
        self.loadingModel = LoadingModel(time: Date(), isFirst: isFirst)
        
        if isFirst {
            userDefaults.set(true, forKey: "hasLaunchedBefore")
        }
    }

    // MARK: - Public Methods
    func startLoading(completion: @escaping () -> Void) {
        Just(true)
            .delay(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink { _ in
                self.isFinishedLoading = true
                completion()
            }
            .store(in: &cancellables)
    }
}
