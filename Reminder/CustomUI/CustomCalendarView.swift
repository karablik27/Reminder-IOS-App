import SwiftUI
import SwiftData

// MARK: - CustomCalendarView
struct CustomCalendarView: View {

    // MARK: Constants
    private enum Constants {
        static let zeroSpacing: CGFloat = 0
        static let explanationPadding: CGFloat = 12
        static let explanationCornerRadius: CGFloat = 12
        static let dayOfWeekBottomPadding: CGFloat = 4
        static let headerHorizontalPadding: CGFloat = 16
        static let headerTopPadding: CGFloat = 20
        static let dividerTopPadding: CGFloat = 8
        static let dividerBottomPadding: CGFloat = 8
        static let pickerWidth: CGFloat = 280
        static let pickerHeight: CGFloat = 120
        static let pickerVerticalPadding: CGFloat = 16
        static let pickerTopInset: CGFloat = 10
        static let pickerBottomInset: CGFloat = 20
        static let daysInWeek = 7
        static let gridSpacing: CGFloat = 12
        static let dayCellSize: CGFloat = 32
        static let calendarGridHeight: CGFloat = 252
        static let bottomSpacer: CGFloat = 40
        static let explanationTopPadding: CGFloat = 8
        static let circleStrokeWidth: CGFloat = 2
        static let greenOpacity: Double = 0.2
    }

    // MARK: - Properties
    var showHeader: Bool = true
    @Binding var selectedDate: Date
    @State private var localDay: Int
    @State private var localMonth: Int
    @State private var localYear: Int

    // MARK: - Init
    init(selectedDate: Binding<Date>, showHeader: Bool = true) {
        self._selectedDate = selectedDate
        self.showHeader = showHeader
        let cal = Calendar.current
        let initial = selectedDate.wrappedValue
        _localDay = State(initialValue: cal.component(.day, from: initial))
        _localMonth = State(initialValue: cal.component(.month, from: initial))
        _localYear  = State(initialValue: cal.component(.year, from: initial))
    }

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: Constants.zeroSpacing) {
                if showHeader {
                    HStack {
                        Text("Date".localized)
                            .font(.headline)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.horizontal, Constants.headerHorizontalPadding)
                    .padding(.top, Constants.headerTopPadding)
                }

                Divider()
                    .padding(.top, Constants.dividerTopPadding)
                    .padding(.bottom, Constants.dividerBottomPadding)

                Spacer().frame(height: Constants.pickerTopInset)

                OnePickerMonthYearView(selectedMonth: $localMonth, selectedYear: $localYear)
                    .frame(width: Constants.pickerWidth, height: Constants.pickerHeight)
                    .padding(.vertical, Constants.pickerVerticalPadding)
                    .onChange(of: localMonth) { updateDate() }
                    .onChange(of: localYear) { updateDate() }

                Spacer().frame(height: Constants.pickerBottomInset)

                dayOfWeekHeader

                let allCells = generateCalendarCells(month: localMonth, year: localYear)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: Constants.daysInWeek), spacing: Constants.gridSpacing) {
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

                let explanation = selectedDate.beautifulReason(isUserDefined: false)
                if !explanation.isEmpty {
                    Text("Beautiful date: ".localized + "\(explanation)".localized)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(Constants.explanationPadding)
                        .background(
                            RoundedRectangle(cornerRadius: Constants.explanationCornerRadius)
                                .fill(Colors.GreenTabBar)
                        )
                        .padding(.top, Constants.explanationTopPadding)
                        .padding(.horizontal, Constants.headerHorizontalPadding)
                }
            }
            .background(Color.white)
        }
        .background(Color.white)
    }

    // MARK: - Helpers
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
                Circle().fill(isSelected ? Color.green.opacity(Constants.greenOpacity) : Color.clear)
            )
            .overlay(
                Circle().stroke(isSelected ? Colors.mainGreen : Color.clear, lineWidth: Constants.circleStrokeWidth)
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
                     "Thu".localized, "Fri".localized, "Sat".localized, "Sun".localized], id: \.self) { wd in
                Text(wd)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, Constants.dayOfWeekBottomPadding)
    }

    private func dateFrom(day: Int, month: Int, year: Int) -> Date? {
        var comps = DateComponents()
        comps.day = day
        comps.month = month
        comps.year = year
        return Calendar.current.date(from: comps)
    }
}
