import Foundation
import SwiftData

@Model
final class NotificationsModel {
    @Attribute var id: UUID = UUID()
    @Attribute var isPushEnabled: Bool = false
    @Attribute var isManuallySet: Bool = false

    init(isPushEnabled: Bool = false, isManuallySet: Bool = false) {
        self.isPushEnabled = isPushEnabled
        self.isManuallySet = isManuallySet
    }
}
