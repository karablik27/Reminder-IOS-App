import SwiftUI

// MARK: - Constants
private enum Constants {
    static let rowHeight: CGFloat = 40
    static let fontSize: CGFloat = 20
    static let localeIdentifier = Localizer.selectedLanguage
    static let monthDateFormat = "LLLL"
    static let referenceYear = 2000
    static let minLineHeight: CGFloat = 1
    static let minimumPickerSubviewCount: Int = 3
}

// MARK: - OnePickerMonthYearView
struct OnePickerMonthYearView: UIViewRepresentable {
    // MARK: - Bindings
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    
    // MARK: - Data Sources
    let months = Array(1...12)
    let years  = Array(1900...2100)
    
    // MARK: - Make Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - UIViewRepresentable Methods
    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate   = context.coordinator
        picker.backgroundColor = .clear
        
        context.coordinator.removeLines(from: picker)
        
        if let monthIndex = months.firstIndex(of: selectedMonth) {
            picker.selectRow(monthIndex, inComponent: 0, animated: false)
        }
        if let yearIndex = years.firstIndex(of: selectedYear) {
            picker.selectRow(yearIndex, inComponent: 1, animated: false)
        }
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: Context) {
        context.coordinator.removeLines(from: uiView)
        
        if let monthIndex = months.firstIndex(of: selectedMonth) {
            uiView.selectRow(monthIndex, inComponent: 0, animated: false)
        }
        if let yearIndex = years.firstIndex(of: selectedYear) {
            uiView.selectRow(yearIndex, inComponent: 1, animated: false)
        }
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        let parent: OnePickerMonthYearView
        
        init(_ parent: OnePickerMonthYearView) {
            self.parent = parent
        }
        
        // MARK: - UIPickerViewDataSource
        func numberOfComponents(in pickerView: UIPickerView) -> Int { 2 }
        
        func pickerView(_ pickerView: UIPickerView,
                        numberOfRowsInComponent component: Int) -> Int {
            return component == 0 ? parent.months.count : parent.years.count
        }
        
        // MARK: - UIPickerViewDelegate
        func pickerView(_ pickerView: UIPickerView,
                        rowHeightForComponent component: Int) -> CGFloat {
            return Constants.rowHeight
        }
        
        func pickerView(_ pickerView: UIPickerView,
                        viewForRow row: Int,
                        forComponent component: Int,
                        reusing view: UIView?) -> UIView {
            let label = (view as? UILabel) ?? UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .regular)
            
            if component == 0 {
                label.text = formattedMonth(parent.months[row])
            } else {
                label.text = "\(parent.years[row])"
            }
            return label
        }
        
        private func formattedMonth(_ month: Int) -> String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: Constants.localeIdentifier)
            formatter.dateFormat = Constants.monthDateFormat
            var comps = DateComponents()
            comps.day = 1
            comps.month = month
            comps.year = Constants.referenceYear
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
        
        // MARK: - Remove Picker Lines
        func removeLines(from pickerView: UIPickerView) {
            if pickerView.subviews.count > Constants.minimumPickerSubviewCount {
                pickerView.subviews[1].removeFromSuperview()
                pickerView.subviews[2].removeFromSuperview()
            }
            for subview in pickerView.subviews {
                if subview.frame.size.height < Constants.minLineHeight {
                    subview.removeFromSuperview()
                }
            }
        }
    }
}
