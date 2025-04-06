import SwiftUI

struct CustomTimePickerView: View {
    // MARK: - Константы
    private enum Constants {
        static let zero: CGFloat = 0
        
        static let titleTopPadding: CGFloat = 40
        static let titleLeadingPadding: CGFloat = 16
        static let containerTopPadding: CGFloat = 8
        
        static let doneButtonMinHeight: CGFloat = 40
        static let doneButtonCornerRadius: CGFloat = 16
        
        static let presentationHeight: CGFloat = 360
        static let presentationCornerRadius: CGFloat = 24
    }
    
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTime: Date
    
    var body: some View {
        VStack(spacing: Constants.zero) {
            
            // Заголовок
            VStack(alignment: .leading, spacing: Constants.zero) {
                Text("Time".localized)
                    .padding(.top, Constants.titleTopPadding)
                    .padding(.leading, Constants.titleLeadingPadding)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                Divider()
            }
            .padding(.top, Constants.containerTopPadding)
            
            // Сам DatePicker
            DatePicker(
                "",
                selection: $selectedTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .padding()
            
            Divider()
            
            // Кнопка Done
            Button {
                dismiss()
            } label: {
                Text("Done".localized)
                    .font(.headline)
                    .frame(maxWidth: .infinity,
                           minHeight: Constants.doneButtonMinHeight)
            }
            .buttonStyle(.borderedProminent)
            .tint(Colors.mainGreen)
            .padding()
            .cornerRadius(Constants.doneButtonCornerRadius)
        }
        // Настройки sheet
        .presentationDetents([.height(Constants.presentationHeight), .medium])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(Constants.presentationCornerRadius)
    }
}
