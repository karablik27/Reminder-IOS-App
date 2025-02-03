import Foundation
import SwiftData

@Model
final class LoadingModel {
    var time: Date
    var isFirst: Bool
    
    init(time: Date, isFirst: Bool = false) {
        self.time = time
        self.isFirst = isFirst
    }
}

