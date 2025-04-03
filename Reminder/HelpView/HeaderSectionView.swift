import SwiftUI

struct HeaderSectionView: View {
    let title: String
    var settingsAction: () -> Void = { }

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: ConstantsMain.Text.titleSize, weight: .bold))
            Spacer()
            Button(action: settingsAction) {
                Image(systemName: "gearshape")
                    .resizable()
                    .scaledToFit()
                    .frame(width: ConstantsMain.headerSection.iconSize,
                           height: ConstantsMain.headerSection.iconSize)
                    .foregroundColor(.primary)
            }
        }
    }
}

