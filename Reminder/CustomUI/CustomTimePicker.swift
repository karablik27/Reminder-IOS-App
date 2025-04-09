import SwiftUI

// MARK: - CustomTimePickerView
struct CustomTimePickerView: View {

    // MARK: - Constants
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

    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTime: Date

    // MARK: - Body
    var body: some View {
        VStack(spacing: Constants.zero) {

            // MARK: - Title Section
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

            // MARK: - Time Picker
            DatePicker(
                "",
                selection: $selectedTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .padding()

            Divider()

            // MARK: - Done Button
            Button {
                dismiss()
            } label: {
                Text("Done".localized)
                    .font(.headline)
                    .frame(maxWidth: .infinity,
                           minHeight: Constants.doneButtonMinHeight)
                    .foregroundColor(.black)
            }
            .buttonStyle(.borderedProminent)
            .tint(Colors.mainGreen)
            .padding()
            .cornerRadius(Constants.doneButtonCornerRadius)
        }

        // MARK: - Sheet Presentation
        .presentationDetents([.height(Constants.presentationHeight), .medium])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(Constants.presentationCornerRadius)
    }
}
