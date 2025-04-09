import SwiftUI

// MARK: - SortSectionView
struct SortSectionView: View {

    // MARK: - Properties
    let selectedType: String
    let selectedSortOption: String
    let isTypeExpanded: Bool
    let isSortExpanded: Bool

    let toggleSortAction: () -> Void
    let typeMenuAction: () -> Void
    let sortMenuAction: () -> Void
    let deleteAction: () -> Void
    let searchAction: () -> Void

    // MARK: - Body
    var body: some View {
        HStack(spacing: ConstantsMain.sortSection.spacing) {

            // MARK: Toggle Sort Button
            Button(action: toggleSortAction) {
                Image(systemName: "arrow.up.arrow.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: ConstantsMain.sortSection.iconSize,
                           height: ConstantsMain.sortSection.iconSize)
                    .foregroundColor(.primary)
            }

            // MARK: Type Filter Button
            Button(action: typeMenuAction) {
                HStack {
                    Text(selectedType.localized)
                        .foregroundColor(.primary)
                    Image(systemName: isTypeExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, ConstantsMain.sortSection.paddingHorizontal)
                .padding(.vertical, ConstantsMain.sortSection.paddingVertical)
                .background(Color(.systemGray6))
                .cornerRadius(ConstantsMain.sortSection.cornerRadius)
            }

            // MARK: Sort Option Button
            Button(action: sortMenuAction) {
                HStack {
                    Text(selectedSortOption.localized)
                        .foregroundColor(.primary)
                    Image(systemName: isSortExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, ConstantsMain.sortSection.paddingHorizontal)
                .padding(.vertical, ConstantsMain.sortSection.paddingVertical)
                .background(Color(.systemGray6))
                .cornerRadius(ConstantsMain.sortSection.cornerRadius)
            }

            Spacer()

            // MARK: Search Button
            Button(action: searchAction) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: ConstantsMain.sortSection.iconSize,
                           height: ConstantsMain.sortSection.iconSize)
                    .foregroundColor(.primary)
            }
        }
    }
}
