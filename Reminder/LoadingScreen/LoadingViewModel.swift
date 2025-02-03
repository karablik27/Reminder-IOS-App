import Combine
import Foundation

final class LoadingViewModel: ObservableObject {
    @Published var isFinishedLoading = false
    @Published var loadingModel: LoadingModel
    private var cancellables = Set<AnyCancellable>()

    init() {
        let userDefaults = UserDefaults.standard
        let isFirst = !userDefaults.bool(forKey: "hasLaunchedBefore")
        self.loadingModel = LoadingModel(time: Date(), isFirst: isFirst)
        
        if isFirst {
            userDefaults.set(true, forKey: "hasLaunchedBefore")
        }
        
        startLoading()
    }
    
    func startLoading() {
        Just(true)
            .delay(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Загрузка завершена")
                case .failure(let error):
                    print("Ошибка загрузки: \(error)")
                }
            }, receiveValue: { [weak self] _ in
                self?.isFinishedLoading = true
            })
            .store(in: &cancellables)
    }
}




