import SwiftUI

// MARK: - Константы для TopHeaderView (верхней панели)

private enum TopHeaderConstants {
    static let fontSizeImage: CGFloat = 18
    static let fontSizeTitle: CGFloat = 24
    static let paddingHorizontal: CGFloat = 16
    static let paddingVertical: CGFloat = 8
}

// MARK: - Subview: TopHeaderView

struct TopHeaderView: View {
    let title: String
    let onBack: () -> Void
    
    var body: some View {
        HStack {
            Button {
                onBack()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: TopHeaderConstants.fontSizeImage, weight: .bold))
                    .foregroundColor(.black)
            }
            Text(title)
                .font(.system(size: TopHeaderConstants.fontSizeTitle, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .navigationBarBackButtonHidden(true)
        .padding(.horizontal, TopHeaderConstants.paddingHorizontal)
        .padding(.vertical, TopHeaderConstants.paddingVertical)
        .background(Colors.mainGreen)
    }
    
}
