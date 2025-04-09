import Foundation
import SwiftData

// MARK: - Model
@Model
final class LoadingModel {
    
    var time: Date
    var isFirst: Bool
    
    init(time: Date, isFirst: Bool = false) {
        self.time = time
        self.isFirst = isFirst
    }
}
