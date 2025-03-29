import Foundation

extension Date {
    /// Возвращает true, если дата «красивая» по хотя бы одному критерию.
    func isBeautifulDate() -> Bool {
        let dateString = DateFormatter.beautyFormatter.string(from: self) // "ddMMyyyy"
        let digits = Array(dateString)
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        let lastTwoDigitsOfYear = year % 100
        
        // 1) Палиндром: "02022020"
        if dateString == String(dateString.reversed()) {
            return true
        }
        
        // 2) Все цифры одинаковые: "11111111"
        if dateString.allSatisfy({ $0 == dateString.first }) {
            return true
        }
        
        // 3) Повторяющиеся пары: "12121212"
        if isRepeatedPairs(in: dateString) {
            return true
        }
        
        // 4) 29 февраля
        if day == 29 && month == 2 {
            return true
        }
        
        // 5) День = месяц
        if day == month {
            return true
        }
        
        // 6) День = последние 2 цифры года (напр. 25.01.2025)
        if day == lastTwoDigitsOfYear {
            return true
        }
        
        // 6) Месяц = последние 2 цифры года (напр. 01.12.2012)
        if month == lastTwoDigitsOfYear {
            return true
        }
        
        // 7) День + месяц = последние 2 цифры года (напр. 10+10=20 для 10.10.2020)
        if (day + month) == lastTwoDigitsOfYear {
            return true
        }
        
        // 8) Возрастающая последовательность цифр: "01234567"
        if isAscending(digits: digits) {
            return true
        }
        
        // 9) Убывающая последовательность цифр: "76543210"
        if isDescending(digits: digits) {
            return true
        }
        
        // 10) День, месяц и последние две цифры года равна (напр. 12.12.2012)
        if (day == month) && (month == lastTwoDigitsOfYear) {
            return true
        }
        
        return false
    }
    
    // MARK: - Вспомогательные методы
    private func isRepeatedPairs(in s: String) -> Bool {
        // "12121212" => пара "12" повторяется 4 раза
        guard s.count == 8 else { return false }
        let pair = s.prefix(2)
        for i in stride(from: 0, to: 8, by: 2) {
            let startIndex = s.index(s.startIndex, offsetBy: i)
            let endIndex = s.index(startIndex, offsetBy: 2)
            if s[startIndex..<endIndex] != pair {
                return false
            }
        }
        return true
    }
    
    private func isAscending(digits: [Character]) -> Bool {
        for i in 1..<digits.count {
            guard
                let prev = digits[i - 1].wholeNumberValue,
                let curr = digits[i].wholeNumberValue
            else { return false }
            if curr != prev + 1 { return false }
        }
        return true
    }
    
    private func isDescending(digits: [Character]) -> Bool {
        for i in 1..<digits.count {
            guard
                let prev = digits[i - 1].wholeNumberValue,
                let curr = digits[i].wholeNumberValue
            else { return false }
            if curr != prev - 1 { return false }
        }
        return true
    }
}

extension DateFormatter {
    static let beautyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        return formatter
    }()
}
