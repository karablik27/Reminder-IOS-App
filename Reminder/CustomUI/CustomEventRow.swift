import SwiftUI
struct EventRow: View {
    
    private enum Constants {
        static let frameWidthAndHeight: CGFloat = 40
        static let padding: CGFloat = 8
        static let paddingTrailing: CGFloat = 4
        static let paddingVertical: CGFloat = 8
        static let spacing: CGFloat = 4
    }
    let model: MainModel
    
    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "bookmark")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, Constants.paddingTrailing)
            
            Image(systemName: model.icon)
                .resizable()
                .scaledToFit()
                .frame(width: Constants.frameWidthAndHeight, height: Constants.frameWidthAndHeight)
                .padding(Constants.padding)
                .background(Color(.systemGray6))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: Constants.spacing) {
                Text(model.title)
                    .font(.headline)
                Text("\(model.dateFormatted) \(model.dayOfWeek).")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("\(model.daysLeft) days")
                .font(.subheadline)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, Constants.paddingVertical)
    }
}

