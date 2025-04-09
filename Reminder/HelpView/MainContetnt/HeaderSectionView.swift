import SwiftUI

// MARK: - HeaderSectionView
struct HeaderSectionView: View {
    
    // MARK: - Properties
    let title: String
    var settingsAction: () -> Void = { }

    // MARK: - Body
    var body: some View {
        HStack {
            // MARK: - Title
            Text(title)
                .font(.system(size: ConstantsMain.Text.titleSize, weight: .bold))
            
            Spacer()
            
            // MARK: - Settings Button
            Button(action: settingsAction) {
                Image(systemName: "gearshape")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: ConstantsMain.headerSection.iconSize,
                        height: ConstantsMain.headerSection.iconSize
                    )
                    .foregroundColor(.primary)
            }
        }
    }
}
