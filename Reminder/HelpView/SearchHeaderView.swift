import SwiftUI

struct SearchHeaderView: View {
    let title: String
    @Binding var searchText: String
    let placeholder: String
    let leftButtonAction: () -> Void
    let rightButtonAction: () -> Void

    var body: some View {
        VStack(spacing: SearchConstants.VStackSpacing) {
            Text(title)
                .font(.system(size: ConstantsMain.Text.titleSize, weight: .bold))
                .foregroundColor(.primary)
            HStack(spacing: SearchConstants.HStackSpacing) {
                Button(action: leftButtonAction) {
                    Image(systemName: "list.bullet")
                        .resizable()
                        .scaledToFit()
                        .frame(width: SearchConstants.iconSize, height: SearchConstants.iconSize)
                        .foregroundColor(.black)
                }
                TextField("", text: $searchText)
                    .foregroundColor(.black)
                    .disableAutocorrection(true)
                    .placeholder(when: searchText.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(.black)
                    }
                Button(action: rightButtonAction) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: SearchConstants.iconSize, height: SearchConstants.iconSize)
                        .foregroundColor(.black)
                }
            }
            .padding(.vertical, SearchConstants.paddingVertical)
            .padding(.horizontal)
            .background(Colors.GreenTabBar)
            .cornerRadius(SearchConstants.cornerRadius)
            .padding(.horizontal)
        }
    }
}
