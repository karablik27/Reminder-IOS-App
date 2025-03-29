import SwiftUI

struct CustomCalendarView: View {
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
        VStack(spacing: 0) {
            // Шапка "Date" слева
            HStack {
                Text("Date")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            
            Divider()
                .padding(.top, 8)
                .padding(.bottom, 8)
            
            HStack {
                Picker("Month", selection: $selectedMonth) {
                    ForEach(months, id: \.self) { month in
                        Text(monthName(month)).tag(month)
                    }
                }
                .frame(width: 120, height: 100)
                .clipped()
                .pickerStyle(.wheel)
                
                Picker("Year", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
                .frame(width: 120, height: 100)
                .clipped()
                .pickerStyle(.wheel)
            }
            .padding(.vertical, 8)
            
            dayOfWeekHeader
            
            let daysInMonth = generateDaysInMonth(month: selectedMonth, year: selectedYear)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(daysInMonth, id: \.self) { date in
                    dayCell(date: date)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .onChange(of: selectedMonth) { _ in updateSelectedDateIfNeeded() }
        .onChange(of: selectedYear) { _ in updateSelectedDateIfNeeded() }
    }
}

// MARK: - Логика
extension CustomCalendarView {
    /// Ячейка дня
    private func dayCell(date: Date) -> some View {
        let calendar = Calendar.current
        let dayNumber = calendar.component(.day, from: date)
        
        let isBeautiful = date.isBeautifulDate()
        
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        
        return Text("\(dayNumber)")
            .font(.body)
            .foregroundColor(isBeautiful ? .green : .primary)
            .frame(width: 32, height: 32)
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
    
    private func generateDaysInMonth(month: Int, year: Int) -> [Date] {
        var result: [Date] = []
        guard let startOfMonth = dateFrom(day: 1, month: month, year: year) else {
            return result
        }
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: startOfMonth) ?? 1..<31
        let numberOfDays = range.count
        
        for day in 1...numberOfDays {
            if let date = dateFrom(day: day, month: month, year: year) {
                result.append(date)
            }
        }
        return result
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
