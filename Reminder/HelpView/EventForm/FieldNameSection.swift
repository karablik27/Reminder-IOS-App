import SwiftUI

struct FieldNameSection: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: CommonConstants.spacing) {
            Text(label.localized)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            TextField(placeholder.localized, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal, CommonConstants.horizontalPadding)
    }
}
