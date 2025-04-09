import Foundation

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let beautyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        return formatter
    }()
}
