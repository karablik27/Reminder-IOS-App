import SwiftUI

struct LabeledNavigationLinkSection<Destination: View>: View {
    let label: String
    let text: String
    let icon: String
    let destination: () -> Destination

    var body: some View {
        VStack(alignment: .leading, spacing: CommonConstants.spacing / 2) {
            Text(label.localized)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            NavigationLink(destination: destination()) {
                HStack {
                    Text(text)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: icon)
                        .foregroundColor(.black)
                }
                .padding(CommonConstants.buttonPadding)
                .overlay(
                    RoundedRectangle(cornerRadius: CommonConstants.cornerRadius)
                        .stroke(Color.gray.opacity(CommonConstants.borderColorOpacity),
                                lineWidth: CommonConstants.borderLineWidth)
                )
            }
        }
        .padding(.horizontal, CommonConstants.horizontalPadding)
    }
}
