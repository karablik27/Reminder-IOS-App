import Foundation

extension Date {
    /// Проверка даты по стандартным (встроенным) критериям «красоты».
    func isBeautifulDate() -> Bool {
        let dateString = DateFormatter.beautyFormatter.string(from: self) // формат "ddMMyyyy"
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
        
        // 6) День равен последним двум цифрам года
        if day == lastTwoDigitsOfYear {
            return true
        }
        
        // 7) Месяц равен последним двум цифрам года
        if month == lastTwoDigitsOfYear {
            return true
        }
        
        // 8) День + месяц равны последним двум цифрам года
        if (day + month) == lastTwoDigitsOfYear {
            return true
        }
        
        // 9) Возрастающая последовательность цифр: "01234567"
        if isAscending(digits: digits) {
            return true
        }
        
        // 10) Убывающая последовательность цифр: "76543210"
        if isDescending(digits: digits) {
            return true
        }
        
        // 11) День, месяц и последние две цифры года равны (например, 12.12.2012)
        if (day == month) && (month == lastTwoDigitsOfYear) {
            return true
        }
        
        return false
    }
    
    /// Возвращает объяснение, почему дата считается красивой, согласно стандартным критериям.
    /// Если ни одно условие не выполнено, возвращает nil.
    func beautifulReasons() -> String? {
        let dateString = DateFormatter.beautyFormatter.string(from: self)
        let digits = Array(dateString)
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        let lastTwoDigits = year % 100
        
        if dateString == String(dateString.reversed()) {
            return "Palindrome"
        }
        if dateString.allSatisfy({ $0 == dateString.first }) {
            return "All digits are identical"
        }
        if isRepeatedPairs(in: dateString) {
            return "Repeating pairs"
        }
        if day == 29 && month == 2 {
            return "29 February"
        }
        if day == month {
            return "Day equals Month"
        }
        if day == lastTwoDigits {
            return "Day equals last two digits"
        }
        if month == lastTwoDigits {
            return "Month equals last two digits"
        }
        if (day + month) == lastTwoDigits {
            return "Day + Month equals last two digits"
        }
        if isAscending(digits: digits) {
            return "Ascending sequence"
        }
        if isDescending(digits: digits) {
            return "Descending sequence"
        }
        if day == month && month == lastTwoDigits {
            return "Perfect match"
        }
        return nil
    }
    
    /// Если дата считается красивой по стандартным критериям, возвращает соответствующее объяснение.
    /// Для пользовательски добавленных дат (custom) – всегда возвращает "Beautiful Date".
    /// Если дата не красивая, возвращает пустую строку.
    func beautifulReason(isUserDefined: Bool = false) -> String {
        if isUserDefined {
            return "Custom Date"
        } else if self.isBeautifulDate(), let reason = self.beautifulReasons() {
            return reason
        } else {
            return ""
        }
    }
    
    // MARK: - Вспомогательные методы
    
    private func isRepeatedPairs(in s: String) -> Bool {
        guard s.count == 8 else { return false }
        let pair = s.prefix(2)
        for i in stride(from: 0, to: 8, by: 2) {
            let start = s.index(s.startIndex, offsetBy: i)
            let end = s.index(start, offsetBy: 2)
            if s[start..<end] != pair {
                return false
            }
        }
        return true
    }
    
    private func isAscending(digits: [Character]) -> Bool {
        for i in 1..<digits.count {
            guard let prev = digits[i-1].wholeNumberValue,
                  let current = digits[i].wholeNumberValue else { return false }
            if current != prev + 1 { return false }
        }
        return true
    }
    
    private func isDescending(digits: [Character]) -> Bool {
        for i in 1..<digits.count {
            guard let prev = digits[i-1].wholeNumberValue,
                  let current = digits[i].wholeNumberValue else { return false }
            if current != prev - 1 { return false }
        }
        return true
    }
}
