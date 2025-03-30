import SwiftUI

struct CustomCalendarView: View {
    
    private enum Constants {
        static let vStackSpacing: CGFloat = 0
        
        static let headerHorizontalPadding: CGFloat = 16
        static let headerTopPadding: CGFloat = 20
        
        static let dividerTopPadding: CGFloat = 8
        static let dividerBottomPadding: CGFloat = 8
        
        static let pickerWidth: CGFloat = 120
        static let pickerHeight: CGFloat = 104
        static let pickerVerticalPadding: CGFloat = 16
        
        static let daysInWeek = 7
        static let gridSpacing: CGFloat = 12
        
        static let dayCellSize: CGFloat = 32
        
        // Фиксированная высота для календарной сетки (6 строк)
        // (6 * dayCellSize) + (5 * gridSpacing) = (6 * 32) + (5 * 12) = 192 + 60 = 252
        static let calendarGridHeight: CGFloat = 252
    }
    
    @Binding var selectedDate: Date
    
    @State private var selectedMonth: Int
    @State private var selectedYear: Int
    
    private let months = Array(1...12)
    private let years = Array(1900...2100)
    
    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        let calendar = Calendar.current
        _selectedMonth = State(initialValue: calendar.component(.month, from: selectedDate.wrappedValue))
        _selectedYear  = State(initialValue: calendar.component(.year, from: selectedDate.wrappedValue))
    }
    
    var body: some View {
        VStack(spacing: Constants.vStackSpacing) {
            // Заголовок "Date" слева
            HStack {
                Text("Date")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, Constants.headerHorizontalPadding)
            .padding(.top, Constants.headerTopPadding)
            
            Divider()
                .padding(.top, Constants.dividerTopPadding)
                .padding(.bottom, Constants.dividerBottomPadding)
            
            // Пикеры для месяца и года
            HStack {
                Picker("Month", selection: $selectedMonth) {
                    ForEach(months, id: \.self) { month in
                        Text(monthName(month)).tag(month)
                    }
                }
                .frame(width: Constants.pickerWidth, height: Constants.pickerHeight)
                .clipped()
                .pickerStyle(.wheel)
                
                Picker("Year", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
                .frame(width: Constants.pickerWidth, height: Constants.pickerHeight)
                .clipped()
                .pickerStyle(.wheel)
            }
            .padding(.vertical, Constants.pickerVerticalPadding)
            
            // Заголовок дней недели
            dayOfWeekHeader
            
            // Сетка дней с фиксированной высотой
            let allCells = generateCalendarCells(month: selectedMonth, year: selectedYear)
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: Constants.daysInWeek),
                spacing: Constants.gridSpacing
            ) {
                ForEach(allCells.indices, id: \.self) { index in
                    let cellDate = allCells[index]
                    if let date = cellDate {
                        dayCell(date: date)
                    } else {
                        emptyCell()
                    }
                }
            }
            .padding(.horizontal)
            .frame(height: Constants.calendarGridHeight) // Фиксированная высота
            
            Spacer()
        }
        .onChange(of: selectedMonth) { _ in updateSelectedDateIfNeeded() }
        .onChange(of: selectedYear) { _ in updateSelectedDateIfNeeded() }
    }
}

// MARK: - Логика и вспомогательные методы
extension CustomCalendarView {
    
    private func dayCell(date: Date) -> some View {
        let calendar = Calendar.current
        let dayNumber = calendar.component(.day, from: date)
        let isBeautiful = date.isBeautifulDate()
        let isSelected  = calendar.isDate(date, inSameDayAs: selectedDate)
        
        return Text("\(dayNumber)")
            .font(.body)
            .foregroundColor(isBeautiful ? .green : .primary)
            .frame(width: Constants.dayCellSize, height: Constants.dayCellSize)
            .background(
                Circle()
                    .fill(isSelected ? Color.green.opacity(0.2) : Color.clear)
            )
            .overlay(
                Circle()
                    .stroke(isSelected ? Colors.mainGreen : Color.clear, lineWidth: 2)
            )
            .onTapGesture {
                selectedDate = date
            }
    }
    
    private func emptyCell() -> some View {
        Text("")
            .frame(width: Constants.dayCellSize, height: Constants.dayCellSize)
    }
    
    /// Генерирует массив дат (Date?) для календаря с пустыми ячейками в начале, если нужно.
    private func generateCalendarCells(month: Int, year: Int) -> [Date?] {
        guard let startOfMonth = dateFrom(day: 1, month: month, year: year) else {
            return []
        }
        
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            return []
        }
        let numberOfDays = range.count
        
        // Определяем день недели 1-го числа (в системе: 1 = Sunday, 2 = Monday, ...)
        let weekdayOfStart = calendar.component(.weekday, from: startOfMonth)
        // Преобразуем к понедельник-основанному индексу: Monday = 1, ..., Sunday = 7
        let weekdayIndex = convertToMondayBasedIndex(weekdayOfStart)
        
        // Добавляем пустые ячейки
        var cells: [Date?] = Array(repeating: nil, count: weekdayIndex - 1)
        
        // Добавляем реальные даты месяца
        for day in 1...numberOfDays {
            if let realDate = dateFrom(day: day, month: month, year: year) {
                cells.append(realDate)
            }
        }
        return cells
    }
    
    /// Преобразует system weekday (1=Sunday, 2=Monday, ...) в Monday=1, ..., Sunday=7.
    private func convertToMondayBasedIndex(_ systemWeekday: Int) -> Int {
        return (systemWeekday + 5) % 7 + 1
    }
    
    private var dayOfWeekHeader: some View {
        HStack {
            ForEach(["Mon","Tue","Wed","Thu","Fri","Sat","Sun"], id: \.self) { weekday in
                Text(weekday)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 4)
    }
    
    private func monthName(_ month: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "LLLL"
        
        var comps = DateComponents()
        comps.day = 1
        comps.month = month
        comps.year = 2000
        let date = Calendar.current.date(from: comps) ?? Date()
        return formatter.string(from: date)
    }
    
    private func dateFrom(day: Int, month: Int, year: Int) -> Date? {
        var comps = DateComponents()
        comps.day = day
        comps.month = month
        comps.year = year
        return Calendar.current.date(from: comps)
    }
    
    private func updateSelectedDateIfNeeded() {
        let calendar = Calendar.current
        let currentDay = calendar.component(.day, from: selectedDate)
        
        if let newStartOfMonth = dateFrom(day: 1, month: selectedMonth, year: selectedYear),
           let range = calendar.range(of: .day, in: .month, for: newStartOfMonth) {
            let maxDay = range.count
            let dayToUse = min(currentDay, maxDay)
            if let correctedDate = dateFrom(day: dayToUse, month: selectedMonth, year: selectedYear) {
                selectedDate = correctedDate
            }
        }
    }
}
