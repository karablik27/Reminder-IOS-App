import Foundation

extension Date {
    /// Проверка даты по стандартным (встроенным) критериям «красоты».
    /// Формат даты для проверки — "ddMMyyyy".
    func isBeautifulDate() -> Bool {
        let dateString = DateFormatter.beautyFormatter.string(from: self) // формат "ddMMyyyy"
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        let lastTwoDigits = year % 100
        
        // MARK: - 1) Палиндром: "02022020"
        if dateString == String(dateString.reversed()) {
            return true
        }
        
        // MARK: - 2) Все цифры одинаковые: "11111111"
        if dateString.allSatisfy({ $0 == dateString.first }) {
            return true
        }
        
        // MARK: - 3) Повторяющиеся пары цифр: "12121212"
        if isRepeatedPairs(in: dateString) {
            return true
        }
        
        // MARK: - 4) 29 февраля
        if day == 29 && month == 2 {
            return true
        }
        
        // MARK: - 5) День равен месяцу
        if day == month {
            return true
        }
        
        // MARK: - 6) День равен последним двум цифрам года
        if day == lastTwoDigits {
            return true
        }
        
        // MARK: - 7) Месяц равен последним двум цифрам года
        if month == lastTwoDigits {
            return true
        }
        
        // MARK: - 8) Сумма дня и месяца равна последним двум цифрам года
        if (day + month) == lastTwoDigits {
            return true
        }
        
        // MARK: - 9) День, месяц и последние две цифры года равны между собой
        if (day == month) && (month == lastTwoDigits) {
            return true
        }
        
        // MARK: - 10) Симметрия дня и месяца
        // Проверяем, является ли строка, состоящая из дня и месяца (в формате ddMM), палиндромом.
        let dayString = String(format: "%02d", day)
        let monthString = String(format: "%02d", month)
        let dm = dayString + monthString
        if dm == String(dm.reversed()) {
            return true
        }
        
        // MARK: - 11) Арифметическая или геометрическая прогрессия цифр
        if isArithmeticProgression([day, month, lastTwoDigits]) || isGeometricProgression([day, month, lastTwoDigits]) {
            return true
        }
        
        // MARK: - 12) Математические закономерности
        // 12.1 День × Месяц = последние 2 цифры года
        if day * month == lastTwoDigits {
            return true
        }
        // 12.2 День и месяц являются квадратами целых чисел
        if isPerfectSquare(day) && isPerfectSquare(month) {
            return true
        }
        
        // MARK: - 13) Зеркальные числа между днём, месяцем и годом
        // Если день или месяц равны «зеркальному» представлению последних двух цифр года
        let lastTwoStr = String(format: "%02d", lastTwoDigits)
        if dayString == String(lastTwoStr.reversed()) || monthString == String(lastTwoStr.reversed()) {
            return true
        }
        
        return false
    }
    
    /// Возвращает объяснение, почему дата считается красивой, согласно стандартным критериям.
    /// Если ни одно условие не выполнено, возвращает nil.
    func beautifulReasons() -> String? {
        let dateString = DateFormatter.beautyFormatter.string(from: self)
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        let lastTwoDigits = year % 100
        let dayString = String(format: "%02d", day)
        let monthString = String(format: "%02d", month)
        
        if dateString == String(dateString.reversed()) {
            return "Palindrome".localized
        }
        if dateString.allSatisfy({ $0 == dateString.first }) {
            return "All digits are identical".localized
        }
        if isRepeatedPairs(in: dateString) {
            return "Repeating pairs".localized
        }
        if day == 29 && month == 2 {
            return "29 February".localized
        }
        if day == month {
            return "Day equals Month".localized
        }
        if day == lastTwoDigits {
            return "Day equals last two digits".localized
        }
        if month == lastTwoDigits {
            return "Month equals last two digits".localized
        }
        if (day + month) == lastTwoDigits {
            return "Day + Month equals last two digits".localized
        }
        if (day == month) && (month == lastTwoDigits) {
            return "Perfect match".localized
        }
        let dm = dayString + monthString
        if dm == String(dm.reversed()) {
            return "Day and Month form a palindrome".localized
        }
        if isArithmeticProgression([day, month, lastTwoDigits]) {
            return "Arithmetic progression".localized
        }
        if isGeometricProgression([day, month, lastTwoDigits]) {
            return "Geometric progression".localized
        }
        if day * month == lastTwoDigits {
            return "Product of Day and Month equals last two digits".localized
        }
        if isPerfectSquare(day) && isPerfectSquare(month) {
            return "Day and Month are perfect squares".localized
        }
        let lastTwoStr = String(format: "%02d", lastTwoDigits)
        if dayString == String(lastTwoStr.reversed()) || monthString == String(lastTwoStr.reversed()) {
            return "Mirrored structure with year".localized
        }
        return nil
    }
    
    /// Если дата считается красивой по стандартным критериям, возвращает соответствующее объяснение.
    /// Если дата не красивая, возвращает пустую строку.
    func beautifulReason(isUserDefined: Bool = false) -> String {
        if self.isBeautifulDate(), let reason = self.beautifulReasons() {
            return reason
        } else {
            return ""
        }
    }
    
    // MARK: - Вспомогательные методы
    
    /// Проверка на повторяющиеся пары цифр, например "12121212".
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
    
    /// Проверка, образуют ли цифры арифметическую прогрессию.
    private func isArithmeticProgression(_ numbers: [Int]) -> Bool {
        guard numbers.count >= 2 else { return false }
        let diff = numbers[1] - numbers[0]
        for i in 2..<numbers.count {
            if numbers[i] - numbers[i-1] != diff {
                return false
            }
        }
        return true
    }
    
    /// Проверка, образуют ли цифры геометрическую прогрессию.
    private func isGeometricProgression(_ numbers: [Int]) -> Bool {
        guard numbers.count >= 2, numbers[0] != 0 else { return false }
        // Проверяем, что отношение между соседними элементами постоянно (и целое, чтобы избежать погрешностей)
        let ratio = numbers[1] / numbers[0]
        if numbers[1] % numbers[0] != 0 { return false }
        for i in 2..<numbers.count {
            if numbers[i-1] == 0 || numbers[i] % numbers[i-1] != 0 || (numbers[i] / numbers[i-1]) != ratio {
                return false
            }
        }
        return true
    }
    
    /// Проверка, является ли число совершенным квадратом.
    private func isPerfectSquare(_ n: Int) -> Bool {
        let root = Int(sqrt(Double(n)))
        return root * root == n
    }
}
