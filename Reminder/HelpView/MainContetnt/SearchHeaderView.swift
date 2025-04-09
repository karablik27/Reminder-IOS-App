import SwiftUI

private enum Constants {
    static let imageSize: CGFloat = 16
}
struct SearchHeaderView: View {
    let title: String
    @Binding var searchText: String
    let placeholder: String
    let dismissAction: () -> Void

    var body: some View {
        VStack(spacing: SearchConstants.VStackSpacing) {
            ZStack {
                Text(title)
                    .font(.system(size: ConstantsMain.Text.titleSize, weight: .bold))
                    .foregroundColor(.primary)
                HStack {
                    Spacer()
                    Button(action: dismissAction) {
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: Constants.imageSize, height: Constants.imageSize)
                            .foregroundColor(.black)
                            .padding(.trailing)
                    }
                }
            }
            HStack(spacing: SearchConstants.HStackSpacing) {
                TextField("", text: $searchText)
                    .foregroundColor(.black)
                    .disableAutocorrection(true)
                    .placeholder(when: searchText.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(.black)
                    }
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: SearchConstants.iconSize, height: SearchConstants.iconSize)
                    .foregroundColor(.black)
            }
            .padding(.vertical, SearchConstants.paddingVertical)
            .padding(.horizontal)
            .background(Colors.GreenTabBar)
            .cornerRadius(SearchConstants.cornerRadius)
            .padding(.horizontal)
        }
    }
}

