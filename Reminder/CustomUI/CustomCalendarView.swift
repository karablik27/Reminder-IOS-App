import SwiftUI

struct CustomCalendarView: View {
    
    private enum Constants {
        static let headerHorizontalPadding: CGFloat = 16
        static let headerTopPadding: CGFloat = 20
        
        static let dividerTopPadding: CGFloat = 8
        static let dividerBottomPadding: CGFloat = 8
        
        // Размеры пикера
        static let pickerWidth: CGFloat = 280
        static let pickerHeight: CGFloat = 120  // 3 строки по 40 pt
        static let pickerVerticalPadding: CGFloat = 16
        // Новые отступы вокруг пикера:
        static let pickerTopInset: CGFloat = 10    // сверху 10 pt
        static let pickerBottomInset: CGFloat = 20   // снизу 20 pt
        
        static let daysInWeek = 7
        static let gridSpacing: CGFloat = 12
        
        static let dayCellSize: CGFloat = 32
        static let calendarGridHeight: CGFloat = 252
        
        static let bottomSpacer: CGFloat = 40
    }
    
    @Binding var selectedDate: Date
    
    @State private var localDay: Int
    @State private var localMonth: Int
    @State private var localYear: Int
    
    // Списки месяцев и лет
    private let months = Array(1...12)
    private let years  = Array(1900...2100)
    
    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        let cal = Calendar.current
        let initial = selectedDate.wrappedValue
        _localDay = State(initialValue: cal.component(.day, from: initial))
        _localMonth = State(initialValue: cal.component(.month, from: initial))
        _localYear  = State(initialValue: cal.component(.year, from: initial))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Заголовок
                HStack {
                    Text("Date".localized)
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.horizontal, Constants.headerHorizontalPadding)
                .padding(.top, Constants.headerTopPadding)
                
                Divider()
                    .padding(.top, Constants.dividerTopPadding)
                    .padding(.bottom, Constants.dividerBottomPadding)
                
                // Отступ сверху 10 pt перед пикером
                Spacer().frame(height: Constants.pickerTopInset)
                
                // Один UIPickerView с двумя компонентами (месяц и год)
                OnePickerMonthYearView(selectedMonth: $localMonth, selectedYear: $localYear)
                    .frame(width: Constants.pickerWidth, height: Constants.pickerHeight)
                    .onChange(of: localMonth) { updateDate() }
                    .onChange(of: localYear) { updateDate() }
                    .padding(.vertical, Constants.pickerVerticalPadding)
                
                // Отступ снизу 20 pt после пикера
                Spacer().frame(height: Constants.pickerBottomInset)
                
                // Заголовок дней недели
                dayOfWeekHeader
                
                // Календарная сетка
                let allCells = generateCalendarCells(month: localMonth, year: localYear)
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible()), count: Constants.daysInWeek),
                    spacing: Constants.gridSpacing
                ) {
                    ForEach(allCells.indices, id: \.self) { index in
                        if let date = allCells[index] {
                            dayCell(date: date)
                        } else {
                            emptyCell()
                        }
                    }
                }
                .padding(.horizontal)
                .frame(height: Constants.calendarGridHeight)
                
                Spacer(minLength: Constants.bottomSpacer)
            }
            .background(Color.white)
        }
        .background(Color.white)
    }
    
    // MARK: - Логика обновления даты
    
    private func updateDate() {
        let cal = Calendar.current
        let currentDay = localDay
        if let newStart = dateFrom(day: 1, month: localMonth, year: localYear),
           let range = cal.range(of: .day, in: .month, for: newStart) {
            let day = min(currentDay, range.count)
            if let newDate = dateFrom(day: day, month: localMonth, year: localYear) {
                localDay = day
                selectedDate = newDate
            }
        }
    }
    
    // MARK: - Ячейки календаря
    
    private func dayCell(date: Date) -> some View {
        let cal = Calendar.current
        let day = cal.component(.day, from: date)
        let isSelected = cal.isDate(date, inSameDayAs: selectedDate)
        let isBeautiful = date.isBeautifulDate()
        
        return Text("\(day)")
            .font(.body)
            .foregroundColor(isBeautiful ? .green : .primary)
            .frame(width: Constants.dayCellSize, height: Constants.dayCellSize)
            .background(
                Circle().fill(isSelected ? Color.green.opacity(0.2) : Color.clear)
            )
            .overlay(
                Circle().stroke(isSelected ? Colors.mainGreen : Color.clear, lineWidth: 2)
            )
            .onTapGesture {
                localDay = day
                updateDate()
            }
    }
    
    private func emptyCell() -> some View {
        Text("")
            .frame(width: Constants.dayCellSize, height: Constants.dayCellSize)
    }
    
    private func generateCalendarCells(month: Int, year: Int) -> [Date?] {
        guard let start = dateFrom(day: 1, month: month, year: year) else { return [] }
        let cal = Calendar.current
        guard let range = cal.range(of: .day, in: .month, for: start) else { return [] }
        let days = range.count
        
        let weekday = cal.component(.weekday, from: start)
        let index = convertToMondayBasedIndex(weekday)
        
        var cells = Array(repeating: nil as Date?, count: index - 1)
        for d in 1...days {
            if let dt = dateFrom(day: d, month: month, year: year) {
                cells.append(dt)
            }
        }
        return cells
    }
    
    private func convertToMondayBasedIndex(_ systemWeekday: Int) -> Int {
        return (systemWeekday + 5) % 7 + 1
    }
    
    private var dayOfWeekHeader: some View {
        HStack {
            ForEach(["Mon".localized, "Tue".localized, "Wed".localized,
                     "Thu".localized, "Fri".localized, "Sat".localized, "Sun".localized],
                    id: \.self) { wd in
                Text(wd)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 4)
    }
    
    private func dateFrom(day: Int, month: Int, year: Int) -> Date? {
        var comps = DateComponents()
        comps.day = day; comps.month = month; comps.year = year
        return Calendar.current.date(from: comps)
    }
}

