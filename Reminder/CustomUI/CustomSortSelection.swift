import SwiftUI

// MARK: - Constants
private enum Constants {
    // SortOptionRow constants
    static let hStackSpacing: CGFloat = 12
    static let imageSize: CGFloat = 24
    static let vStackSpacing: CGFloat = 4

    // List row insets for both rows
    static let listRowInsets = EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
    
    // SortSelectionMenu presentation constants
    static let presentationHeight: CGFloat = 200
    static let presentationCornerRadius: CGFloat = 25
}

/// MARK: - SortOptionRow
struct SortOptionRow: View {
    let option: SortOption
    let isSelected: Bool
    let action: () -> Void
    
    // MARK: - Computed Properties
    var description: String {
        switch option {
        case .byDate:
            return "You will see events sorted by date.".localized
        case .byName:
            return "You will see events sorted by name.".localized
        }
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: Constants.hStackSpacing) {
                Image(systemName: isSelected ? "star.fill" : "star")
                    .foregroundColor(isSelected ? .black : .gray)
                    .frame(width: Constants.imageSize, height: Constants.imageSize)
                
                VStack(alignment: .leading, spacing: Constants.vStackSpacing) {
                    Text(option.displayName)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(description.localized)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
    }
}

/// MARK: - SortSelectionMenu
struct SortSelectionMenu: View {
    @Binding var isPresented: Bool
    @Binding var selectedSort: SortOption
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                ForEach(SortOption.allCases, id: \.self) { option in
                    SortOptionRow(
                        option: option,
                        isSelected: selectedSort == option,
                        action: {
                            selectedSort = option
                            dismiss()
                        }
                    )
                    .listRowInsets(Constants.listRowInsets)
                    .listRowSeparator(.visible)
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Sort".localized)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
        .presentationDetents([.height(Constants.presentationHeight), .medium])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(Constants.presentationCornerRadius)
    }
}