// MARK: - UIPickerView с двумя компонентами (месяц и год)

struct OnePickerMonthYearView: UIViewRepresentable {
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    
    let months = Array(1...12)
    let years  = Array(1900...2100)
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate   = context.coordinator
        picker.backgroundColor = .clear
        
        context.coordinator.removeLines(picker)
        
        if let monthIndex = months.firstIndex(of: selectedMonth) {
            picker.selectRow(monthIndex, inComponent: 0, animated: false)
        }
        if let yearIndex = years.firstIndex(of: selectedYear) {
            picker.selectRow(yearIndex, inComponent: 1, animated: false)
        }
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: Context) {
        context.coordinator.removeLines(uiView)
        
        if let monthIndex = months.firstIndex(of: selectedMonth) {
            uiView.selectRow(monthIndex, inComponent: 0, animated: false)
        }
        if let yearIndex = years.firstIndex(of: selectedYear) {
            uiView.selectRow(yearIndex, inComponent: 1, animated: false)
        }
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        let parent: OnePickerMonthYearView
        
        init(_ parent: OnePickerMonthYearView) {
            self.parent = parent
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int { 2 }
        
        func pickerView(_ pickerView: UIPickerView,
                        numberOfRowsInComponent component: Int) -> Int {
            return component == 0 ? parent.months.count : parent.years.count
        }
        
        // Устанавливаем высоту строки = 40
        func pickerView(_ pickerView: UIPickerView,
                        rowHeightForComponent component: Int) -> CGFloat {
            return 40
        }
        
        // Настройка шрифта – увеличенный до 20 pt
        func pickerView(_ pickerView: UIPickerView,
                        viewForRow row: Int,
                        forComponent component: Int,
                        reusing view: UIView?) -> UIView {
            let label = (view as? UILabel) ?? UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            
            if component == 0 {
                label.text = formattedMonth(parent.months[row])
            } else {
                label.text = "\(parent.years[row])"
            }
            return label
        }
        
        private func formattedMonth(_ month: Int) -> String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: Localizer.selectedLanguage)
            formatter.dateFormat = "LLLL"
            var comps = DateComponents()
            comps.day = 1; comps.month = month; comps.year = 2000
            let dt = Calendar.current.date(from: comps) ?? Date()
            return formatter.string(from: dt)
        }
        
        func pickerView(_ pickerView: UIPickerView,
                        didSelectRow row: Int,
                        inComponent component: Int) {
            if component == 0 {
                parent.selectedMonth = parent.months[row]
            } else {
                parent.selectedYear = parent.years[row]
            }
        }
        
        func removeLines(_ pickerView: UIPickerView) {
            if pickerView.subviews.count > 2 {
                pickerView.subviews[1].removeFromSuperview()
                pickerView.subviews[2].removeFromSuperview()
            }
            for subview in pickerView.subviews {
                if subview.frame.size.height < 1 {
                    subview.removeFromSuperview()
                }
            }
        }
    }
}
